<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | ~> 19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | ~> 19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_branch_protection.main](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/branch_protection) | resource |
| [gitlab_pipeline_schedule.schedules](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/pipeline_schedule) | resource |
| [gitlab_project.repo](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project_push_mirror.github](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_push_mirror) | resource |
| [gitlab_project_variable.vars](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_variable) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ci_pipeline_variables_minimum_override_role"></a> [ci\_pipeline\_variables\_minimum\_override\_role](#input\_ci\_pipeline\_variables\_minimum\_override\_role) | Minimum role allowed to override CI/CD variables when running a pipeline. Also gates pipeline trigger tokens passing variables[...] on cross-project triggers. | `string` | `"no_one_allowed"` | no |
| <a name="input_ci_push_repository_for_job_token_allowed"></a> [ci\_push\_repository\_for\_job\_token\_allowed](#input\_ci\_push\_repository\_for\_job\_token\_allowed) | Allow CI job token to push to the repository | `bool` | `true` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Default branch name. Wired into both the project's default\_branch and the branch protection rule. Override to import legacy repos whose history is on a non-main branch (e.g. master). | `string` | `"main"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the project | `string` | `""` | no |
| <a name="input_import_url"></a> [import\_url](#input\_import\_url) | URL to import the repository from on creation | `string` | `null` | no |
| <a name="input_mirror_url"></a> [mirror\_url](#input\_mirror\_url) | URL (with credentials) to push-mirror this project to | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the GitLab project | `string` | n/a | yes |
| <a name="input_namespace_id"></a> [namespace\_id](#input\_namespace\_id) | ID of the group to create the project in | `number` | n/a | yes |
| <a name="input_only_allow_merge_if_pipeline_succeeds"></a> [only\_allow\_merge\_if\_pipeline\_succeeds](#input\_only\_allow\_merge\_if\_pipeline\_succeeds) | Block merges unless the pipeline passes. Disable for repos without a pipeline. | `bool` | `true` | no |
| <a name="input_pipeline_variables"></a> [pipeline\_variables](#input\_pipeline\_variables) | Map of CI/CD variable key to value, masking flag, variable type, and protected flag | <pre>map(object({<br/>    value         = string<br/>    masked        = optional(bool, true)<br/>    variable_type = optional(string, "env_var") # "env_var" or "file"<br/>    protected     = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | Map of pipeline schedules to create | <pre>map(object({<br/>    description = string<br/>    ref         = string<br/>    cron        = string<br/>    active      = optional(bool, true)<br/>  }))</pre> | `{}` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | List of topics for the project | `list(string)` | `[]` | no |
| <a name="input_visibility_level"></a> [visibility\_level](#input\_visibility\_level) | Visibility of the project: private, internal, or public | `string` | `"public"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project"></a> [project](#output\_project) | n/a |
<!-- END_TF_DOCS -->