data "discord_permission" "deny_channel" {
  view_channel = "deny"
}

data "discord_permission" "allow_channel" {
  view_channel = "allow"
}

resource "discord_text_channel" "this" {
  name                     = var.channel_name
  topic                    = var.channel_topic
  category                 = var.category_id
  server_id                = var.server_id
  position                 = var.position
  sync_perms_with_category = var.sync_perms
}

resource "discord_channel_permission" "this-private" {
  for_each     = toset(var.denied_roles)
  channel_id   = discord_text_channel.this.id
  type         = "role"
  overwrite_id = each.key
  deny         = data.discord_permission.deny_channel.deny_bits
}

resource "discord_channel_permission" "this-allowed" {
  for_each     = toset(var.allowed_roles)
  channel_id   = discord_text_channel.this.id
  type         = "role"
  overwrite_id = each.key
  allow        = data.discord_permission.allow_channel.allow_bits
}