data "oci_core_services" "this" {}

locals {
  oci_all_service_gateway = [for service in data.oci_core_services.this.services : service if length(regexall("All [A-Z]+ Services", service.name)) > 0]
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