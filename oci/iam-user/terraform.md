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
| [oci_identity_api_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_api_key) | resource |
| [oci_identity_auth_token.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_auth_token) | resource |
| [oci_identity_customer_secret_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_customer_secret_key) | resource |
| [oci_identity_group.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_user.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user) | resource |
| [oci_identity_user_group_membership.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user_group_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_policies"></a> [compartment\_policies](#input\_compartment\_policies) | Handler around setting IAM policies for user | <pre>list(object({<br/>    compartments = list(string)<br/>    verbs        = list(string)<br/>    where_clause = string<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_auth_token"></a> [enable\_auth\_token](#input\_enable\_auth\_token) | Enable auth token for user | `bool` | `true` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for user, group, and policy | `map(any)` | `{}` | no |
| <a name="input_group_display_name"></a> [group\_display\_name](#input\_group\_display\_name) | Name of group for user | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Tenancy OCID | `string` | n/a | yes |
| <a name="input_tenancy_policies"></a> [tenancy\_policies](#input\_tenancy\_policies) | Handler around setting IAM policies for user | <pre>list(object({<br/>    verbs        = list(string)<br/>    where_clause = string<br/>  }))</pre> | `[]` | no |
| <a name="input_user_display_name"></a> [user\_display\_name](#input\_user\_display\_name) | Name of bot user | `string` | n/a | yes |
| <a name="input_user_public_key"></a> [user\_public\_key](#input\_user\_public\_key) | Public key to add to user | `string` | `""` | no |
| <a name="input_user_secret_key"></a> [user\_secret\_key](#input\_user\_secret\_key) | Create user secret keys with this display name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | n/a |
| <a name="output_auth_token"></a> [auth\_token](#output\_auth\_token) | n/a |
| <a name="output_group"></a> [group](#output\_group) | n/a |
| <a name="output_secret_key"></a> [secret\_key](#output\_secret\_key) | n/a |
| <a name="output_user"></a> [user](#output\_user) | n/a |
<!-- END_TF_DOCS -->