# ---------------------------------------------------------------------------------------------------------------------
# Inputs
# ---------------------------------------------------------------------------------------------------------------------
variable "username" {
  description = "Username (part before the @ in the email address)."
  type = string
}

variable "aliases" {
  description = "Aliases for that username."
  type = set(string)
  nullable = false
  default = []
}

variable "first_name" {
  description = "First name of the user."
  type = string
}

variable "last_name" {
  description = "Last name of the user."
  type = string
}

variable "recovery_email" {
  description = "Recovery email of the user."
  type = string
  nullable = true
  default = null
}

variable "primary_domain" {
  description = "Primary domain name."
  type = string
}

variable "forwarded_domains" {
  description = "Forwarded domain names."
  type = set(string)
  default = []
}
