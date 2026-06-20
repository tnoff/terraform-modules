data "oci_core_services" "this" {}

locals {
  oci_all_service_gateway = [for service in data.oci_core_services.this.services : service if length(regexall("All [A-Z]+ Services", service.name)) > 0]

  # Blue-green v2 toggle: provision the separate node/pod subnets only when their
  # CIDRs are supplied. Both are expected together for VCN-native pod networking.
  enable_node_v2 = var.node_v2_subnet_cidr_block != null
  enable_pods    = var.pod_subnet_cidr_block != null

  # CIDRs to grant API-server access from (k8s-api SL widening). Empty unless the
  # v2 subnets are enabled, so the dynamic rules in this_k8s are a no-op otherwise.
  k8s_api_extra_cidrs = compact([var.node_v2_subnet_cidr_block, var.pod_subnet_cidr_block])

  k8s_api_extra_ingress = flatten([for c in local.k8s_api_extra_cidrs : [
    { protocol = "6", cidr = c, tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null },
    { protocol = "6", cidr = c, tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null },
    { protocol = "1", cidr = c, tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 },
  ]])

  k8s_api_extra_egress = [for c in local.k8s_api_extra_cidrs : { cidr = c }]

  # peer_cidrs passed to every oke-subnet instance (node + pods roles need all four).
  oke_subnet_peer_cidrs = {
    api  = var.k8s_api_cidr_block
    node = var.node_v2_subnet_cidr_block
    pod  = var.pod_subnet_cidr_block
    lb   = var.lb_cidr_block
  }
}

########
# Common
########

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr_block
  display_name   = "${var.display_name}-network"
  # Doesn't seem to like dashes in name
  dns_label     = replace(var.display_name, "-", "")
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  lifecycle {
    ignore_changes = [
      # Remove this
      dns_label,
    ]
  }
}

resource "oci_core_service_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-all-oci-services"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  services {
    service_id = local.oci_all_service_gateway[0].id
  }
}

resource "oci_core_nat_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-nat-gateway"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  enabled        = true
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}

##############
# Route Tables
##############

resource "oci_core_route_table" "this_public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id

  display_name  = "${var.display_name}-public"
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_route_table" "this_private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id

  display_name  = "${var.display_name}-private"
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.this.id
  }
  route_rules {
    destination       = local.oci_all_service_gateway[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.this.id
  }
}

############
# API Subnet
############

resource "oci_core_security_list" "this_k8s" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-k8s-api"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  # Ingress
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.worker_subnet_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.worker_subnet_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 12250
      max = 12250
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = var.worker_subnet_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false

    icmp_options {
      code = 4
      type = 3
    }
  }

  # Blue-green v2: node VNICs (node_v2 subnet) and pods (pod subnet, VCN-native)
  # reach the API server from their own IPs, so the k8s-api SL must admit those
  # CIDRs on 6443/12250 + path-MTU ICMP. Gated on the CIDRs being set, so this is
  # a no-op for consumers that don't enable the v2 subnets (backward compatible).
  # Without these the v2 nodes never go Ready (Risk 2 in the migration spec).
  dynamic "ingress_security_rules" {
    for_each = local.k8s_api_extra_ingress
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.cidr
      source_type = "CIDR_BLOCK"
      stateless   = false

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.tcp_min == null ? [] : [1]
        content {
          min = ingress_security_rules.value.tcp_min
          max = ingress_security_rules.value.tcp_max
        }
      }

      dynamic "icmp_options" {
        for_each = ingress_security_rules.value.icmp_type == null ? [] : [1]
        content {
          type = ingress_security_rules.value.icmp_type
          code = ingress_security_rules.value.icmp_code
        }
      }
    }
  }

  # Egress
  egress_security_rules {
    destination      = local.oci_all_service_gateway[0].cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
  }

  egress_security_rules {
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "1"
    stateless        = false
    icmp_options {
      code = 4
      type = 3
    }
  }

  # Blue-green v2: return traffic / API-server-initiated connections (e.g. to
  # kubelet:10250) to the v2 node and pod CIDRs. Gated like the ingress above.
  dynamic "egress_security_rules" {
    for_each = local.k8s_api_extra_egress
    content {
      destination      = egress_security_rules.value.cidr
      destination_type = "CIDR_BLOCK"
      protocol         = "6"
      stateless        = false
    }
  }


}

resource "oci_core_subnet" "this_k8s" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  cidr_block     = var.k8s_api_cidr_block
  display_name   = "${var.display_name}-k8s-api-subnet"
  dns_label      = "k8s"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  security_list_ids = [
    oci_core_security_list.this_k8s.id
  ]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  lifecycle {
    ignore_changes = [
      dns_label
    ]
  }
}

###############
# Worker Subnet
###############

