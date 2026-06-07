variable "name" {
  type        = string
  description = "Name of the GitLab project"
}

variable "namespace_id" {
  type        = number
  description = "ID of the group to create the project in"
}

variable "description" {
  type        = string
  description = "Description of the project"
  default     = ""
}

variable "topics" {
  type        = list(string)
  description = "List of topics for the project"
  default     = []
}

variable "import_url" {
  type        = string
  description = "URL to import the repository from on creation"
  default     = null
}

variable "visibility_level" {
  type        = string
  description = "Visibility of the project: private, internal, or public"
  default     = "public"
}

variable "default_branch" {
  type        = string
  description = "Default branch name. Wired into both the project's default_branch and the branch protection rule. Override to import legacy repos whose history is on a non-main branch (e.g. master)."
  default     = "main"
}

variable "ci_push_repository_for_job_token_allowed" {
  type        = bool
  description = "Allow CI job token to push to the repository"
  default     = true
}

variable "ci_pipeline_variables_minimum_override_role" {
  type        = string
  description = "Minimum role allowed to override CI/CD variables when running a pipeline. Also gates pipeline trigger tokens passing variables[...] on cross-project triggers."
  default     = "no_one_allowed"
  validation {
    condition     = contains(["no_one_allowed", "developer", "maintainer", "owner"], var.ci_pipeline_variables_minimum_override_role)
    error_message = "Must be one of: no_one_allowed, developer, maintainer, owner."
  }
}

variable "only_allow_merge_if_pipeline_succeeds" {
  type        = bool
  description = "Block merges unless the pipeline passes. Disable for repos without a pipeline."
  default     = true
}

variable "push_access_level" {
  type        = string
  description = "Who can push directly to the default branch. Defaults to 'no one' so all changes go through MRs; raise to 'maintainer' to allow emergency direct pushes."
  default     = "no one"
  validation {
    condition     = contains(["no one", "developer", "maintainer", "admin"], var.push_access_level)
    error_message = "Must be one of: 'no one', developer, maintainer, admin."
  }
}

variable "pipeline_variables" {
  type = map(object({
    value         = string
    masked        = optional(bool, true)
    variable_type = optional(string, "env_var") # "env_var" or "file"
    protected     = optional(bool, false)
  }))
  description = "Map of CI/CD variable key to value, masking flag, variable type, and protected flag"
  default     = {}
}

variable "mirror_url" {
  type        = string
  description = "URL (with credentials) to push-mirror this project to"
  default     = null
  sensitive   = true
}

variable "schedules" {
  type = map(object({
    description = string
    ref         = string
    cron        = string
    active      = optional(bool, true)
  }))
  description = "Map of pipeline schedules to create"
  default     = {}
}
