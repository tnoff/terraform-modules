variable "tenancy_ocid" {
  type        = string
  description = "OCI Tenancy OCID"
}

variable "display_name" {
  type        = string
  description = "Name of compartment and other resources"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for compartment"
}