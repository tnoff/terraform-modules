variable "tenancy_ocid" {
  type        = string
  description = "OCID of tenancy"
}

variable "compartment_ocids" {
  type        = list(string)
  description = "List of compartment ocids for policies"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags applied to the identity policy"
  default     = {}
}
