variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the VCN and its gateways/route tables"
}

variable "display_name" {
  type        = string
  description = "Name prefix for all VCN-level resources"
}

variable "vcn_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the entire VCN"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for the VCN resources"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for the VCN resources"
}
