variable "compartment_id" {
  type        = string
  description = "OCID of compartment for vault"
}

variable "name" {
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