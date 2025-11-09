variable "compartment_id" {
  type        = string
  description = "Comaprtment OCID"
}

variable "name" {
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