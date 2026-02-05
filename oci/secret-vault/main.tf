##############
# Secret Vault
##############

resource "oci_kms_vault" "this" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.display_name}-vault"
  vault_type     = "DEFAULT"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}

resource "oci_kms_key" "this" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.display_name}-key"
  key_shape {
    algorithm = var.key_shape_algorithm
    length    = var.key_shape_length
  }
  management_endpoint = oci_kms_vault.this.management_endpoint
  protection_mode     = var.protection_mode
  freeform_tags       = var.freeform_tags
  defined_tags        = var.defined_tags
}