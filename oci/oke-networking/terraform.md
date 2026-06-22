<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 8.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_lists"></a> [security\_lists](#module\_security\_lists) | ../oke-security-lists | n/a |
| <a name="module_subnet_api"></a> [subnet\_api](#module\_subnet\_api) | ../oke-subnet | n/a |
| <a name="module_subnet_bastion"></a> [subnet\_bastion](#module\_subnet\_bastion) | ../oke-subnet | n/a |
| <a name="module_subnet_lb"></a> [subnet\_lb](#module\_subnet\_lb) | ../oke-subnet | n/a |
| <a name="module_subnet_node_v2"></a> [subnet\_node\_v2](#module\_subnet\_node\_v2) | ../oke-subnet | n/a |
| <a name="module_subnet_pods"></a> [subnet\_pods](#module\_subnet\_pods) | ../oke-subnet | n/a |
| <a name="module_vcn"></a> [vcn](#module\_vcn) | ../oke-vcn | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_cidr_block"></a> [bastion\_cidr\_block](#input\_bastion\_cidr\_block) | CIDR block for the bastion subnet | `string` | `"10.0.30.0/24"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Compartment OCID | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for networking resources | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Name prefix for all resources | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for networking resources | `map(any)` | `{}` | no |
| <a name="input_k8s_api_cidr_block"></a> [k8s\_api\_cidr\_block](#input\_k8s\_api\_cidr\_block) | CIDR block for the Kubernetes API (control-plane endpoint) subnet | `string` | `"10.0.0.0/28"` | no |
| <a name="input_lb_cidr_block"></a> [lb\_cidr\_block](#input\_lb\_cidr\_block) | CIDR block for the load-balancer subnet | `string` | `"10.0.20.0/24"` | no |
| <a name="input_node_v2_subnet_cidr_block"></a> [node\_v2\_subnet\_cidr\_block](#input\_node\_v2\_subnet\_cidr\_block) | CIDR block for the worker-node VNIC subnet. | `string` | n/a | yes |
| <a name="input_pod_subnet_cidr_block"></a> [pod\_subnet\_cidr\_block](#input\_pod\_subnet\_cidr\_block) | CIDR block for the shared VCN-native pod subnet. Large (e.g. a /18, ~16k IPs) because OCI\_VCN\_IP\_NATIVE reserves max\_pods\_per\_node IPs per node, not per running pod. | `string` | n/a | yes |
| <a name="input_vcn_cidr_block"></a> [vcn\_cidr\_block](#input\_vcn\_cidr\_block) | CIDR Block for entire VCN | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_list_ids"></a> [security\_list\_ids](#output\_security\_list\_ids) | n/a |
| <a name="output_subnet_bastion"></a> [subnet\_bastion](#output\_subnet\_bastion) | n/a |
| <a name="output_subnet_k8s"></a> [subnet\_k8s](#output\_subnet\_k8s) | n/a |
| <a name="output_subnet_lb"></a> [subnet\_lb](#output\_subnet\_lb) | n/a |
| <a name="output_subnet_node_v2"></a> [subnet\_node\_v2](#output\_subnet\_node\_v2) | n/a |
| <a name="output_subnet_pods"></a> [subnet\_pods](#output\_subnet\_pods) | n/a |
| <a name="output_vcn"></a> [vcn](#output\_vcn) | n/a |
<!-- END_TF_DOCS -->