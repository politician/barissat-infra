// Load config file
data "sops_file" "config" {
  source_file = "${path.module}/config.enc.json"
}

locals {
  config = nonsensitive(jsondecode(data.sops_file.config.raw))
}

// Get normalized usernames
module "normalize" {
  source  = "Olivr/normalize/null"
  version = "1.0.0"
  for_each = toset([for member in local.config.members : member.first_name])
  # for_each = nonsensitive(jsondecode(data.sops_file.config.raw)).members
  string   = each.value
}

locals {
  members = { for member in local.config.members : module.normalize[member.first_name].lower => member }
}

// Create emails for each family member
module "members" {
  source   = "./modules/user"
  for_each = local.members

  username          = each.key
  aliases           = lookup(each.value, "aliases", [])
  first_name        = title(each.value.first_name)
  last_name         = title(lookup(each.value, "last_name", "Barissat"))
  recovery_email    = lookup(each.value, "recovery_email", null)
  primary_domain    = local.config["primary_domain"]
  forwarded_domains = local.config["forwarded_domains"]
}

output "email_addresses" {
  value = { for member in keys(local.members) : member => module.members[member].email_addresses }
}
