variable "repo_name" {
  type        = string
  description = "Name of repository"
}

variable "repo_description" {
  type        = string
  description = "Description for repository"
}

variable "is_public" {
  type        = bool
  default     = true
  description = "Is repository public"
}

variable "action_secrets" {
  type        = map(any)
  default     = {}
  description = "Key/Value pair for action secrets"
}