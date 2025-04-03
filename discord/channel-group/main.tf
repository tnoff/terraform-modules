data "discord_permission" "deny_channel" {
  view_channel = "deny"
}

data "discord_permission" "allow_channel" {
  view_channel = "allow"
}

resource "discord_category_channel" "this" {
  name      = var.channel_group_name
  server_id = var.server_id
  position  = var.position
}

resource "discord_channel_permission" "this-private" {
  for_each     = toset(var.denied_roles)
  channel_id   = discord_category_channel.this.id
  type         = "role"
  overwrite_id = each.key
  deny         = data.discord_permission.deny_channel.deny_bits
}

resource "discord_channel_permission" "this-allowed" {
  for_each     = toset(var.allowed_roles)
  channel_id   = discord_category_channel.this.id
  type         = "role"
  overwrite_id = each.key
  allow        = data.discord_permission.allow_channel.allow_bits
}