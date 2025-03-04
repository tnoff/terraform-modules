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
  encrypted_value = base64encode(each.value)
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