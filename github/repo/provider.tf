terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    # Only for restapi_object.fork_pr_approval; drop with it, see main.tf.
    restapi = {
      source  = "Mastercard/restapi"
      version = "~> 3.0"
    }
  }
  required_version = "~> 1.9"
}