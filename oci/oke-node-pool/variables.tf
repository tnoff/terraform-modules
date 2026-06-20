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
  description = "Subnet OCID for Node Pools (node VNIC placement, and pod IPs unless pod_subnet_ocid is set)"
}

variable "pod_subnet_ocid" {
  type        = string
  default     = null
  description = "Subnet OCID for VCN-native pod IPs. When null (default) pods draw IPs from worker_pool_subnet_ocid (legacy behavior). Set this to a dedicated pod subnet to avoid exhausting the node subnet (OCI_VCN_IP_NATIVE reserves max_pods_per_node IPs per node)."
}

variable "max_pods_per_node" {
  type        = number
  default     = null
  description = "Max pods per node. Drives how many pod IPs each node pre-reserves from the pod subnet under OCI_VCN_IP_NATIVE. Null (default) uses the OKE/provider default (31)."
}

variable "node_pool_size" {
  type        = number
  default     = 1
  description = "Node pool size. When ignore_node_count_changes is true this is only the initial size; the cluster autoscaler owns it thereafter."
}

variable "ignore_node_count_changes" {
  type        = bool
  default     = false
  description = "When true, terraform stops managing node_config_details.size (it is ignored via lifecycle) so an external Kubernetes Cluster Autoscaler can own the running node count without an apply fighting it. Default false keeps terraform-managed sizing for all existing consumers. Toggling this swaps which underlying resource is used (this <-> this_autoscaled); to avoid recreating a live pool, do a one-time `terraform state mv` between the two addresses in the consuming stack."
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