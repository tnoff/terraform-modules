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

variable "action_variables" {
  type        = map(any)
  default     = {}
  description = "Key/Value pair for action variables"
}

variable "dependabot_secrets" {
  type        = map(any)
  default     = {}
  description = "Key/Value pair for depenabot secrets"
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

variable "required_status_checks" {
  type        = list(string)
  default     = []
  description = "List of default status checks that must pass before merge"
}

variable "allow_auto_merge" {
  type        = bool
  default     = false
  description = "Allow auto-merge on pull requests"
}

variable "collaborators" {
  type        = map(string)
  default     = {}
  description = "Map of GitHub username to permission level for repository collaborators. Valid permissions: pull, triage, push, maintain, admin"
}

variable "bypass_actors" {
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default     = []
  description = "List of actors that can bypass branch protection rules. Each object requires actor_id, actor_type (RepositoryRole, Team, Integration, OrganizationAdmin), and bypass_mode (always, pull_request). Note: individual users are not a supported actor_type - bypassing by user is not possible via rulesets. For personal repos, the repo owner already bypasses rules via the built-in Admin role (actor_id=5, RepositoryRole), which is always included. Team and OrganizationAdmin types require an org repo."
}