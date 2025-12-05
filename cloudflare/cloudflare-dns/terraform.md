<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | Cloudflare Account ID | `string` | n/a | yes |
| <a name="input_ip_list"></a> [ip\_list](#input\_ip\_list) | List of IPs for A Records | `list(string)` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL of records in seconds | `number` | `60` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ID of DNS Zone to Update | `string` | n/a | yes |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | Name of DNS Zone to Update | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->