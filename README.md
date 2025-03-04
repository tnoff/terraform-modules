# Terraform Modules

A collection of terraform modules from my personal development.

## Github

Github repos and other defaults for repositories. Includes support for injecting action secrets.

Requires a [github provider](https://registry.terraform.io/providers/integrations/github/6.6.0) installed.

provider.tf
```
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = "~> 1.9"
}

provider "github" {
  alias = "personal"
  token = var.github_token
}
```

## Development

Install the terraform-docs pre-commit hook:

```
pre-commit install
```