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
| [oci_containerengine_node_pool.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Avaibility Domain for node pools | `string` | n/a | yes |
| <a name="input_cluster_ocid"></a> [cluster\_ocid](#input\_cluster\_ocid) | OKE Cluster OCID | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Comaprtment OCID for cluster | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Tags for created block volumes/load balancers | `map(any)` | `{}` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | Image OCID for node pools | `string` | `null` | no |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Tags for node pool instances | `map(any)` | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | OCID of KMS Key Id to use for nodes | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for cluster | `string` | `"1.33.0"` | no |
| <a name="input_memory_in_gbs"></a> [memory\_in\_gbs](#input\_memory\_in\_gbs) | Memory for each node in node pool | `number` | `6` | no |
| <a name="input_name"></a> [name](#input\_name) | Container Engine cluster name | `string` | n/a | yes |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | Kubernetes node labels | `map(any)` | `{}` | no |
| <a name="input_node_pool_size"></a> [node\_pool\_size](#input\_node\_pool\_size) | Node pool size | `number` | `1` | no |
| <a name="input_node_shape"></a> [node\_shape](#input\_node\_shape) | Desired node shape | `string` | `"VM.Standard.A1.Flex"` | no |
| <a name="input_num_ocpus"></a> [num\_ocpus](#input\_num\_ocpus) | OCPUs for each node in node pool | `number` | `1` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Full SSH public key | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Tenancy OCID, for image lookup | `string` | n/a | yes |
| <a name="input_worker_pool_subnet_id"></a> [worker\_pool\_subnet\_id](#input\_worker\_pool\_subnet\_id) | Subnet OCID for Node Pools | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_pool"></a> [node\_pool](#output\_node\_pool) | n/a |
<!-- END_TF_DOCS -->