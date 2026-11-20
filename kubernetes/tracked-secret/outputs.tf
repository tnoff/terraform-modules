output "secrets" {
  description = "The Secrets written, keyed by namespace: name and namespace"
  value = {
    for ns, s in kubernetes_secret_v1.this : ns => {
      name      = s.metadata[0].name
      namespace = s.metadata[0].namespace
    }
  }
}
