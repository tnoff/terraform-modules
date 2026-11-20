<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_secret_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Extra annotations. The last\_rotated\_annotation key is always set from last\_rotated and overrides one passed here | `map(string)` | `{}` | no |
| <a name="input_data"></a> [data](#input\_data) | Secret data, key to plain-text value (the provider base64-encodes it) | `map(string)` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for the Secret | `map(string)` | `{}` | no |
| <a name="input_last_rotated"></a> [last\_rotated](#input\_last\_rotated) | When the credential in this Secret was last rotated (RFC3339), written to the last\_rotated\_annotation annotation | `string` | n/a | yes |
| <a name="input_last_rotated_annotation"></a> [last\_rotated\_annotation](#input\_last\_rotated\_annotation) | Annotation key last\_rotated is written to. The default is the key the secret-age tracker reads | `string` | `"secret-age-tracker.tnoff/last-rotated"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Secret (the same in every namespace) | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Namespaces to write the Secret to, one copy each | `set(string)` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Secret type | `string` | `"Opaque"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secrets"></a> [secrets](#output\_secrets) | The Secrets written, keyed by namespace: name and namespace |
<!-- END_TF_DOCS -->
