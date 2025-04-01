<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_discord_webhook_url"></a> [discord\_webhook\_url](#input\_discord\_webhook\_url) | Webhook url from discord server text channel | `string` | n/a | yes |
| <a name="input_events"></a> [events](#input\_events) | Fire webhook on github events | `list(string)` | <pre>[<br/>  "issues",<br/>  "pull_request"<br/>]</pre> | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Github repository name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->