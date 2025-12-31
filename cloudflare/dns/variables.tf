variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "zone_name" {
  type        = string
  description = "Name of DNS Zone to Update"
}


variable "ip_list" {
  type        = list(string)
  description = "List of IPs for A Records"
}

variable "ttl" {
  type        = number
  default     = 60
  description = "TTL of records in seconds"
}