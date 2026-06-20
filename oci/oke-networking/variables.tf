variable "compartment_ocid" {
  type        = string
  description = "Comaprtment OCID"
}

variable "display_name" {
  type        = string
  description = "Name prefix for all resources"
}


variable "vcn_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR Block for entire VPC"
}

variable "worker_subnet_cidr_block" {
  type        = string
  default     = "10.0.10.0/24"
  description = "CIDR Block for worker node subnet"
}

variable "node_v2_subnet_cidr_block" {
  type        = string
  default     = null
  description = "CIDR Block for the v2 worker-node subnet. When set (alongside pod_subnet_cidr_block), the module provisions a separate node subnet via the oke-subnet module so a new generation of node pools can place node VNICs off the (exhausted) original /24 during a blue-green migration. Null (default) leaves the original 4-subnet topology unchanged."
}

variable "pod_subnet_cidr_block" {
  type        = string
  default     = null
  description = "CIDR Block for the shared VCN-native pod subnet. When set, the module provisions a dedicated pod subnet via the oke-subnet module. Large (e.g. a /18, ~16k IPs) because OCI_VCN_IP_NATIVE reserves max_pods_per_node IPs per node, not per running pod. Node pools that set pod_subnet_ocid draw pod IPs here instead of from the node/worker subnet. Null (default) leaves the original topology unchanged."
}

variable "k8s_api_cidr_block" {
  type        = string
  default     = "10.0.0.0/28"
  description = "CIDR block for private subnet"
}

variable "lb_cidr_block" {
  type        = string
  default     = "10.0.20.0/24"
  description = "CIDR block for lb subnet"
}

variable "bastion_cidr_block" {
  type        = string
  default     = "10.0.30.0/24"
  description = "CIDR block for bastion hosts"
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