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

variable "topics" {
  type        = list(string)
  default     = []
  description = "List of repo topics"
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "Name of default branch"
}

variable "repo_labels" {
  type        = map(any)
  default     = {}
  description = "Key/Value pair of label name and color"
}