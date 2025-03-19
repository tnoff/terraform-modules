variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID"
}

variable "compartment_name" {
  type        = string
  description = "Compartment name for OCI Resources"
}

variable "kms_key_id" {
  type        = string
  description = "KMS Key OCID for secrets"
}