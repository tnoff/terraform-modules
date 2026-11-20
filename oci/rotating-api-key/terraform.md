<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 9.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.14 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 9.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.14 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_api_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_api_key) | resource |
| [terraform_data.version](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [time_static.rotated_at](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_generation"></a> [active\_generation](#input\_active\_generation) | Generation the outputs follow. Bump it (with keep\_previous = true) to rotate | `number` | `1` | no |
| <a name="input_keep_previous"></a> [keep\_previous](#input\_keep\_previous) | Keep generation active\_generation - 1 alive alongside the active one, for the cut-over window | `bool` | `false` | no |
| <a name="input_rsa_bits"></a> [rsa\_bits](#input\_rsa\_bits) | RSA key size | `number` | `2048` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | OCID of the OCI user the API key is registered on | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fingerprint"></a> [fingerprint](#output\_fingerprint) | Fingerprint of the active generation's API key |
| <a name="output_generations"></a> [generations](#output\_generations) | Every live generation (one, or two during an overlap): fingerprint and rotated\_at, keyed by generation number |
| <a name="output_private_key_pem"></a> [private\_key\_pem](#output\_private\_key\_pem) | Private key (PEM) of the active generation |
| <a name="output_public_key_pem"></a> [public\_key\_pem](#output\_public\_key\_pem) | Public key (PEM) of the active generation |
| <a name="output_rotated_at"></a> [rotated\_at](#output\_rotated\_at) | RFC3339 time the active generation's key was created, pinned afterwards |
<!-- END_TF_DOCS -->
