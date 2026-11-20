<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 9.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 9.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.14 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_customer_secret_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_customer_secret_key) | resource |
| [terraform_data.version](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [time_static.rotated_at](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_generation"></a> [active\_generation](#input\_active\_generation) | Generation the outputs follow. Bump it (with keep\_previous = true) to rotate | `number` | `1` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the customer secret key (every generation gets the same one) | `string` | n/a | yes |
| <a name="input_keep_previous"></a> [keep\_previous](#input\_keep\_previous) | Keep generation active\_generation - 1 alive alongside the active one, for the cut-over window | `bool` | `false` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | OCID of the OCI user the customer secret key belongs to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | Access key (the customer secret key's OCID) of the active generation |
| <a name="output_generations"></a> [generations](#output\_generations) | Every live generation (one, or two during an overlap): rotated\_at, keyed by generation number |
| <a name="output_rotated_at"></a> [rotated\_at](#output\_rotated\_at) | RFC3339 time the active generation's pair was created, pinned afterwards |
| <a name="output_secret_key"></a> [secret\_key](#output\_secret\_key) | Secret key of the active generation |
<!-- END_TF_DOCS -->
