resource "cloudflare_zone" "this" {
  account_id = var.cloudflare_account_id
  zone       = var.zone_name
}

resource "cloudflare_record" "this" {
  for_each = toset(var.ip_list)
  zone_id  = cloudflare_zone.this.id
  name     = var.zone_name
  content  = each.key
  type     = "A"
  ttl      = 60
  proxied  = false
}