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

variable "allow_update_branch" {
  type        = bool
  default     = true
  description = "Always suggest updating pull request branches. Under a ruleset with strict_required_status_checks_policy, a PR whose base has moved is BEHIND and cannot merge, and GitHub's auto-merge will not update it unless this is set -- seven bot PRs were stuck that way fleet-wide on 2026-08-31, the oldest for four days. Defaults to TRUE, against the provider default, because every repo here carries that ruleset and none of them wants the stall. Measured on dappertable#130 before the rollout: with the flag on, GitHub created the merge commit itself and auto-merge completed. Note the flag is inert on a repo with no ruleset -- nothing then requires an up-to-date branch -- which is every private repo on this account, since rulesets need GitHub Pro."
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

variable "required_approving_review_count" {
  type        = number
  default     = 0
  description = "Approving reviews required before a PR can merge. The provider default is 0, and 0 is why require_code_owner_review below does nothing: the code-owner requirement is a sub-condition of requiring approvals, so with no approval required there is none for an owner to qualify. Measured 2026-09-02 on discord-bot#904 -- reviewDecision: null, no review required. Set to 1 to make both real, which is also what makes GitHub request review from the CODEOWNERS entry (that request is NOT being sent today). Note a solo maintainer cannot approve their own PR, so at 1 their own PRs fall to the Admin bypass_actor; a bot's PRs are unaffected, since the owner approving a bot PR is not self-approval."
}

variable "restrict_updates" {
  type        = bool
  default     = false
  description = "Restrict updates to the matching refs to bypass actors only. This is what makes \"tnoff-robot cannot merge\" enforced rather than merely configured: merging a PR updates the default branch, so with this on, only the Admin bypass_actor can do it -- no workflow change or misconfiguration can hand the ability back. Defaults to false because it forecloses platform automerge entirely; a repo that wants Renovate to merge itself must leave this off."
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