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
| [oci_identity_compartment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for compartment | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Name of compartment and other resources | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for compartment | `map(any)` | `{}` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCI Tenancy OCID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compartment"></a> [compartment](#output\_compartment) | n/a |
<!-- END_TF_DOCS -->