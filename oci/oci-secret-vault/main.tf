##############
# Secret Vault
##############

resource "oci_kms_vault" "this" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}-vault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "this" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}-key"
  key_shape {
    algorithm = var.key_shape_algorithm
    length    = var.key_shape_length
  }
  management_endpoint = oci_kms_vault.this.management_endpoint
}