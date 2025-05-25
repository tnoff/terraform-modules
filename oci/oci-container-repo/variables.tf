variable "compartment_id" {
  type        = string
  description = "OCID of compartment for container repo"
}

variable "name" {
  type        = string
  description = "Name for container repo"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to add"
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