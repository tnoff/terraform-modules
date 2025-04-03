<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_discord"></a> [discord](#requirement\_discord) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_discord"></a> [discord](#provider\_discord) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [discord_category_channel.this](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/category_channel) | resource |
| [discord_channel_permission.this-allowed](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/channel_permission) | resource |
| [discord_channel_permission.this-private](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/channel_permission) | resource |
| [discord_permission.allow_channel](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/data-sources/permission) | data source |
| [discord_permission.deny_channel](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/data-sources/permission) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_roles"></a> [allowed\_roles](#input\_allowed\_roles) | Allowed roles for private channel | `list(string)` | `[]` | no |
| <a name="input_channel_group_name"></a> [channel\_group\_name](#input\_channel\_group\_name) | Name for channel group | `string` | n/a | yes |
| <a name="input_denied_roles"></a> [denied\_roles](#input\_denied\_roles) | Denied roles for private channel | `list(string)` | `[]` | no |
| <a name="input_position"></a> [position](#input\_position) | Channel position | `number` | n/a | yes |
| <a name="input_server_id"></a> [server\_id](#input\_server\_id) | Discord Server ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_channel_group"></a> [channel\_group](#output\_channel\_group) | n/a |
<!-- END_TF_DOCS -->