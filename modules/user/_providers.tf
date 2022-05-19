terraform {
  experiments = [ module_variable_optional_attrs ]
  required_providers {
    googleworkspace = {
      source  = "hashicorp/googleworkspace"
      version = ">= 0.6.0"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = ">= 1.16.2"
    }
  }
}

## Must set the following scopes at the root level
#
# provider "googleworkspace" {  
#   oauth_scopes = [
#     "https://www.googleapis.com/auth/admin.directory.user"
#     ]
# }
