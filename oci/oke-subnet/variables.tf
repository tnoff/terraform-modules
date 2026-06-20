variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the subnet and its security list"
}

variable "vcn_ocid" {
  type        = string
  description = "OCID of the VCN the subnet belongs to"
}

variable "display_name" {
  type        = string
  description = "Display name for the subnet (the security list is named \"<display_name>-sl\")"
}

variable "dns_label" {
  type        = string
  description = "DNS label for the subnet (alphanumeric, <= 15 chars)"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "role" {
  type        = string
  description = "Subnet role; selects the baked-in security-list rule set. Implemented roles: 'node' (worker-node VNICs) and 'pods' (VCN-native pod IPs)."

  validation {
    condition     = contains(["node", "pods"], var.role)
    error_message = "role must be one of: node, pods. (api/worker/lb/bastion roles are not implemented yet.)"
  }
}

variable "peer_cidrs" {
  type = object({
    api  = optional(string)
    node = optional(string)
    pod  = optional(string)
    lb   = optional(string)
  })
  description = "CIDRs of peer subnets referenced by this subnet's security-list rules. The 'node' and 'pods' roles require all four keys (api, node, pod, lb)."
}

variable "service_gateway_cidr" {
  type        = string
  description = "The 'all <REGION> services' CIDR label of the VCN service gateway, used as the destination for the SERVICE_CIDR_BLOCK egress rule (e.g. tcp 443 to OCI services)."
}

variable "route_table_ocid" {
  type        = string
  description = "OCID of the route table to attach to the subnet (typically the private/NAT route table)"
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
  description = "Freeform tags for the subnet and security list"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for the subnet and security list"
}
