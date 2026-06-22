# OKE networking — thin facade composing three single-purpose modules:
#   oke-vcn            : VCN + gateways + route tables
#   oke-security-lists : every security list, built from the per-role subnet CIDRs
#   oke-subnet         : one instance per subnet (subnet + optional route attach)
#
# Order is data-clean: the security lists need only CIDRs (not subnet OCIDs) and
# the subnets need the SL OCIDs at create time, so vcn -> security_lists -> subnets.
#
# The `moved` blocks at the bottom carry the live state from the previous monolith
# layout into the child modules with no destroy/recreate (OCIDs preserved). The
# only intended destroy is the retired worker subnet + its SL + route attachment,
# which are simply absent from this config.

module "vcn" {
  source = "../oke-vcn"

  compartment_ocid = var.compartment_ocid
  display_name     = var.display_name
  vcn_cidr_block   = var.vcn_cidr_block
  freeform_tags    = var.freeform_tags
  defined_tags     = var.defined_tags
}

module "security_lists" {
  source = "../oke-security-lists"

  compartment_ocid     = var.compartment_ocid
  vcn_ocid             = module.vcn.vcn.id
  display_name         = var.display_name
  service_gateway_cidr = module.vcn.service_gateway_cidr

  api_cidrs     = [var.k8s_api_cidr_block]
  node_cidrs    = [var.node_v2_subnet_cidr_block]
  pod_cidrs     = [var.pod_subnet_cidr_block]
  lb_cidrs      = [var.lb_cidr_block]
  bastion_cidrs = [var.bastion_cidr_block]

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}

# Kubernetes API / control-plane subnet. No route-table attachment (inherits the
# VCN default route table, as before) — hence route_table_ocid is left null.
module "subnet_api" {
  source = "../oke-subnet"

  compartment_ocid           = var.compartment_ocid
  vcn_ocid                   = module.vcn.vcn.id
  display_name               = "${var.display_name}-k8s-api-subnet"
  dns_label                  = "k8s"
  cidr_block                 = var.k8s_api_cidr_block
  security_list_ids          = [module.security_lists.security_list_ids.api]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  freeform_tags              = var.freeform_tags
  defined_tags               = var.defined_tags
}

module "subnet_node_v2" {
  source = "../oke-subnet"

  compartment_ocid           = var.compartment_ocid
  vcn_ocid                   = module.vcn.vcn.id
  display_name               = "${var.display_name}-node-v2"
  dns_label                  = "nodev2"
  cidr_block                 = var.node_v2_subnet_cidr_block
  security_list_ids          = [module.security_lists.security_list_ids.node]
  route_table_ocid           = module.vcn.route_table_private_id
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  freeform_tags              = var.freeform_tags
  defined_tags               = var.defined_tags
}

module "subnet_pods" {
  source = "../oke-subnet"

  compartment_ocid           = var.compartment_ocid
  vcn_ocid                   = module.vcn.vcn.id
  display_name               = "${var.display_name}-pods"
  dns_label                  = "pods"
  cidr_block                 = var.pod_subnet_cidr_block
  security_list_ids          = [module.security_lists.security_list_ids.pods]
  route_table_ocid           = module.vcn.route_table_private_id
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  freeform_tags              = var.freeform_tags
  defined_tags               = var.defined_tags
}

module "subnet_lb" {
  source = "../oke-subnet"

  compartment_ocid           = var.compartment_ocid
  vcn_ocid                   = module.vcn.vcn.id
  display_name               = "${var.display_name}-lb"
  dns_label                  = "lb"
  cidr_block                 = var.lb_cidr_block
  security_list_ids          = [module.security_lists.security_list_ids.lb]
  route_table_ocid           = module.vcn.route_table_public_id
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  freeform_tags              = var.freeform_tags
  defined_tags               = var.defined_tags
}

module "subnet_bastion" {
  source = "../oke-subnet"

  compartment_ocid           = var.compartment_ocid
  vcn_ocid                   = module.vcn.vcn.id
  display_name               = "${var.display_name}-bastion"
  dns_label                  = "bastion"
  cidr_block                 = var.bastion_cidr_block
  security_list_ids          = [module.security_lists.security_list_ids.bastion]
  route_table_ocid           = module.vcn.route_table_private_id
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  freeform_tags              = var.freeform_tags
  defined_tags               = var.defined_tags
}

##########################################################################
# State moves: monolith layout -> child modules. In-place, no recreate.
##########################################################################

# VCN module
moved {
  from = oci_core_vcn.this
  to   = module.vcn.oci_core_vcn.this
}
moved {
  from = oci_core_service_gateway.this
  to   = module.vcn.oci_core_service_gateway.this
}
moved {
  from = oci_core_nat_gateway.this
  to   = module.vcn.oci_core_nat_gateway.this
}
moved {
  from = oci_core_internet_gateway.this
  to   = module.vcn.oci_core_internet_gateway.this
}
moved {
  from = oci_core_route_table.this_public
  to   = module.vcn.oci_core_route_table.this_public
}
moved {
  from = oci_core_route_table.this_private
  to   = module.vcn.oci_core_route_table.this_private
}

# Subnets (former inline + former bundled oke-subnet instances)
moved {
  from = oci_core_subnet.this_k8s
  to   = module.subnet_api.oci_core_subnet.this
}
moved {
  from = oci_core_subnet.this_lb
  to   = module.subnet_lb.oci_core_subnet.this
}
moved {
  from = oci_core_subnet.this_bastion
  to   = module.subnet_bastion.oci_core_subnet.this
}
moved {
  from = module.subnet_node_v2[0].oci_core_subnet.this
  to   = module.subnet_node_v2.oci_core_subnet.this
}
moved {
  from = module.subnet_pods[0].oci_core_subnet.this
  to   = module.subnet_pods.oci_core_subnet.this
}

# Route-table attachments (now count-based inside oke-subnet -> index [0])
moved {
  from = oci_core_route_table_attachment.this_lb
  to   = module.subnet_lb.oci_core_route_table_attachment.this[0]
}
moved {
  from = oci_core_route_table_attachment.this_bastion
  to   = module.subnet_bastion.oci_core_route_table_attachment.this[0]
}
moved {
  from = module.subnet_node_v2[0].oci_core_route_table_attachment.this
  to   = module.subnet_node_v2.oci_core_route_table_attachment.this[0]
}
moved {
  from = module.subnet_pods[0].oci_core_route_table_attachment.this
  to   = module.subnet_pods.oci_core_route_table_attachment.this[0]
}

# Security lists -> central oke-security-lists module
moved {
  from = oci_core_security_list.this_k8s
  to   = module.security_lists.oci_core_security_list.managed["api"]
}
moved {
  from = oci_core_security_list.this_bastion
  to   = module.security_lists.oci_core_security_list.managed["bastion"]
}
moved {
  from = oci_core_security_list.this_lb
  to   = module.security_lists.oci_core_security_list.lb
}
moved {
  from = module.subnet_node_v2[0].oci_core_security_list.this
  to   = module.security_lists.oci_core_security_list.oke_managed_ingress["node"]
}
moved {
  from = module.subnet_pods[0].oci_core_security_list.this
  to   = module.security_lists.oci_core_security_list.oke_managed_ingress["pods"]
}
