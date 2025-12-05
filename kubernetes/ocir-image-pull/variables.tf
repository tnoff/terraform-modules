variable "object_storage_namespace" {
  type        = string
  description = "Namespace for OCI tenancy"
}

variable "docker_read_user_name" {
  type        = string
  description = "Name of user for docker read"
}

variable "docker_read_user_token" {
  type        = string
  description = "Token for docker user read"
}

variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to add secret to"
}