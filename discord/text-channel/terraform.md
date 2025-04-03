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
| [discord_channel_permission.this-allowed](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/channel_permission) | resource |
| [discord_channel_permission.this-private](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/channel_permission) | resource |
| [discord_text_channel.this](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/text_channel) | resource |
| [discord_permission.allow_channel](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/data-sources/permission) | data source |
| [discord_permission.deny_channel](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/data-sources/permission) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_roles"></a> [allowed\_roles](#input\_allowed\_roles) | Allowed roles for private channel | `list(string)` | `[]` | no |
| <a name="input_category_id"></a> [category\_id](#input\_category\_id) | Channel category ID | `string` | n/a | yes |
| <a name="input_channel_name"></a> [channel\_name](#input\_channel\_name) | Text channel name | `string` | n/a | yes |
| <a name="input_channel_topic"></a> [channel\_topic](#input\_channel\_topic) | Text channel topic | `string` | `""` | no |
| <a name="input_denied_roles"></a> [denied\_roles](#input\_denied\_roles) | Denied roles for private channel | `list(string)` | `[]` | no |
| <a name="input_position"></a> [position](#input\_position) | Channel position | `number` | n/a | yes |
| <a name="input_server_id"></a> [server\_id](#input\_server\_id) | Discord Server ID | `string` | n/a | yes |
| <a name="input_sync_perms"></a> [sync\_perms](#input\_sync\_perms) | Sync channel permissions with category | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_text_channel"></a> [text\_channel](#output\_text\_channel) | n/a |
<!-- END_TF_DOCS -->