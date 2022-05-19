terraform {
  experiments = [ module_variable_optional_attrs ]
  required_providers {
    googleworkspace = {
      source  = "hashicorp/googleworkspace"
      version = "~> 0.6.0"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = "~> 1.16.2"
    }
    sops = {
      source = "carlpett/sops"
      version = "~> 0.7.1"
    }
  }
}

provider "googleworkspace" {  
  customer_id = var.googleworkspace_customer_id
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    # "https://www.googleapis.com/auth/gmail.settings"
    ]
}

# Forwardemail.net
provider "restapi" {
  uri = "https://api.forwardemail.net"
  username = var.forwardemail_api_key
  password = var.forwardemail_api_key
  write_returns_object = true
  id_attribute = "id"
  rate_limit = 0.8 // 48 requests per minute
}