resource "oci_core_security_list" "this_worker" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-worker"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  # Ingress
  ingress_security_rules {
    protocol    = "all"
    source      = var.worker_subnet_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false
  }

  ingress_security_rules {
    protocol    = "1"
    source      = var.k8s_api_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.k8s_api_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.lb_cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false
  }

  # Egress
  egress_security_rules {
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }

  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 12250
      max = 12250
    }
  }

  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "1"
    stateless        = false
    icmp_options {
      code = 4
      type = 3
    }
  }

  egress_security_rules {
    destination      = local.oci_all_service_gateway[0].cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "1"
    stateless        = false
    icmp_options {
      code = 4
      type = 3
    }
  }

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }

  # Setup rules initially
  # But let OKE and w/e services update as necessary
  lifecycle {
    ignore_changes = [ingress_security_rules]
  }

}

resource "oci_core_subnet" "this_worker" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  cidr_block     = var.worker_subnet_cidr_block
  display_name   = "${var.display_name}-worker"
  dns_label      = "worker"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  security_list_ids = [
    oci_core_security_list.this_worker.id
  ]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  lifecycle {
    ignore_changes = [
      dns_label
    ]
  }
}

resource "oci_core_route_table_attachment" "this_worker" {
  subnet_id      = oci_core_subnet.this_worker.id
  route_table_id = oci_core_route_table.this_private.id
}

############################
# Blue-green v2 subnets
############################
# Optional separate node + pod subnets for migrating off the exhausted worker
# /24 to VCN-native pod networking. Provisioned via the generic oke-subnet module
# only when their CIDRs are set; the original 4 subnets above are untouched.

module "subnet_node_v2" {
  count  = local.enable_node_v2 ? 1 : 0
  source = "../oke-subnet"

  compartment_ocid     = var.compartment_ocid
  vcn_ocid             = oci_core_vcn.this.id
  display_name         = "${var.display_name}-node-v2"
  dns_label            = "nodev2"
  cidr_block           = var.node_v2_subnet_cidr_block
  role                 = "node"
  peer_cidrs           = local.oke_subnet_peer_cidrs
  service_gateway_cidr = local.oci_all_service_gateway[0].cidr_block
  route_table_ocid     = oci_core_route_table.this_private.id
  freeform_tags        = var.freeform_tags
  defined_tags         = var.defined_tags
}

module "subnet_pods" {
  count  = local.enable_pods ? 1 : 0
  source = "../oke-subnet"

  compartment_ocid     = var.compartment_ocid
  vcn_ocid             = oci_core_vcn.this.id
  display_name         = "${var.display_name}-pods"
  dns_label            = "pods"
  cidr_block           = var.pod_subnet_cidr_block
  role                 = "pods"
  peer_cidrs           = local.oke_subnet_peer_cidrs
  service_gateway_cidr = local.oci_all_service_gateway[0].cidr_block
  route_table_ocid     = oci_core_route_table.this_private.id
  freeform_tags        = var.freeform_tags
  defined_tags         = var.defined_tags
}


######################
# Load Balancer Subnet
######################

resource "oci_core_subnet" "this_lb" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  cidr_block     = var.lb_cidr_block
  display_name   = "${var.display_name}-lb"
  dns_label      = "lb"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  security_list_ids = [
    oci_core_security_list.this_lb.id
  ]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  lifecycle {
    ignore_changes = [
      dns_label
    ]
  }
}

resource "oci_core_security_list" "this_lb" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-lb"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  # OKE updates these rules
  lifecycle {
    ignore_changes = [
      ingress_security_rules,
      egress_security_rules
    ]
  }
}

resource "oci_core_route_table_attachment" "this_lb" {
  subnet_id      = oci_core_subnet.this_lb.id
  route_table_id = oci_core_route_table.this_public.id
}

################
# Bastion Subnet
################

resource "oci_core_security_list" "this_bastion" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-bastion"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  # Ingress
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 3000
      max = 3000
    }
  }

  # Egress
  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 12250
      max = 12250
    }
  }

  egress_security_rules {
    destination      = var.lb_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 3000
      max = 3000
    }
  }

  egress_security_rules {
    destination      = var.worker_subnet_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = 6
    stateless        = false
    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    destination      = var.k8s_api_cidr_block
    destination_type = "CIDR_BLOCK"
    protocol         = "1"
    stateless        = false
    icmp_options {
      code = 4
      type = 3
    }
  }


}

resource "oci_core_subnet" "this_bastion" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  cidr_block     = var.bastion_cidr_block
  display_name   = "${var.display_name}-bastion"
  dns_label      = "bastion"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  security_list_ids = [
    oci_core_security_list.this_bastion.id
  ]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  lifecycle {
    ignore_changes = [
      dns_label
    ]
  }
}

resource "oci_core_route_table_attachment" "this_bastion" {
  subnet_id      = oci_core_subnet.this_bastion.id
  route_table_id = oci_core_route_table.this_private.id
}