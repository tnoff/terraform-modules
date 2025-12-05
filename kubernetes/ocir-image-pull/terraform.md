<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.36 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_secret.oci_docker_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_read_user_name"></a> [docker\_read\_user\_name](#input\_docker\_read\_user\_name) | Name of user for docker read | `string` | n/a | yes |
| <a name="input_docker_read_user_token"></a> [docker\_read\_user\_token](#input\_docker\_read\_user\_token) | Token for docker user read | `string` | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | List of namespaces to add secret to | `list(string)` | n/a | yes |
| <a name="input_object_storage_namespace"></a> [object\_storage\_namespace](#input\_object\_storage\_namespace) | Namespace for OCI tenancy | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->