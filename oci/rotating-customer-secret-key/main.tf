# Zero-downtime rotation for one OCI user's customer secret key (an S3-compatible
# access/secret pair).
#
# Same generation-slot scheme as oci/rotating-api-key: bump active_generation with
# keep_previous = true to mint the new pair beside the old one, cut consumers over,
# then set keep_previous = false to destroy the old pair.
#
# OCI allows only 2 customer secret keys per user, so the overlap sits exactly at
# the cap: the user must hold no customer secret key other than this module's
# before a rotation starts, or the new one is refused.
#
# Adopting this from a root that already does the same thing inline: add a
# `moved` block per LIVE generation from the root's addresses to
# module.<name>.oci_identity_customer_secret_key.this["<gen>"] (and .version /
# .rotated_at), or the pair is destroyed and recreated.

locals {
  generations = var.keep_previous ? [var.active_generation - 1, var.active_generation] : [var.active_generation]
  slots       = toset([for g in local.generations : tostring(g) if g >= 1])
  active      = tostring(var.active_generation)
}

resource "oci_identity_customer_secret_key" "this" {
  for_each     = local.slots
  display_name = var.display_name
  user_id      = var.user_ocid
}

resource "terraform_data" "version" {
  for_each         = oci_identity_customer_secret_key.this
  triggers_replace = [each.value.id]
}

resource "time_static" "rotated_at" {
  for_each = terraform_data.version
  triggers = { version = each.value.id }
}
