locals {
  archive_rules = [
    {
      action      = "ARCHIVE"
      name        = "archive-after-${var.archive_after}-days"
      time_amount = var.archive_after
    }
  ]
  delete_rules = [
    {
      action      = "DELETE"
      name        = "delete-after-${var.delete_after}-days"
      time_amount = var.delete_after
    }
  ]
  # Make conditional on both rules
  archive = var.archive_after != 0 ? local.archive_rules : []
  delete  = var.delete_after != 0 ? local.delete_rules : []
  rules   = concat(local.archive, local.delete)
}

resource "oci_objectstorage_bucket" "this" {
  compartment_id = var.compartment_id
  name           = var.name
  namespace      = var.namespace
  freeform_tags  = var.tags
}

resource "oci_objectstorage_object_lifecycle_policy" "this" {
  # If neither rule is set, don't attempt to create
  count     = var.archive_after == 0 && var.delete_after == 0 ? 0 : 1
  bucket    = oci_objectstorage_bucket.this.name
  namespace = var.namespace

  dynamic "rules" {
    for_each = local.rules
    content {
      time_unit   = "DAYS"
      target      = "objects"
      is_enabled  = true
      action      = rules.value["action"]
      name        = rules.value["name"]
      time_amount = rules.value["time_amount"]
    }
  }
}