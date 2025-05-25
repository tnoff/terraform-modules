<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 6.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 6.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_artifacts_container_repository.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/artifacts_container_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of compartment for container repo | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to add | `map(string)` | n/a | yes |
| <a name="input_is_immutable"></a> [is\_immutable](#input\_is\_immutable) | If artifacts can be overriden | `bool` | `false` | no |
| <a name="input_is_public"></a> [is\_public](#input\_is\_public) | If repo is publically available | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for container repo | `string` | n/a | yes |
| <a name="input_readme_text"></a> [readme\_text](#input\_readme\_text) | Readme text | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_repo"></a> [container\_repo](#output\_container\_repo) | n/a |
<!-- END_TF_DOCS -->