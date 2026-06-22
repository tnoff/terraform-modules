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

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_security_list.lb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.managed](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.oke_managed_ingress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_cidrs"></a> [api\_cidrs](#input\_api\_cidrs) | CIDRs of the Kubernetes API (control-plane endpoint) subnet(s) | `list(string)` | `[]` | no |
| <a name="input_bastion_cidrs"></a> [bastion\_cidrs](#input\_bastion\_cidrs) | CIDRs of the bastion subnet(s) | `list(string)` | `[]` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Compartment OCID for the security lists | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for the security lists | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Name prefix for the security lists (each list is named "<display\_name>-<role>") | `string` | n/a | yes |
| <a name="input_external_api_ingress_cidrs"></a> [external\_api\_ingress\_cidrs](#input\_external\_api\_ingress\_cidrs) | CIDRs allowed to reach the Kubernetes API server on 6443 (public kubectl access). Default 0.0.0.0/0. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for the security lists | `map(any)` | `{}` | no |
| <a name="input_lb_cidrs"></a> [lb\_cidrs](#input\_lb\_cidrs) | CIDRs of the load-balancer subnet(s) (lb\_subnets) | `list(string)` | `[]` | no |
| <a name="input_node_cidrs"></a> [node\_cidrs](#input\_node\_cidrs) | CIDRs of the worker-node VNIC subnet(s) (a.k.a. worker\_subnets) | `list(string)` | `[]` | no |
| <a name="input_pod_cidrs"></a> [pod\_cidrs](#input\_pod\_cidrs) | CIDRs of the VCN-native pod subnet(s) | `list(string)` | `[]` | no |
| <a name="input_service_gateway_cidr"></a> [service\_gateway\_cidr](#input\_service\_gateway\_cidr) | The 'all <REGION> services' CIDR label of the VCN service gateway (oke-vcn's service\_gateway\_cidr output), used as the SERVICE\_CIDR\_BLOCK egress destination | `string` | n/a | yes |
| <a name="input_vcn_ocid"></a> [vcn\_ocid](#input\_vcn\_ocid) | OCID of the VCN the security lists belong to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_list_ids"></a> [security\_list\_ids](#output\_security\_list\_ids) | Map of role => security-list OCID, for wiring into each subnet's security\_list\_ids |
<!-- END_TF_DOCS -->