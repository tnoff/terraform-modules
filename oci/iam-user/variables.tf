variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID"
}

variable "user_display_name" {
  type        = string
  description = "Name of bot user"
}

variable "group_display_name" {
  type        = string
  description = "Name of group for user"
}

variable "compartment_policies" {
  type = list(object({
    compartments = list(string)
    verbs        = list(string)
    where_clause = string
  }))
  default     = []
  description = "Handler around setting IAM policies for user"
}

variable "tenancy_policies" {
  type = list(object({
    verbs        = list(string)
    where_clause = string
  }))
  default     = []
  description = "Handler around setting IAM policies for user"
}

variable "enable_auth_token" {
  type        = bool
  default     = true
  description = "Enable auth token for user"
}

variable "user_public_key" {
  type        = string
  default     = ""
  description = "Public key to add to user"
}

variable "user_secret_key" {
  type        = string
  default     = ""
  description = "Create user secret keys with this display name"
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for user, group, and policy"
}