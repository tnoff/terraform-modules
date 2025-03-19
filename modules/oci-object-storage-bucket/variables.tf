variable "compartment_id" {
  type        = string
  description = "Compartment OCID for bucket"
}

variable "namespace" {
  type        = string
  description = "Object storage namespace for bucket"
}

variable "name" {
  type        = string
  description = "Name for bucket"
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

variable "tags" {
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