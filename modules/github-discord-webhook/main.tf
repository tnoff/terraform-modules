resource "github_repository_webhook" "this" {
  repository = var.repo_name

  configuration {
    url          = "${var.discord_webhook_url}/github"
    content_type = "json"
    insecure_ssl = false
  }

  events = ["issues", "pull_request"]
}