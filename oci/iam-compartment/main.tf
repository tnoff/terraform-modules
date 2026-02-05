resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  description    = "${var.display_name} compartment"
  name           = var.display_name
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}