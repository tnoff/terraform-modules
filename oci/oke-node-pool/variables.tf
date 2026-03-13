variable "compartment_ocid" {
  type        = string
  description = "Comaprtment OCID for cluster"
}

variable "cluster_ocid" {
  type        = string
  description = "OKE Cluster OCID"
}

variable "kms_key_ocid" {
  type        = string
  description = "OCID of KMS Key Id to use for nodes"
}

variable "display_name" {
  type        = string
  description = "Container Engine cluster name"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.33.0"
  description = "Kubernetes version for cluster"
}

variable "image_ocid" {
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

variable "worker_pool_subnet_ocid" {
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

variable "instance_freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for node pool instances"
}

variable "instance_defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for node pool instances"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for node pool"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for node pool"
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

variable "limit_osms_memory" {
  type        = bool
  default     = false
  description = "Mitigate dnf OOM risk by adding a swap file and capping OSMS agent memory via systemd. Keeps OSMS active for security patching while preventing runaway dnf from exhausting node memory."
}

variable "osms_swap_size_gb" {
  type        = number
  default     = 2
  description = "Size in GB of the swap file created on each node when limit_osms_memory is enabled."

  validation {
    condition     = var.osms_swap_size_gb >= 1 && var.osms_swap_size_gb <= 16
    error_message = "osms_swap_size_gb must be between 1 and 16."
  }
}

variable "node_metadata" {
  type        = map(string)
  default     = {}
  description = "Additional metadata key/value pairs to add to each node instance"
}