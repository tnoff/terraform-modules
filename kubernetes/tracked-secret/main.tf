# A Kubernetes Secret the secret-age tracker can see.
#
# The tracker reads the `secret-age-tracker.tnoff/last-rotated` annotation to work
# out how old a credential is. This module makes that annotation a required input,
# so a Secret cannot be created without it, and spells the key in one place.
#
# One call can write the same Secret to several namespaces (one per entry in
# `namespaces`). When the data comes from several credentials with their own
# rotation times, pass the newest as last_rotated. max() takes numbers only;
# UTC RFC3339 strings sort chronologically, so use the last element of sort().
#
# Adopting this from an inline kubernetes_secret_v1: add a `moved` block per
# namespace to module.<name>.kubernetes_secret_v1.this["<namespace>"], or the
# Secret is deleted and recreated (a brief gap for anything mounting it).

locals {
  last_rotated_annotation = "secret-age-tracker.tnoff/last-rotated"
}

resource "kubernetes_secret_v1" "this" {
  for_each = var.namespaces

  metadata {
    name        = var.name
    namespace   = each.key
    labels      = var.labels
    annotations = merge(var.annotations, { (local.last_rotated_annotation) = var.last_rotated })
  }

  type = var.type
  data = var.data
}
