# Central OKE security lists.
#
# Every security list for the VCN is created here from the per-role subnet CIDR
# lists (api_cidrs, node_cidrs, pod_cidrs, lb_cidrs, bastion_cidrs). Because the
# rules cross-reference *other* subnets' CIDRs (a node SL admits the api/lb/pod
# CIDRs; the api SL admits the node/pod CIDRs), centralizing them here — where
# every subnet is visible — removes the per-subnet peer-threading and lets a new
# subnet of an existing role be added by appending one CIDR to a list.
#
# Rules are expressed as plain data and rendered by the dynamic blocks below.
# Normalized shapes (all keys present, null where unused):
#   ingress: { protocol, cidr, tcp_min, tcp_max, icmp_type, icmp_code }
#   egress:  { protocol, cidr, dest_type, tcp_min, tcp_max, icmp_type, icmp_code }
# protocol: "6" = TCP (no tcp_* ⇒ all ports), "1" = ICMP, "all" = all protocols.

locals {
  # The api SL admits node + pod CIDRs identically (6443/12250/path-MTU ICMP).
  api_peer_cidrs = concat(var.node_cidrs, var.pod_cidrs)

  api_ingress = concat(
    [for c in var.external_api_ingress_cidrs : { protocol = "6", cidr = c, tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null }],
    [for c in local.api_peer_cidrs : { protocol = "6", cidr = c, tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null }],
    [for c in local.api_peer_cidrs : { protocol = "6", cidr = c, tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null }],
    [for c in local.api_peer_cidrs : { protocol = "1", cidr = c, tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 }],
  )
  api_egress = concat(
    [{ protocol = "6", cidr = var.service_gateway_cidr, dest_type = "SERVICE_CIDR_BLOCK", tcp_min = 443, tcp_max = 443, icmp_type = null, icmp_code = null }],
    [for c in local.api_peer_cidrs : { protocol = "all", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
  )

  node_ingress = concat(
    [for c in var.node_cidrs : { protocol = "all", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.pod_cidrs : { protocol = "all", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "1", cidr = c, tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [{ protocol = "6", cidr = "0.0.0.0/0", tcp_min = 22, tcp_max = 22, icmp_type = null, icmp_code = null }],
    [for c in var.lb_cidrs : { protocol = "6", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
  )
  node_egress = concat(
    [for c in var.node_cidrs : { protocol = "all", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.pod_cidrs : { protocol = "all", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "1", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 }],
    [{ protocol = "6", cidr = var.service_gateway_cidr, dest_type = "SERVICE_CIDR_BLOCK", tcp_min = 443, tcp_max = 443, icmp_type = null, icmp_code = null }],
    [{ protocol = "1", cidr = "0.0.0.0/0", dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 }],
    [{ protocol = "all", cidr = "0.0.0.0/0", dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
  )

  pods_ingress = concat(
    [for c in var.pod_cidrs : { protocol = "all", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.node_cidrs : { protocol = "all", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "1", cidr = c, tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.lb_cidrs : { protocol = "6", cidr = c, tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
  )
  pods_egress = concat(
    [for c in var.pod_cidrs : { protocol = "all", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.node_cidrs : { protocol = "all", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null }],
    [{ protocol = "6", cidr = var.service_gateway_cidr, dest_type = "SERVICE_CIDR_BLOCK", tcp_min = 443, tcp_max = 443, icmp_type = null, icmp_code = null }],
    [{ protocol = "all", cidr = "0.0.0.0/0", dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = null, icmp_code = null }],
  )

  bastion_ingress = [
    { protocol = "6", cidr = "0.0.0.0/0", tcp_min = 22, tcp_max = 22, icmp_type = null, icmp_code = null },
    { protocol = "6", cidr = "0.0.0.0/0", tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null },
    { protocol = "6", cidr = "0.0.0.0/0", tcp_min = 3000, tcp_max = 3000, icmp_type = null, icmp_code = null },
  ]
  bastion_egress = concat(
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 6443, tcp_max = 6443, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 22, tcp_max = 22, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 12250, tcp_max = 12250, icmp_type = null, icmp_code = null }],
    [for c in var.lb_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 3000, tcp_max = 3000, icmp_type = null, icmp_code = null }],
    [for c in var.node_cidrs : { protocol = "6", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = 22, tcp_max = 22, icmp_type = null, icmp_code = null }],
    [for c in var.api_cidrs : { protocol = "1", cidr = c, dest_type = "CIDR_BLOCK", tcp_min = null, tcp_max = null, icmp_type = 3, icmp_code = 4 }],
  )

  rules = {
    api     = { ingress = local.api_ingress, egress = local.api_egress }
    bastion = { ingress = local.bastion_ingress, egress = local.bastion_egress }
    node    = { ingress = local.node_ingress, egress = local.node_egress }
    pods    = { ingress = local.pods_ingress, egress = local.pods_egress }
  }

  # Display-name suffix per role (kept identical to the pre-refactor inline /
  # oke-subnet security lists so the move is a no-op rename, not a churn).
  sl_suffix = {
    api     = "k8s-api"
    node    = "node-v2-sl"
    pods    = "pods-sl"
    lb      = "lb"
    bastion = "bastion"
  }
}

# Fully terraform-managed lists (api, bastion). The api SL must NOT ignore
# ingress: under VCN-native CNI nodes and pods reach the API server from their own
# IPs, so those 6443/12250 + path-MTU ICMP rules are load-bearing (Risk 2).
resource "oci_core_security_list" "managed" {
  for_each = { for role in ["api", "bastion"] : role => local.rules[role] }

  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = "${var.display_name}-${local.sl_suffix[each.key]}"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  dynamic "ingress_security_rules" {
    for_each = each.value.ingress
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
    for_each = each.value.egress
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
}

# Node / pod lists. Seeded by terraform but OKE injects runtime ingress rules, so
# ingress is ignored after creation (matches the legacy worker / oke-subnet SLs).
resource "oci_core_security_list" "oke_managed_ingress" {
  for_each = { for role in ["node", "pods"] : role => local.rules[role] }

  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = "${var.display_name}-${local.sl_suffix[each.key]}"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  dynamic "ingress_security_rules" {
    for_each = each.value.ingress
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
    for_each = each.value.egress
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

  lifecycle {
    ignore_changes = [ingress_security_rules]
  }
}

# Load-balancer SL: OKE fully manages both directions (it adds rules per Service).
# Seeded empty; ignore all rule changes.
resource "oci_core_security_list" "lb" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  display_name   = "${var.display_name}-${local.sl_suffix["lb"]}"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags

  lifecycle {
    ignore_changes = [
      ingress_security_rules,
      egress_security_rules,
    ]
  }
}
