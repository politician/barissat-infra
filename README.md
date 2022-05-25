# Barissat family infrastructure

## Emails

### Primary e-mails

Primary e-mails are hosted on Google workspace personal edition (legacy G-Suite). They match the regex `[\w-]+(\+.+)?@PRIMARY-DOMAIN`. Examples:

- first-name@PRIMARY-DOMAIN
- first-name+anything@PRIMARY-DOMAIN

### Forwarded e-mails

Forwarded e-mails are hosted on [Forwardemail.net](https://forwardemail.net) and forwarded to the respective primary emails. They match the regex `(.+\.)?[\w-]+(\+.+)?@FORWARDED_DOMAIN`. Examples:

- first-name@FORWARDED_DOMAIN
- first-name+anything@FORWARDED_DOMAIN
- anything.first-name@FORWARDED_DOMAIN
- anything.first-name+anything@FORWARDED_DOMAIN

### Aliases

Some family members have one or more aliases. In that case, all the above are valid for both their first name and their aliases.

## Contribute

### Manage family members and domains

The list of family members and their details is encrypted using [SOPS](https://github.com/mozilla/sops) with a key stored in [Google KMS](https://cloud.google.com/security-key-management).

> SOPS configuration lies in [.sops.yaml](.sops.yaml)

Before you can edit the list, ensure your workstation is configured with credentials that have access to that key and then run:

```sh
sops config.enc.json
```

Or to edit it in VSCode:

```sh
EDITOR="code --wait" sops config.enc.json
```

## Forking

If you want to fork this repo and modify it for your own personal/commercial usage, please do so freely, it is licensed accordingly (Apache 2.0).

Example configuration:

```json
{
  "primary_domain": "lastname.com",
  "forwarded_domains": ["lastname.net", "last.name"],
  "members": [
    {
      "first_name": "John",
      "last_name": "Last Name",
      "recovery_email": "john@gmail.com",
      "aliases": ["jo"]
    }
  ]
}
```

### Credentials configuration

It is recommended to configure the [Google workspace provider](https://registry.terraform.io/providers/hashicorp/googleworkspace/latest/docs) with a service account ([guide](https://developers.google.com/admin-sdk/directory/v1/guides/delegation#create_the_service_account_and_credentials)).

Essentially the steps are:

1. Activate the [Admin SDK API](https://console.developers.google.com/apis/api/admin.googleapis.com/overview) in GCP
2. [Create a service account](https://console.cloud.google.com/iam-admin/serviceaccounts) (note its ID which is a long number) and keep the credentials file at hand.
3. [Delegate domain-wide](https://admin.google.com/ac/owl/domainwidedelegation) the following OAuth scope to the service account ID `https://www.googleapis.com/auth/admin.directory.user`
4. Value for the Terraform variable `googleworkspace_customer_id` can be found [here](https://admin.google.com/ac/accountsettings/profile).
5. Set the email of the user account you just used to delegate OAuth scopes in the environment variable `GOOGLEWORKSPACE_IMPERSONATED_USER_EMAIL` (not the service account email).
6. Set the environment variable `GOOGLEWORKSPACE_CREDENTIALS` to be either a path to the credentials file either its content without new lines (Select content and press `CTRL+J` in VSCode).

> In my case, steps 1, 2, 6 are automated [in my personal infra repo](https://github.com/politician/romain-infra/blob/main/project_barissat-infra.tf)
