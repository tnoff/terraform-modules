variable "server_id" {
  type        = string
  description = "Discord Server ID"
}

variable "channel_group_name" {
  type        = string
  description = "Name for channel group"
}

variable "position" {
  type        = number
  description = "Channel position"
}

variable "allowed_roles" {
  type        = list(string)
  default     = []
  description = "Allowed roles for private channel"
}

variable "denied_roles" {
  type        = list(string)
  default     = []
  description = "Denied roles for private channel"
}