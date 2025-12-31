locals {
  statements = flatten([
    for compartment in var.compartments : [
      for verb in var.verbs : [
        trim("Allow group ${var.group_display_name} to ${verb} in compartment ${compartment} ${var.where_statement}", " ")
      ]
    ]
  ])
}

resource "oci_identity_user" "this" {
  compartment_id = var.tenancy_ocid
  description    = var.user_display_name
  name           = var.user_display_name
  freeform_tags  = var.freeform_tags
}

resource "oci_identity_group" "this" {
  compartment_id = var.tenancy_ocid
  description    = "${var.group_display_name} group"
  name           = var.group_display_name
  freeform_tags  = var.freeform_tags
}

resource "oci_identity_user_group_membership" "this" {
  group_id = oci_identity_group.this.id
  user_id  = oci_identity_user.this.id
}

resource "oci_identity_auth_token" "this" {
  count       = var.enable_auth_token ? 1 : 0
  description = "${var.user_display_name} auth token"
  user_id     = oci_identity_user.this.id
}

resource "oci_identity_api_key" "this" {
  count     = var.user_public_key == "" ? 0 : 1
  user_id   = oci_identity_user.this.id
  key_value = var.user_public_key
}

resource "oci_identity_customer_secret_key" "this" {
  count        = var.user_secret_key == "" ? 0 : 1
  display_name = var.user_secret_key
  user_id      = oci_identity_user.this.id
}

resource "oci_identity_policy" "this" {
  count          = length(local.statements) > 0 ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "${var.user_display_name} policies"
  name           = "${var.user_display_name}-policy"
  statements     = local.statements
  freeform_tags  = var.freeform_tags
}