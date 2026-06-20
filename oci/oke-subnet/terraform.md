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
| [oci_core_route_table_attachment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table_attachment) | resource |
| [oci_core_security_list.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Compartment OCID for the subnet and its security list | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for the subnet and security list | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the subnet (the security list is named "<display\_name>-sl") | `string` | n/a | yes |
| <a name="input_dns_label"></a> [dns\_label](#input\_dns\_label) | DNS label for the subnet (alphanumeric, <= 15 chars) | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for the subnet and security list | `map(any)` | `{}` | no |
| <a name="input_peer_cidrs"></a> [peer\_cidrs](#input\_peer\_cidrs) | CIDRs of peer subnets referenced by this subnet's security-list rules. The 'node' and 'pods' roles require all four keys (api, node, pod, lb). | <pre>object({<br/>    api  = optional(string)<br/>    node = optional(string)<br/>    pod  = optional(string)<br/>    lb   = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_prohibit_internet_ingress"></a> [prohibit\_internet\_ingress](#input\_prohibit\_internet\_ingress) | Disallow ingress from the internet to the subnet | `bool` | `true` | no |
| <a name="input_prohibit_public_ip_on_vnic"></a> [prohibit\_public\_ip\_on\_vnic](#input\_prohibit\_public\_ip\_on\_vnic) | Disallow public IPs on VNICs in the subnet | `bool` | `true` | no |
| <a name="input_role"></a> [role](#input\_role) | Subnet role; selects the baked-in security-list rule set. Implemented roles: 'node' (worker-node VNICs) and 'pods' (VCN-native pod IPs). | `string` | n/a | yes |
| <a name="input_route_table_ocid"></a> [route\_table\_ocid](#input\_route\_table\_ocid) | OCID of the route table to attach to the subnet (typically the private/NAT route table) | `string` | n/a | yes |
| <a name="input_service_gateway_cidr"></a> [service\_gateway\_cidr](#input\_service\_gateway\_cidr) | The 'all <REGION> services' CIDR label of the VCN service gateway, used as the destination for the SERVICE\_CIDR\_BLOCK egress rule (e.g. tcp 443 to OCI services). | `string` | n/a | yes |
| <a name="input_vcn_ocid"></a> [vcn\_ocid](#input\_vcn\_ocid) | OCID of the VCN the subnet belongs to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_list"></a> [security\_list](#output\_security\_list) | n/a |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | n/a |
<!-- END_TF_DOCS -->
