variable "repo_name" {
  type        = string
  description = "Github repository name"
}

variable "discord_webhook_url" {
  type        = string
  description = "Webhook url from discord server text channel"
}

variable "events" {
  type        = list(string)
  default     = ["issues", "pull_request"]
  description = "Fire webhook on github events"
}