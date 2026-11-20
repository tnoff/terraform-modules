variable "name" {
  description = "Name of the Secret (the same in every namespace)"
  type        = string
}

variable "namespaces" {
  description = "Namespaces to write the Secret to, one copy each"
  type        = set(string)

  validation {
    condition     = length(var.namespaces) > 0
    error_message = "namespaces must name at least one namespace."
  }
}

variable "data" {
  description = "Secret data, key to plain-text value (the provider base64-encodes it)"
  type        = map(string)
  sensitive   = true
}

variable "last_rotated" {
  description = "When the credential in this Secret was last rotated (RFC3339), written to the secret-age-tracker.tnoff/last-rotated annotation"
  type        = string

  validation {
    condition     = length(trimspace(var.last_rotated)) > 0
    error_message = "last_rotated must not be empty: it is what the secret-age tracker reads."
  }
}

variable "labels" {
  description = "Labels for the Secret"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Extra annotations. The last-rotated annotation is always set from last_rotated and overrides one passed here"
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Secret type"
  type        = string
  default     = "Opaque"
}
