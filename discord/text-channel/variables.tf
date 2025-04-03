variable "server_id" {
  type        = string
  description = "Discord Server ID"
}

variable "channel_name" {
  type        = string
  description = "Text channel name"
}

variable "channel_topic" {
  type        = string
  default     = ""
  description = "Text channel topic"
}

variable "category_id" {
  type        = string
  description = "Channel category ID"
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


variable "sync_perms" {
  type        = bool
  default     = true
  description = "Sync channel permissions with category"
}