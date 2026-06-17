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
| [github_dependabot_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_secret) | resource |
| [github_issue_label.test_repo](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborator.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_ruleset.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_topics.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_topics) | resource |
| [github_repository_vulnerability_alerts.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_vulnerability_alerts) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_secrets"></a> [action\_secrets](#input\_action\_secrets) | Key/Value pair for action secrets | `map(any)` | `{}` | no |
| <a name="input_action_variables"></a> [action\_variables](#input\_action\_variables) | Key/Value pair for action variables | `map(any)` | `{}` | no |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto-merge on pull requests | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | Seed the repo with an initial README on creation. Required for new repos so `github_branch.default` and the paired GitLab mirror's `import_url` have a ref to work against. Defaults to false so existing repos aren't replaced; set to true on the caller for any new repo. | `bool` | `false` | no |
| <a name="input_bypass_actors"></a> [bypass\_actors](#input\_bypass\_actors) | List of actors that can bypass branch protection rules. Each object requires actor\_id, actor\_type (RepositoryRole, Team, Integration, OrganizationAdmin), and bypass\_mode (always, pull\_request). Note: individual users are not a supported actor\_type - bypassing by user is not possible via rulesets. For personal repos, the repo owner already bypasses rules via the built-in Admin role (actor\_id=5, RepositoryRole), which is always included. Team and OrganizationAdmin types require an org repo. | <pre>list(object({<br/>    actor_id    = number<br/>    actor_type  = string<br/>    bypass_mode = string<br/>  }))</pre> | `[]` | no |
| <a name="input_collaborators"></a> [collaborators](#input\_collaborators) | Map of GitHub username to permission level for repository collaborators. Valid permissions: pull, triage, push, maintain, admin | `map(string)` | `{}` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Name of default branch | `string` | `"main"` | no |
| <a name="input_dependabot_secrets"></a> [dependabot\_secrets](#input\_dependabot\_secrets) | Key/Value pair for depenabot secrets | `map(any)` | `{}` | no |
| <a name="input_enable_ruleset"></a> [enable\_ruleset](#input\_enable\_ruleset) | Whether to create the main branch protection ruleset. Disable for repos used as push mirrors. | `bool` | `true` | no |
| <a name="input_enable_vulnerability_alerts"></a> [enable\_vulnerability\_alerts](#input\_enable\_vulnerability\_alerts) | Whether to enable Dependabot vulnerability alerts. Defaults to false for mirrors where scanning happens upstream. | `bool` | `false` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Enable the downloads feature. Defaults to false for mirrors. | `bool` | `false` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Enable the issues feature. Defaults to false for mirrors where issues are tracked upstream. | `bool` | `false` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Enable the wiki feature. Defaults to false for mirrors. | `bool` | `false` | no |
| <a name="input_is_public"></a> [is\_public](#input\_is\_public) | Is repository public | `bool` | `true` | no |
| <a name="input_repo_description"></a> [repo\_description](#input\_repo\_description) | Description for repository | `string` | n/a | yes |
| <a name="input_repo_labels"></a> [repo\_labels](#input\_repo\_labels) | Key/Value pair of label name and color | `map(any)` | `{}` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of repository | `string` | n/a | yes |
| <a name="input_required_status_checks"></a> [required\_status\_checks](#input\_required\_status\_checks) | List of default status checks that must pass before merge | `list(string)` | `[]` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | List of repo topics | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repo"></a> [repo](#output\_repo) | n/a |
<!-- END_TF_DOCS -->