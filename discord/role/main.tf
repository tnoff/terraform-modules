data "discord_color" "this" {
  hex = var.hex_color
}

resource "discord_role" "this" {
  server_id   = var.server_id
  name        = var.role_name
  permissions = var.permission_bits
  color       = data.discord_color.this.dec
  hoist       = var.hoist
  mentionable = var.mentionable
  position    = var.position
}