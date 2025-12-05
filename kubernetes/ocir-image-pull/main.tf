resource "kubernetes_secret" "oci_docker_credentials" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "oci-docker-cfg"
    namespace = each.key
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "iad.ocir.io" = {
          "auth" = base64encode("${var.object_storage_namespace}/${var.docker_read_user_name}:${var.docker_read_user_token}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}