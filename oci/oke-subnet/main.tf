# Generic OKE subnet + security list + route-table attachment.
#
# The security-list rule set is selected by var.role. Rules are expressed as
# plain data (local.rule_sets) and rendered by the dynamic blocks below, so a
# new role is added by extending the map rather than copy-pasting resources.
#
# Each rule object is normalized to a single shape (all keys present, null where
# unused) so the lists stay homogeneous:
#   ingress: { protocol, cidr, tcp_min, tcp_max, icmp_type, icmp_code }
#   egress:  { protocol, cidr, dest_type, tcp_min, tcp_max, icmp_type, icmp_code }
# protocol: "6" = TCP, "1" = ICMP, "all" = all protocols.

locals {
  rule_sets = {
    # Worker-node VNIC subnet. Mirrors the legacy combined worker SL, but with
    # node<->node and node<->pod split out now that pods live on their own subnet.
    node = {
      ingress = [
        { protocol = "all", cidr = var.peer_cidrs.node, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "all", cidr = var.peer_cidrs.pod, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "1", cidr = var.peer_cidrs.api, tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 },
        { protocol = "6", cidr = var.peer_cidrs.api, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = "0.0.0.0/0", tcp_min = 22, tcp_max = 22, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.peer_cidrs.lb, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
      ]
      egress = [
        { protocol = "all", cidr = var.peer_cidrs.node, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "all", cidr = var.peer_cidrs.pod, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.peer_cidrs.api, dest_type = "CIDR_BLOCK", tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.peer_cidrs.api, dest_type = "CIDR_BLOCK", tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null },
        { protocol = "1", cidr = var.peer_cidrs.api, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 },
        { protocol = "6", cidr = var.service_gateway_cidr, dest_type = "SERVICE_CIDR_BLOCK", tcp_min = 443, tcp_max = 443, icmp_type = null, icmp_code = null },
        { protocol = "1", cidr = "0.0.0.0/0", dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 },
        { protocol = "all", cidr = "0.0.0.0/0", dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
      ]
    }
    # VCN-native pod subnet. Pods reach the API server from their own pod IPs.
    pods = {
      ingress = [
        { protocol = "all", cidr = var.peer_cidrs.pod, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "all", cidr = var.peer_cidrs.node, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "1", cidr = var.peer_cidrs.api, tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 },
        { protocol = "6", cidr = var.peer_cidrs.api, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.peer_cidrs.lb, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
      ]
      egress = [
        { protocol = "all", cidr = var.peer_cidrs.pod, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "all", cidr = var.peer_cidrs.node, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.peer_cidrs.api, dest_type = "CIDR_BLOCK", tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.peer_cidrs.api, dest_type = "CIDR_BLOCK", tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null },
        { protocol = "6", cidr = var.service_gateway_cidr, dest_type = "SERVICE_CIDR_BLOCK", tcp_min = 443, tcp_max = 443, icmp_type = null, icmp_code = null },
        { protocol = "all", cidr = "0.0.0.0/0", dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null },
      ]
    }
  }

  ingress_rules = local.rule_sets[var.role].ingress
  egress_rules  = local.rule_sets[var.role].egress
}

resource "oci_core_security_list" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = "${var.display_name}-sl"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  dynamic "ingress_security_rules" {
    for_each = local.ingress_rules
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

  dynamic "egress_security_rules" {
    for_each = local.egress_rules
    content {
      protocol         = egress_security_rules.value.protocol
      destination      = egress_security_rules.value.cidr
      destination_type = egress_security_rules.value.dest_type
      stateless        = false

      dynamic "tcp_options" {
        for_each = egress_security_rules.value.tcp_min == null ? [] : [1]
        content {
          min = egress_security_rules.value.tcp_min
          max = egress_security_rules.value.tcp_max
        }
      }

      dynamic "icmp_options" {
        for_each = egress_security_rules.value.icmp_type == null ? [] : [1]
        content {
          type = egress_security_rules.value.icmp_type
          code = egress_security_rules.value.icmp_code
        }
      }
    }
  }

  # Setup rules initially, but let OKE and other services update them as needed
  # (OKE injects runtime rules on node/pod subnets). Matches the legacy worker SL.
  lifecycle {
    ignore_changes = [ingress_security_rules]
  }
}

resource "oci_core_subnet" "this" {
  compartment_id    = var.compartment_ocid
  vcn_id            = var.vcn_ocid
  cidr_block        = var.cidr_block
  display_name      = var.display_name
  dns_label         = var.dns_label
  freeform_tags     = var.freeform_tags
  defined_tags      = var.defined_tags
  security_list_ids = [oci_core_security_list.this.id]

  prohibit_internet_ingress  = var.prohibit_internet_ingress
  prohibit_public_ip_on_vnic = var.prohibit_public_ip_on_vnic

  lifecycle {
    ignore_changes = [dns_label]
  }
}

resource "oci_core_route_table_attachment" "this" {
  subnet_id      = oci_core_subnet.this.id
  route_table_id = var.route_table_ocid
}
