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
  default     = null
  description = "KMS Key OCID. Leave null to use Oracle-managed encryption (for example for a deliberately public bucket whose content is not sensitive)."
}

variable "access_type" {
  type        = string
  default     = "NoPublicAccess"
  description = "Public access type: NoPublicAccess, ObjectRead (public read and list) or ObjectReadWithoutList (public read of known object names, no listing). Anything other than NoPublicAccess makes the bucket's objects readable by anyone on the internet."

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.access_type)
    error_message = "access_type must be NoPublicAccess, ObjectRead or ObjectReadWithoutList."
  }
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

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for bucket"
}

variable "replication_destination" {
  type = object({
    bucket_name   = string,
    bucket_region = string
  })
  default     = null
  description = "Replication bucket settings"
}