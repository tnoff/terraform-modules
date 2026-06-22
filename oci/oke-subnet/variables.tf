variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the subnet"
}

variable "vcn_ocid" {
  type        = string
  description = "OCID of the VCN the subnet belongs to"
}

variable "display_name" {
  type        = string
  description = "Display name for the subnet"
}

variable "dns_label" {
  type        = string
  description = "DNS label for the subnet (alphanumeric, <= 15 chars)"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "security_list_ids" {
  type        = list(string)
  description = "OCIDs of the security list(s) to associate with the subnet (created by the oke-security-lists module)"
}

variable "route_table_ocid" {
  type        = string
  default     = null
  description = "OCID of the route table to attach to the subnet. Null (default) attaches no route table, so the subnet inherits the VCN default route table (e.g. the API/control-plane subnet)."
}

variable "prohibit_internet_ingress" {
  type        = bool
  default     = true
  description = "Disallow ingress from the internet to the subnet"
}

variable "prohibit_public_ip_on_vnic" {
  type        = bool
  default     = true
  description = "Disallow public IPs on VNICs in the subnet"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for the subnet"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for the subnet"
}
