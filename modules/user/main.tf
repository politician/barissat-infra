# ---------------------------------------------------------------------------------------------------------------------
# Primary domain
# ---------------------------------------------------------------------------------------------------------------------
# resource "googleworkspace_user" "test" {
#   provider = googleworkspace.barissat
#   primary_email = "test@barissat.com"
#   # recovery_email = "barissat@gmail.com"
#   # change_password_at_next_login = true
#   # password      = md5("helloworld")
#   password      = "34819d7beeabb9260a5c854bc85b3e44"
#   hash_function = "MD5"
#   name {
#     family_name = "Barissat"
#     given_name  = "Test"
#   }
# }

data "googleworkspace_users" "my-domain-users" {}

output "num_users" {
  value = length(data.googleworkspace_users.my-domain-users.users)
}

# ---------------------------------------------------------------------------------------------------------------------
# Forwarded domains
# ---------------------------------------------------------------------------------------------------------------------
resource "restapi_object" "aliases" {
  for_each = var.forwarded_domains
  path  = "/v1/domains/${each.key}/aliases"
  data = jsonencode(
    {
      "name" : format("/^(.+\\.)?(%s)(\\+.+)?$/", join("|", setunion([var.username], var.aliases))),
      "is_enabled": true,
      "description": "${var.first_name} ${var.last_name}",
      "labels": ["terraform"]
      "recipients" : [
        format("%s@%s", var.username, var.primary_domain)
      ]
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "email_addresses" {
  value = concat(
    //[data.googleworkspace_users.my-domain-users.users],
    [for domain in var.forwarded_domains : format("%s@%s", replace(restapi_object.aliases[domain].api_data.name, "/(^/|/$)/", ""), domain)]
  )
}
