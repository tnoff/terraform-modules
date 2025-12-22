resource "github_repository" "this" {
  name        = var.repo_name
  description = var.repo_description

  visibility             = var.is_public == true ? "public" : "private"
  allow_merge_commit     = false
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  has_downloads          = true
  has_issues             = true
  has_wiki               = true
}

resource "github_actions_secret" "this" {
  for_each        = tomap(var.action_secrets)
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


resource "github_branch_protection" "this" {
  repository_id = github_repository.this.name

  pattern          = github_branch.default.branch
  enforce_admins   = true
  allows_deletions = false

  required_status_checks {
    strict   = true
    contexts = var.required_status_checks
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    restrict_dismissals        = true
    require_code_owner_reviews = true
  }
}