resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  description    = "${var.name} compartment"
  name           = var.name
}