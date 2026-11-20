output "access_key" {
  description = "Access key (the customer secret key's OCID) of the active generation"
  value       = oci_identity_customer_secret_key.this[local.active].id
  sensitive   = true
}

output "secret_key" {
  description = "Secret key of the active generation"
  value       = oci_identity_customer_secret_key.this[local.active].key
  sensitive   = true
}

output "rotated_at" {
  description = "RFC3339 time the active generation's pair was created, pinned afterwards"
  value       = time_static.rotated_at[local.active].rfc3339
}

output "generations" {
  description = "Every live generation (one, or two during an overlap): rotated_at, keyed by generation number"
  value = {
    for g, _ in oci_identity_customer_secret_key.this : g => {
      rotated_at = time_static.rotated_at[g].rfc3339
    }
  }
}
