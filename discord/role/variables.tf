variable "server_id" {
  type        = string
  description = "Discord Server ID"
}

variable "role_name" {
  type        = string
  description = "Role Name"
}

variable "permission_bits" {
  type        = number
  description = "Permission allow bits"
}

variable "position" {
  type        = number
  description = "Position in role rankings"
}

variable "hex_color" {
  type        = string
  description = "Role color hex string"
}

variable "hoist" {
  type        = bool
  default     = false
  description = "Whether role should be 'hoisted' or shown separately"
}

variable "mentionable" {
  type        = bool
  default     = false
  description = "Whether users can @ role"
}