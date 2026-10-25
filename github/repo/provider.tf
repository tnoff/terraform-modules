terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    # NOTE: github_actions_repository_fork_pr_contributor_approval (main.tf) only
    # exists in the tnoff/terraform-provider-github fork build, which callers
    # install under this same address. No version constraint can express that.
  }
  required_version = "~> 1.9"
}