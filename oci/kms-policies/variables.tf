variable "oci_tenancy_ocid" {
  type        = string
  description = "OCI Tenancy OCID"
}

variable "kms_key_ocid" {
  type        = string
  description = "OCI KMS Key OCID"
}

variable "kms_key_compartment_name" {
  type        = string
  description = "Compartment Name for KMS Key lives"
}

variable "target_compartment_names" {
  type        = list(string)
  description = "Compartments with buckets KMS will use"
}

variable "oke_cluster_compartment_ids" {
  type        = list(string)
  description = "List of compartment OCIDs containing OKE clusters that need KMS access via resource principals"
  default     = []
}