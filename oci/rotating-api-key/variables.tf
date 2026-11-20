variable "user_ocid" {
  description = "OCID of the OCI user the API key is registered on"
  type        = string
}

variable "active_generation" {
  description = "Generation the outputs follow. Bump it (with keep_previous = true) to rotate"
  type        = number
  default     = 1

  validation {
    condition     = var.active_generation >= 1 && floor(var.active_generation) == var.active_generation
    error_message = "active_generation must be a whole number >= 1."
  }
}

variable "keep_previous" {
  description = "Keep generation active_generation - 1 alive alongside the active one, for the cut-over window"
  type        = bool
  default     = false
}

variable "rsa_bits" {
  description = "RSA key size"
  type        = number
  default     = 2048
}
