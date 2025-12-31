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
| [oci_containerengine_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_subnet_ocid"></a> [api\_subnet\_ocid](#input\_api\_subnet\_ocid) | Subnet OCID for Cluster Endpoint | `string` | n/a | yes |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Comaprtment OCID for cluster | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Container Engine cluster name | `string` | n/a | yes |
| <a name="input_enable_public_endpoint"></a> [enable\_public\_endpoint](#input\_enable\_public\_endpoint) | Enable public endpoint on K8s API | `bool` | `false` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Tags for created block volumes/load balancers | `map(any)` | `{}` | no |
| <a name="input_kms_key_ocid"></a> [kms\_key\_ocid](#input\_kms\_key\_ocid) | KMS Key OCID to use for OKE encryption | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for cluster | `string` | `"1.33.0"` | no |
| <a name="input_lb_subnet_ocids"></a> [lb\_subnet\_ocids](#input\_lb\_subnet\_ocids) | Subnet OCIDs for service lbs | `list(string)` | `[]` | no |
| <a name="input_vcn_ocid"></a> [vcn\_ocid](#input\_vcn\_ocid) | Virtual Cloud Network OCID for cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | n/a |
<!-- END_TF_DOCS -->