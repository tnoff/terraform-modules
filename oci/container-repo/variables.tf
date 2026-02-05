variable "compartment_ocid" {
  type        = string
  description = "OCID of compartment for container repo"
}

variable "display_name" {
  type        = string
  description = "Name for container repo"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for container repository"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for container repository"
}

variable "is_immutable" {
  type        = bool
  default     = false
  description = "If artifacts can be overriden"
}

variable "is_public" {
  type        = bool
  default     = false
  description = "If repo is publically available"
}

variable "readme_text" {
  type        = string
  description = "Readme text"
}