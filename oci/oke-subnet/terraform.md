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
| [oci_core_subnet.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | Compartment OCID for the subnet | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for the subnet | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the subnet | `string` | n/a | yes |
| <a name="input_dns_label"></a> [dns\_label](#input\_dns\_label) | DNS label for the subnet (alphanumeric, <= 15 chars) | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for the subnet | `map(any)` | `{}` | no |
| <a name="input_prohibit_internet_ingress"></a> [prohibit\_internet\_ingress](#input\_prohibit\_internet\_ingress) | Disallow ingress from the internet to the subnet | `bool` | `true` | no |
| <a name="input_prohibit_public_ip_on_vnic"></a> [prohibit\_public\_ip\_on\_vnic](#input\_prohibit\_public\_ip\_on\_vnic) | Disallow public IPs on VNICs in the subnet | `bool` | `true` | no |
| <a name="input_route_table_ocid"></a> [route\_table\_ocid](#input\_route\_table\_ocid) | OCID of the route table to attach to the subnet. Null (default) attaches no route table, so the subnet inherits the VCN default route table (e.g. the API/control-plane subnet). | `string` | `null` | no |
| <a name="input_security_list_ids"></a> [security\_list\_ids](#input\_security\_list\_ids) | OCIDs of the security list(s) to associate with the subnet (created by the oke-security-lists module) | `list(string)` | n/a | yes |
| <a name="input_vcn_ocid"></a> [vcn\_ocid](#input\_vcn\_ocid) | OCID of the VCN the subnet belongs to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet"></a> [subnet](#output\_subnet) | The subnet object |
<!-- END_TF_DOCS -->
