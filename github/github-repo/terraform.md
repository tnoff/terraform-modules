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
| [github_actions_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_branch.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch_default.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_issue_label.test_repo](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_topics.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_topics) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_secrets"></a> [action\_secrets](#input\_action\_secrets) | Key/Value pair for action secrets | `map(any)` | `{}` | no |
| <a name="input_action_variables"></a> [action\_variables](#input\_action\_variables) | Key/Value pair for action variables | `map(any)` | `{}` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Name of default branch | `string` | `"main"` | no |
| <a name="input_is_public"></a> [is\_public](#input\_is\_public) | Is repository public | `bool` | `true` | no |
| <a name="input_repo_description"></a> [repo\_description](#input\_repo\_description) | Description for repository | `string` | n/a | yes |
| <a name="input_repo_labels"></a> [repo\_labels](#input\_repo\_labels) | Key/Value pair of label name and color | `map(any)` | `{}` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of repository | `string` | n/a | yes |
| <a name="input_topics"></a> [topics](#input\_topics) | List of repo topics | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repo"></a> [repo](#output\_repo) | n/a |
<!-- END_TF_DOCS -->