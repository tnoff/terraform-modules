output "user" {
  value = oci_identity_user.this
}

output "group" {
  value = oci_identity_group.this
}

output "auth_token" {
  value     = var.enable_auth_token ? oci_identity_auth_token.this.0 : null
  sensitive = true
}

output "access_key" {
  value     = var.user_secret_key == "" ? "" : oci_identity_customer_secret_key.this.0.id
  sensitive = true
}

output "secret_key" {
  value     = var.user_secret_key == "" ? "" : oci_identity_customer_secret_key.this.0.key
  sensitive = true
}