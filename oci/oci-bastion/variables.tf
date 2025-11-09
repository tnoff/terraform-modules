variable "compartment_ocid" {
  type        = string
  description = "OCID where bastion resides"
}

variable "target_subnet_id" {
  type        = string
  description = "OCID of subnet where bastion connects to"
}

variable "name" {
  type        = string
  description = "Name of bastion"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Tags to add to bastion"
}

variable "allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of allowed CIDRs to connect to bastion"
}