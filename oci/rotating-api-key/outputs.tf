output "fingerprint" {
  description = "Fingerprint of the active generation's API key"
  value       = oci_identity_api_key.this[local.active].fingerprint
}

output "private_key_pem" {
  description = "Private key (PEM) of the active generation"
  value       = tls_private_key.this[local.active].private_key_pem
  sensitive   = true
}

output "public_key_pem" {
  description = "Public key (PEM) of the active generation"
  value       = tls_private_key.this[local.active].public_key_pem
}

output "rotated_at" {
  description = "RFC3339 time the active generation's key was created, pinned afterwards"
  value       = time_static.rotated_at[local.active].rfc3339
}

output "generations" {
  description = "Every live generation (one, or two during an overlap): fingerprint and rotated_at, keyed by generation number"
  value = {
    for g, k in oci_identity_api_key.this : g => {
      fingerprint = k.fingerprint
      rotated_at  = time_static.rotated_at[g].rfc3339
    }
  }
}
