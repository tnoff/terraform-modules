variable "compartment_ocid" {
  type        = string
  description = "OCID of compartment for vault"
}

variable "display_name" {
  type        = string
  description = "Name of vault"
}

variable "key_shape_algorithm" {
  type        = string
  default     = "AES"
  description = "Key shape algorithm"
}

variable "key_shape_length" {
  type        = number
  default     = 16
  description = "Key shape length"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for vault and key"
}

variable "protection_mode" {
  type        = string
  default     = "SOFTWARE"
  description = "SOFTWARE/HSM"
}