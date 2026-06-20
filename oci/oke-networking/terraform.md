<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnet_node_v2"></a> [subnet\_node\_v2](#module\_subnet\_node\_v2) | ../oke-subnet | n/a |
| <a name="module_subnet_pods"></a> [subnet\_pods](#module\_subnet\_pods) | ../oke-subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_internet_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_nat_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_nat_gateway) | resource |
| [oci_core_route_table.this_private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table.this_public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table_attachment.this_bastion](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table_attachment) | resource |
| [oci_core_route_table_attachment.this_lb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table_attachment) | resource |
| [oci_core_route_table_attachment.this_worker](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table_attachment) | resource |
| [oci_core_security_list.this_bastion](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.this_k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.this_lb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.this_worker](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_service_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_service_gateway) | resource |
| [oci_core_subnet.this_bastion](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.this_k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.this_lb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.this_worker](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_core_services.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_services) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_cidr_block"></a> [bastion\_cidr\_block](#input\_bastion\_cidr\_block) | CIDR block for bastion hosts | `string` | `"10.0.30.0/24"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Comaprtment OCID | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for networking resources | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Name prefix for all resources | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for networking resources | `map(any)` | `{}` | no |
| <a name="input_k8s_api_cidr_block"></a> [k8s\_api\_cidr\_block](#input\_k8s\_api\_cidr\_block) | CIDR block for private subnet | `string` | `"10.0.0.0/28"` | no |
| <a name="input_lb_cidr_block"></a> [lb\_cidr\_block](#input\_lb\_cidr\_block) | CIDR block for lb subnet | `string` | `"10.0.20.0/24"` | no |
| <a name="input_node_v2_subnet_cidr_block"></a> [node\_v2\_subnet\_cidr\_block](#input\_node\_v2\_subnet\_cidr\_block) | CIDR Block for the v2 worker-node subnet. When set (alongside pod\_subnet\_cidr\_block), the module provisions a separate node subnet via the oke-subnet module so a new generation of node pools can place node VNICs off the (exhausted) original /24 during a blue-green migration. Null (default) leaves the original 4-subnet topology unchanged. | `string` | `null` | no |
| <a name="input_pod_subnet_cidr_block"></a> [pod\_subnet\_cidr\_block](#input\_pod\_subnet\_cidr\_block) | CIDR Block for the shared VCN-native pod subnet. When set, the module provisions a dedicated pod subnet via the oke-subnet module. Large (e.g. a /18, ~16k IPs) because OCI\_VCN\_IP\_NATIVE reserves max\_pods\_per\_node IPs per node, not per running pod. Node pools that set pod\_subnet\_ocid draw pod IPs here instead of from the node/worker subnet. Null (default) leaves the original topology unchanged. | `string` | `null` | no |
| <a name="input_vcn_cidr_block"></a> [vcn\_cidr\_block](#input\_vcn\_cidr\_block) | CIDR Block for entire VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_worker_subnet_cidr_block"></a> [worker\_subnet\_cidr\_block](#input\_worker\_subnet\_cidr\_block) | CIDR Block for worker node subnet | `string` | `"10.0.10.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_bastion"></a> [subnet\_bastion](#output\_subnet\_bastion) | n/a |
| <a name="output_subnet_k8s"></a> [subnet\_k8s](#output\_subnet\_k8s) | n/a |
| <a name="output_subnet_lb"></a> [subnet\_lb](#output\_subnet\_lb) | n/a |
| <a name="output_subnet_node_v2"></a> [subnet\_node\_v2](#output\_subnet\_node\_v2) | n/a |
| <a name="output_subnet_pods"></a> [subnet\_pods](#output\_subnet\_pods) | n/a |
| <a name="output_subnet_worker"></a> [subnet\_worker](#output\_subnet\_worker) | n/a |
| <a name="output_vcn"></a> [vcn](#output\_vcn) | n/a |
<!-- END_TF_DOCS -->