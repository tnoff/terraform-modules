variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for bucket"
}

variable "namespace" {
  type        = string
  description = "Object storage namespace for bucket"
}

variable "display_name" {
  type        = string
  description = "Name for bucket"
}

variable "kms_key_ocid" {
  type        = string
  description = "KMS Key OCID"
}

variable "delete_after" {
  type        = number
  default     = 0
  description = "Delete objects in bucket after X days, if 0 does not set"
}

variable "archive_after" {
  type        = number
  default     = 30
  description = "Delete objects in bucket after X days, if 0 does not set"
}

variable "abort_incomplete_uploads_after" {
  type        = number
  default     = 0
  description = "Abort incomplete multipart uploads after X days, if 0 does not set"
}

variable "versioning_enabled" {
  type        = bool
  default     = false
  description = "Enable versioning on the bucket"
}

variable "archive_previous_versions_after" {
  type        = number
  default     = 0
  description = "Archive previous object versions after X days, if 0 does not set (only applies when versioning is enabled)"
}

variable "delete_previous_versions_after" {
  type        = number
  default     = 0
  description = "Delete previous object versions after X days, if 0 does not set (only applies when versioning is enabled)"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Extra freeform tags for bucket"
}

variable "replication_destination" {
  type = object({
    bucket_name   = string,
    bucket_region = string
  })
  default     = null
  description = "Replication bucket settings"
}