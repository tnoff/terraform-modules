resource "github_repository" "this" {
  name        = var.repo_name
  description = var.repo_description

  visibility             = var.is_public == true ? "public" : "private"
  allow_auto_merge       = var.allow_auto_merge
  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_downloads          = var.has_downloads
  has_issues             = var.has_issues
  has_wiki               = var.has_wiki

  # Seeds the repo with an initial README on creation so `github_branch.default`
  # below has a `refs/heads/main` to point at and the paired `gitlab_project`'s
  # `import_url` has something to mirror. Without this, a brand-new repo
  # deadlocks: the branch resource fails with `409 Git Repository is empty` and
  # the GitLab mirror fails with `422 Unable to access repository`. Defaults to
  # false in the variable so existing repos aren't replaced; set to true on the
  # caller for any new repo.
  auto_init = var.auto_init
}

resource "github_repository_vulnerability_alerts" "this" {
  count      = var.enable_vulnerability_alerts ? 1 : 0
  repository = github_repository.this.name
}

resource "github_actions_secret" "this" {
  for_each        = tomap(var.action_secrets)
  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_dependabot_secret" "this" {
  for_each        = tomap(var.dependabot_secrets)
  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = each.value
}


resource "github_actions_variable" "this" {
  for_each      = tomap(var.action_variables)
  repository    = github_repository.this.name
  variable_name = each.key
  value         = each.value
}

resource "github_repository_collaborator" "this" {
  for_each   = tomap(var.collaborators)
  repository = github_repository.this.name
  username   = each.key
  permission = each.value
}

resource "github_issue_label" "test_repo" {
  for_each   = tomap(var.repo_labels)
  repository = github_repository.this.name
  name       = each.key
  color      = each.value
}

resource "github_repository_topics" "this" {
  repository = github_repository.this.name
  topics     = var.topics
}

resource "github_branch" "default" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = github_branch.default.branch
}


resource "github_repository_ruleset" "this" {
  count       = var.is_public && var.enable_ruleset ? 1 : 0
  name        = "main-branch-protection"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = 5 # Repository admin
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  dynamic "bypass_actors" {
    for_each = var.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    deletion                = true
    non_fast_forward        = true
    required_linear_history = false

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      required_review_thread_resolution = false
    }

    dynamic "required_status_checks" {
      for_each = length(var.required_status_checks) > 0 ? [1] : []
      content {
        dynamic "required_check" {
          for_each = var.required_status_checks
          content {
            context = required_check.value
          }
        }
        strict_required_status_checks_policy = true
      }
    }
  }
}