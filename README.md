# Terraform Modules

A collection of terraform modules from my personal development.

## Usage

You can pass the Github Url with a commit sha for the module in your terraform.

```
module foo {
  source       = "git::https://github.com/tnoff/terraform-modules.git///oci/oci-iam-user?ref=fd04a4e1e6e59497276a1e353534b7ec458be054"
}
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