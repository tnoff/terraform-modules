# Zero-downtime rotation for one OCI user's API key.
#
# The key is kept in numbered generation slots. Bumping active_generation with
# keep_previous = true mints the new key BESIDE the old one, so both are valid
# while consumers move over; setting keep_previous = false then destroys the old
# one. `terraform apply -replace=` would instead destroy first and open an auth
# gap. OCI allows 3 API keys per user, so the two-key overlap has headroom.
#
#   1. rotate:   { active_generation = N, keep_previous = true }
#   2. cut over: consumers re-render from the outputs (which follow gen N)
#   3. prune:    { active_generation = N, keep_previous = false }
#
# Each generation's rotated_at is stamped when its key's OCID first appears and
# is pinned afterwards, so it can feed a secret-age annotation directly.
#
# Adopting this from a root that already does the same thing inline: add a
# `moved` block per LIVE generation from the root's addresses to
# module.<name>.<type>.this["<gen>"] (and .version / .rotated_at for the
# terraform_data and time_static), or the keys are destroyed and recreated.

locals {
  generations = var.keep_previous ? [var.active_generation - 1, var.active_generation] : [var.active_generation]
  slots       = toset([for g in local.generations : tostring(g) if g >= 1])
  active      = tostring(var.active_generation)
}

resource "tls_private_key" "this" {
  for_each  = local.slots
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "oci_identity_api_key" "this" {
  for_each  = local.slots
  user_id   = var.user_ocid
  key_value = tls_private_key.this[each.key].public_key_pem
}

resource "terraform_data" "version" {
  for_each         = oci_identity_api_key.this
  triggers_replace = [each.value.id]
}

resource "time_static" "rotated_at" {
  for_each = terraform_data.version
  triggers = { version = each.value.id }
}
