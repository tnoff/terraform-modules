variable "compartment_ocid" {
  type        = string
  description = "Comaprtment OCID for cluster"
}

variable "display_name" {
  type        = string
  description = "Container Engine cluster name"
}

variable "vcn_ocid" {
  type        = string
  description = "Virtual Cloud Network OCID for cluster"
}

variable "api_subnet_ocid" {
  type        = string
  description = "Subnet OCID for Cluster Endpoint"
}

variable "enable_public_endpoint" {
  type        = bool
  default     = false
  description = "Enable public endpoint on K8s API"
}

variable "lb_subnet_ocids" {
  type        = list(string)
  default     = []
  description = "Subnet OCIDs for service lbs"
}


variable "kubernetes_version" {
  type        = string
  default     = "1.33.0"
  description = "Kubernetes version for cluster"
}

variable "kms_key_ocid" {
  type        = string
  description = "KMS Key OCID to use for OKE encryption"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Tags for created block volumes/load balancers"
}
