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

variable "compartments" {
  type        = list(string)
  description = "List of compartment OCIDs for verbs"
}

variable "verbs" {
  type        = list(string)
  description = "List of verbs to allow, such as 'manage object-family'"
  default     = []
}

variable "enable_auth_token" {
  type        = bool
  default     = true
  description = "Enable auth token for user"
}

variable "where_statement" {
  type        = string
  default     = ""
  description = "Where statement to add to policies, such as limiting access to one bucket"
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