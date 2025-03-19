output "user" {
  value = oci_identity_user.this
}

output "group" {
  value = oci_identity_group.this
}

output "auth_token" {
  value = var.enable_auth_token ? oci_identity_auth_token.this.0 : ""
}