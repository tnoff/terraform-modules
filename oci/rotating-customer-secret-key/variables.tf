variable "user_ocid" {
  description = "OCID of the OCI user the customer secret key belongs to"
  type        = string
}

variable "display_name" {
  description = "Display name for the customer secret key (every generation gets the same one)"
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
