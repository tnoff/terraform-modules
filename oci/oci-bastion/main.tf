resource "oci_bastion_bastion" "this" {
  bastion_type                 = "STANDARD"
  compartment_id               = var.compartment_ocid
  target_subnet_id             = var.target_subnet_id
  name                         = var.name
  client_cidr_block_allow_list = var.allowed_cidrs
  freeform_tags                = var.freeform_tags
}