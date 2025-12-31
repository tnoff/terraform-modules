locals {
  archive_rules = [
    {
      action      = "ARCHIVE"
      name        = "archive-after-${var.archive_after}-days"
      time_amount = var.archive_after
      target      = "objects"
    }
  ]
  delete_rules = [
    {
      action      = "DELETE"
      name        = "delete-after-${var.delete_after}-days"
      time_amount = var.delete_after
      target      = "objects"
    }
  ]
  abort_rules = [
    {
      action      = "ABORT"
      name        = "abort-incomplete-uploads-after-${var.abort_incomplete_uploads_after}-days"
      time_amount = var.abort_incomplete_uploads_after
      target      = "multipart-uploads"
    }
  ]
  archive_previous_versions_rules = [
    {
      action      = "ARCHIVE"
      name        = "archive-old-versions-after-${var.archive_previous_versions_after}-days"
      time_amount = var.archive_previous_versions_after
      target      = "previous-object-versions"
    }
  ]
  delete_previous_versions_rules = [
    {
      action      = "DELETE"
      name        = "delete-old-noncurrent-versions-after-${var.delete_previous_versions_after}-days"
      time_amount = var.delete_previous_versions_after
      target      = "previous-object-versions"
    }
  ]
  # Make conditional on all rules
  archive                   = var.archive_after != 0 ? local.archive_rules : []
  delete                    = var.delete_after != 0 ? local.delete_rules : []
  abort                     = var.abort_incomplete_uploads_after != 0 ? local.abort_rules : []
  archive_previous_versions = var.versioning_enabled && var.archive_previous_versions_after != 0 ? local.archive_previous_versions_rules : []
  delete_previous_versions  = var.versioning_enabled && var.delete_previous_versions_after != 0 ? local.delete_previous_versions_rules : []
  rules                     = concat(local.archive, local.delete, local.abort, local.archive_previous_versions, local.delete_previous_versions)
}

resource "oci_objectstorage_bucket" "this" {
  compartment_id = var.compartment_id
  name           = var.name
  namespace      = var.namespace
  freeform_tags  = var.tags
  kms_key_id     = var.kms_key_id
  versioning     = var.versioning_enabled ? "Enabled" : "Disabled"
}

resource "oci_objectstorage_object_lifecycle_policy" "this" {
  # If no rules are set, don't attempt to create
  count     = length(local.rules) > 0 ? 1 : 0
  bucket    = oci_objectstorage_bucket.this.name
  namespace = var.namespace

  dynamic "rules" {
    for_each = local.rules
    content {
      time_unit   = "DAYS"
      target      = rules.value["target"]
      is_enabled  = true
      action      = rules.value["action"]
      name        = rules.value["name"]
      time_amount = rules.value["time_amount"]
    }
  }
}

resource "oci_objectstorage_replication_policy" "this" {
  count                   = var.replication_destination != null ? 1 : 0
  bucket                  = oci_objectstorage_bucket.this.name
  destination_bucket_name = var.replication_destination.bucket_name
  destination_region_name = var.replication_destination.bucket_region
  name                    = "${var.replication_destination.bucket_name}-${var.replication_destination.bucket_region}-replication"
  namespace               = var.namespace
}