variable "compartment_id" {
  type        = string
  description = "Comaprtment OCID for cluster"
}

variable "name" {
  type        = string
  description = "Container Engine cluster name"
}

variable "vcn_id" {
  type        = string
  description = "Virtual Cloud Network OCID for cluster"
}

variable "api_subnet_id" {
  type        = string
  description = "Subnet OCID for Cluster Endpoint"
}

variable "enable_public_endpoint" {
  type        = bool
  default     = false
  description = "Enable public endpoint on K8s API"
}

variable "lb_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs for service lbs"
}


variable "kubernetes_version" {
  type        = string
  default     = "1.33.0"
  description = "Kubernetes version for cluster"
}



variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Tags for created block volumes/load balancers"
}
