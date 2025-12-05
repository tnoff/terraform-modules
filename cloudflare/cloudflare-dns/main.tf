resource "cloudflare_dns_record" "this" {
  for_each = toset(var.ip_list)
  zone_id  = var.zone_id
  name     = var.zone_name
  content  = each.key
  type     = "A"
  ttl      = 60
  proxied  = false
}