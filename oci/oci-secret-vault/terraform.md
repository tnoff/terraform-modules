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
| [oci_kms_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_key) | resource |
| [oci_kms_vault.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_vault) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of compartment for vault | `string` | n/a | yes |
| <a name="input_key_shape_algorithm"></a> [key\_shape\_algorithm](#input\_key\_shape\_algorithm) | Key shape algorithm | `string` | `"AES"` | no |
| <a name="input_key_shape_length"></a> [key\_shape\_length](#input\_key\_shape\_length) | Key shape length | `number` | `16` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of vault | `string` | n/a | yes |
| <a name="input_protection_mode"></a> [protection\_mode](#input\_protection\_mode) | SOFTWARE/HSM | `string` | `"SOFTWARE"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Freeform tags for vault and key | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | n/a |
| <a name="output_vault"></a> [vault](#output\_vault) | n/a |
<!-- END_TF_DOCS -->