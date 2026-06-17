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

variable "enable_ruleset" {
  type        = bool
  default     = true
  description = "Whether to create the main branch protection ruleset. Disable for repos used as push mirrors."
}

variable "enable_vulnerability_alerts" {
  type        = bool
  default     = false
  description = "Whether to enable Dependabot vulnerability alerts. Defaults to false for mirrors where scanning happens upstream."
}

variable "has_issues" {
  type        = bool
  default     = false
  description = "Enable the issues feature. Defaults to false for mirrors where issues are tracked upstream."
}

variable "has_wiki" {
  type        = bool
  default     = false
  description = "Enable the wiki feature. Defaults to false for mirrors."
}

variable "has_downloads" {
  type        = bool
  default     = false
  description = "Enable the downloads feature. Defaults to false for mirrors."
}

variable "auto_init" {
  type        = bool
  default     = false
  description = "Seed the repo with an initial README on creation. Required for new repos so `github_branch.default` and the paired GitLab mirror's `import_url` have a ref to work against. Defaults to false so existing repos aren't replaced; set to true on the caller for any new repo."
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