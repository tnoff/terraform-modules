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

variable "enable_node_init_customizations" {
  type        = bool
  default     = false
  description = "Enable a custom cloud-init user_data script that (1) extends the root partition to the full boot volume via oci-growfs, (2) starts kubelet with aggressive image-GC thresholds, and (3) caps oracle-cloud-agent-updater memory to mitigate dnf OOM. The script always re-runs the default OKE init first, so nodes still join the cluster normally."
}

variable "osms_memory_limit_mb" {
  type        = number
  default     = 512
  description = "Memory cap in MB applied to oracle-cloud-agent-updater via systemd MemoryMax when enable_node_init_customizations is true. dnf will be OOM-killed at this threshold before Kubernetes pods are affected."

  validation {
    condition     = var.osms_memory_limit_mb >= 256 && var.osms_memory_limit_mb <= 4096
    error_message = "osms_memory_limit_mb must be between 256 and 4096."
  }
}

variable "image_gc_high_threshold_percent" {
  type        = number
  default     = 60
  description = "Disk-usage % at which kubelet starts garbage-collecting unused images. Lowered from the kubelet default (85) because OKE OL8 boot volumes are small (~38 GiB usable on a 50 GB volume) and the steady-state image cache can sit close to the eviction threshold. Only applied when enable_node_init_customizations is true."

  validation {
    condition     = var.image_gc_high_threshold_percent > var.image_gc_low_threshold_percent && var.image_gc_high_threshold_percent <= 100
    error_message = "image_gc_high_threshold_percent must be greater than image_gc_low_threshold_percent and at most 100."
  }
}

variable "image_gc_low_threshold_percent" {
  type        = number
  default     = 40
  description = "Disk-usage % kubelet aims to reach when garbage-collecting images. Only applied when enable_node_init_customizations is true."

  validation {
    condition     = var.image_gc_low_threshold_percent >= 0 && var.image_gc_low_threshold_percent < 100
    error_message = "image_gc_low_threshold_percent must be between 0 and 99."
  }
}

variable "node_metadata" {
  type        = map(string)
  default     = {}
  description = "Additional metadata key/value pairs to add to each node instance"
}