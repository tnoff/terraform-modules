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
| [oci_objectstorage_bucket.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket) | resource |
| [oci_objectstorage_object_lifecycle_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object_lifecycle_policy) | resource |
| [oci_objectstorage_replication_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_replication_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abort_incomplete_uploads_after"></a> [abort\_incomplete\_uploads\_after](#input\_abort\_incomplete\_uploads\_after) | Abort incomplete multipart uploads after X days, if 0 does not set | `number` | `0` | no |
| <a name="input_archive_after"></a> [archive\_after](#input\_archive\_after) | Delete objects in bucket after X days, if 0 does not set | `number` | `30` | no |
| <a name="input_archive_previous_versions_after"></a> [archive\_previous\_versions\_after](#input\_archive\_previous\_versions\_after) | Archive previous object versions after X days, if 0 does not set (only applies when versioning is enabled) | `number` | `0` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID for bucket | `string` | n/a | yes |
| <a name="input_delete_after"></a> [delete\_after](#input\_delete\_after) | Delete objects in bucket after X days, if 0 does not set | `number` | `0` | no |
| <a name="input_delete_previous_versions_after"></a> [delete\_previous\_versions\_after](#input\_delete\_previous\_versions\_after) | Delete previous object versions after X days, if 0 does not set (only applies when versioning is enabled) | `number` | `0` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS Key OCID | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for bucket | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Object storage namespace for bucket | `string` | n/a | yes |
| <a name="input_replication_destination"></a> [replication\_destination](#input\_replication\_destination) | Replication bucket settings | <pre>object({<br/>    bucket_name   = string,<br/>    bucket_region = string<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra freeform tags for bucket | `map(any)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable versioning on the bucket | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | n/a |
<!-- END_TF_DOCS -->