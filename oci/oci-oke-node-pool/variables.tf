variable "compartment_id" {
  type        = string
  description = "Comaprtment OCID for cluster"
}

variable "cluster_ocid" {
  type        = string
  description = "OKE Cluster OCID"
}

variable "name" {
  type        = string
  description = "Container Engine cluster name"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.33.0"
  description = "Kubernetes version for cluster"
}

variable "image_id" {
  type        = string
  default     = null
  description = "Image OCID for node pools"
}

variable "ssh_public_key" {
  type        = string
  description = "Full SSH public key"
}

variable "availability_domain" {
  type        = string
  description = "Avaibility Domain for node pools"
}

variable "worker_pool_subnet_id" {
  type        = string
  description = "Subnet OCID for Node Pools"
}

variable "node_pool_size" {
  type        = number
  default     = 1
  description = "Node pool size"
}

variable "memory_in_gbs" {
  type        = number
  default     = 6
  description = "Memory for each node in node pool"
}

variable "num_ocpus" {
  type        = number
  default     = 1
  description = "OCPUs for each node in node pool"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID, for image lookup"
}

variable "instance_tags" {
  type        = map(any)
  default     = {}
  description = "Tags for node pool instances"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Tags for created block volumes/load balancers"
}

variable "node_shape" {
  type        = string
  default     = "VM.Standard.A1.Flex"
  description = "Desired node shape"
}

variable "node_labels" {
  type        = map(any)
  default     = {}
  description = "Kubernetes node labels"
}