variable "compartment_ocid" {
  type        = string
  description = "OCID where bastion resides"
}

variable "target_subnet_ocid" {
  type        = string
  description = "OCID of subnet where bastion connects to"
}

variable "display_name" {
  type        = string
  description = "Name of bastion"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for bastion"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for bastion"
}

variable "allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of allowed CIDRs to connect to bastion"
}