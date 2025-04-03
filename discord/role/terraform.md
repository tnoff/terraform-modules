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
| [discord_role.this](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/resources/role) | resource |
| [discord_color.this](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs/data-sources/color) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hex_color"></a> [hex\_color](#input\_hex\_color) | Role color hex string | `string` | n/a | yes |
| <a name="input_hoist"></a> [hoist](#input\_hoist) | Whether role should be 'hoisted' or shown separately | `bool` | `false` | no |
| <a name="input_mentionable"></a> [mentionable](#input\_mentionable) | Whether users can @ role | `bool` | `false` | no |
| <a name="input_permission_bits"></a> [permission\_bits](#input\_permission\_bits) | Permission allow bits | `number` | n/a | yes |
| <a name="input_position"></a> [position](#input\_position) | Position in role rankings | `number` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Role Name | `string` | n/a | yes |
| <a name="input_server_id"></a> [server\_id](#input\_server\_id) | Discord Server ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role"></a> [role](#output\_role) | n/a |
<!-- END_TF_DOCS -->