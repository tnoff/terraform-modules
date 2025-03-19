variable "tenancy_ocid" {
  type        = string
  description = "OCI Tenancy OCID"
}

variable "name" {
  type        = string
  description = "Name of compartment and other resources"
}


variable "create_dynamic_group" {
  type        = bool
  default     = true
  description = "Create dynamic group and policies for compartment"
}

variable "extra_compartment_rules" {
  type        = list(string)
  default     = []
  description = "Extra rules for dynamic group, such as 'manage object-family in compartment foo'"
}