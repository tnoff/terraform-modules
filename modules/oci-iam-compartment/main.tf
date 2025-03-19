resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  description    = "${var.name} compartment"
  name           = var.name
}

resource "oci_identity_dynamic_group" "this" {
  count          = var.create_dynamic_group ? 1 : 0
  compartment_id = var.tenancy_ocid
  name           = var.name
  description    = "${var.name} dynamic group"
  matching_rule  = "Any {instance.compartment.id='${oci_identity_compartment.this.id}'}"
}

locals {
  default_statements = [
    "Allow dynamic-group ${var.name} to manage object-family in compartment ${oci_identity_compartment.this.name}",
    "Allow dynamic-group ${var.name} to read secret-bundles in compartment ${oci_identity_compartment.this.name}",
  ]
  extra_statements = [for verb in var.extra_compartment_rules : "Allow dynamic-group ${var.name} to ${verb}"]
  all_statements   = concat(local.default_statements, local.extra_statements)
}

resource "oci_identity_policy" "this" {
  count          = var.create_dynamic_group ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "${var.name} policies"
  name           = var.name
  statements     = local.all_statements
}