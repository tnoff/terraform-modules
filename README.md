# Terraform Modules

A collection of terraform modules from my personal development.

## Development

Install the terraform-docs pre-commit hook:

```
pre-commit install
```

## Cloudflare

Cloudflare DNS entries, best used when you can programmatically set the A records.

```
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
  required_version = "~> 1.9"
}
```

```
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
```

API Token must be a valid [cloudflare token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)

## Github

Github repos and other defaults for repositories. Includes support for injecting action secrets.

Requires a [github provider](https://registry.terraform.io/providers/integrations/github/6.6.0) installed.

provider.tf
```
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = "~> 1.9"
}

provider "github" {
  alias = "personal"
  token = var.github_token
}
```

Token must be a valid [github token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

## OCI

OCI modules for various things.

Requires a [oci provider](https://registry.terraform.io/providers/oracle/oci/latest) installed.

provider.tf
```
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.20"
    }
  }
  required_version = "~> 1.9"
}

provider "oci" {
  user_ocid    = var.oci_user_ocid
  tenancy_ocid = var.oci_tenancy_ocid
  private_key  = var.oci_private_key
  fingerprint  = var.oci_fingerprint
  region       = "us-ashburn-1"
}
```

### Example Setup

Steps to setup a terraform user

The auth information corresponds to an OCI user, similar to what you put in a `~/.oci/config` file. User will need to have permissions to run actions in modules.

## Tenant Admin Policy

Create new terraform user

```
$ oci iam user create --name "terraform" --description "Terraform User"
```

Create terraform access grup

```
$ oci  iam group create --name "terraform" --description "Terraform Access Group"
```

Add user to new group

```
$ oci iam group add-user --user-id <user-id> --group-id <group-id>
```

Give group access to manage resources in tenancy

```
$ oci iam policy create -c <tenancy-ocid> --name "terraform-access" --description "Terraform Access Policy" --statements '["ALLOW GROUP terraform to manage all-resources IN TENANCY"]'
```

Setup a key for terraform to use

```
$ oci setup keys --key-name terraform-key
```

Add public key to user

```
$ oci iam user api-key upload --user-id <user-id> --key-file ~/.oci/terraform-key_public.pem
```

## Discord

Discord modules for managing servers.

Requires a [discord provider](https://registry.terraform.io/providers/Lucky3028/discord/latest/docs) installed.

provider
```
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 2.0"
    }
  }


provider "discord" {
  token = var.discord_token
}
```

The discord token must belong to a [discord bot](https://discord.com/developers/docs/intro) within the server.

The bot must have permissions to do all of the actions you are using it for, such as creating text channels and roles.