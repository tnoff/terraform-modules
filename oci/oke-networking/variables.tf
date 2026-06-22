variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
}

variable "display_name" {
  type        = string
  description = "Name prefix for all resources"
}

variable "vcn_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR Block for entire VCN"
}

variable "node_v2_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the worker-node VNIC subnet."
}

variable "pod_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the shared VCN-native pod subnet. Large (e.g. a /18, ~16k IPs) because OCI_VCN_IP_NATIVE reserves max_pods_per_node IPs per node, not per running pod."
}

variable "k8s_api_cidr_block" {
  type        = string
  default     = "10.0.0.0/28"
  description = "CIDR block for the Kubernetes API (control-plane endpoint) subnet"
}

variable "lb_cidr_block" {
  type        = string
  default     = "10.0.20.0/24"
  description = "CIDR block for the load-balancer subnet"
}

variable "bastion_cidr_block" {
  type        = string
  default     = "10.0.30.0/24"
  description = "CIDR block for the bastion subnet"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for networking resources"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for networking resources"
}
