terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 18.2"
    }
  }
  required_version = "~> 1.9"
}
