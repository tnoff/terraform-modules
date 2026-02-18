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
| [oci_identity_policy.kms_object_storage_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.kms_oke_cluster_resource_principal](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.kms_oke_policies](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_region_subscriptions.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_region_subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_compartment_name"></a> [kms\_key\_compartment\_name](#input\_kms\_key\_compartment\_name) | Compartment Name for KMS Key lives | `string` | n/a | yes |
| <a name="input_kms_key_ocid"></a> [kms\_key\_ocid](#input\_kms\_key\_ocid) | OCI KMS Key OCID | `string` | n/a | yes |
| <a name="input_oci_tenancy_ocid"></a> [oci\_tenancy\_ocid](#input\_oci\_tenancy\_ocid) | OCI Tenancy OCID | `string` | n/a | yes |
| <a name="input_oke_cluster_compartment_ids"></a> [oke\_cluster\_compartment\_ids](#input\_oke\_cluster\_compartment\_ids) | List of compartment OCIDs containing OKE clusters that need KMS access via resource principals | `list(string)` | `[]` | no |
| <a name="input_target_compartment_names"></a> [target\_compartment\_names](#input\_target\_compartment\_names) | Compartments with buckets KMS will use | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->