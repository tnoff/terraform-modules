# Terraform Modules

A collection of reusable Terraform modules for personal development across multiple cloud providers and services.

## Table of Contents

- [Usage](#usage)
- [Available Modules](#available-modules)
- [Variable Naming Conventions](#variable-naming-conventions)
- [Module Documentation](#module-documentation)
- [Provider Configuration](#provider-configuration)
  - [Cloudflare](#cloudflare)
  - [GitHub](#github)
  - [Discord](#discord)
  - [OCI (Oracle Cloud Infrastructure)](#oci-oracle-cloud-infrastructure)
  - [Kubernetes](#kubernetes)
- [Development](#development)

## Usage

Modules are consumed via Git references with specific commit SHAs to ensure reproducibility:

```hcl
module "example" {
  source = "git::https://github.com/tnoff/terraform-modules.git//oci/iam-user?ref=<commit-sha>"

  # Module variables...
  tenancy_ocid       = var.oci_tenancy_ocid
  user_display_name  = "my-user"
  group_display_name = "my-group"
  compartments       = ["compartment-name"]
  verbs              = ["manage object-family"]
}
```

**Important:** Always use a specific commit SHA in the `ref` parameter to pin module versions and ensure consistent deployments.

## Available Modules

### Cloudflare
- **dns** - DNS record management

### GitHub
- **repo** - Repository management with branch protection, secrets, and webhooks
- **discord-webhook** - Configure Discord webhooks for GitHub events

### Discord
- **base-permissions** - Base permission bit calculations
- **role** - Server role management
- **channel-group** - Channel category management
- **text-channel** - Text channel management with permissions

### OCI (Oracle Cloud Infrastructure)
- **bastion** - Bastion service configuration
- **container-repo** - OCI Container Registry repositories
- **iam-compartment** - Compartment and dynamic group management
- **iam-user** - User, group, and policy management
- **object-storage-bucket** - Object storage buckets with lifecycle policies and versioning
- **object-storage-lifecycle-policies** - Lifecycle policies for object storage
- **oke-cluster** - Oracle Kubernetes Engine cluster
- **oke-networking** - VCN and subnet configuration for OKE
- **oke-node-pool** - OKE node pool management
- **secret-vault** - Vault and KMS key management

### Kubernetes
- **ocir-image-pull** - OCIR image pull secret configuration

## Variable Naming Conventions

This repository follows consistent variable naming conventions across all modules:

### OCI Modules
- **Resource identifiers**: Use `*_ocid` suffix (e.g., `compartment_ocid`, `kms_key_ocid`, `vcn_ocid`)
- **Resource names**: Use `display_name` for all resource naming
- **Tags**: Use `freeform_tags` for all tagging (type: `map(any)`, default: `{}`)

### Non-OCI Modules
- **Names**: Use descriptive names like `repo_name`, `channel_name`, `role_name`
- Resource-specific conventions maintained for clarity

### Example
```hcl
module "bucket" {
  source           = "git::https://github.com/tnoff/terraform-modules.git//oci/object-storage-bucket?ref=<sha>"
  compartment_ocid = var.compartment_ocid  # Not compartment_id
  display_name     = "my-bucket"           # Not name
  kms_key_ocid     = var.kms_key_ocid     # Not kms_key_id
  freeform_tags    = {                     # Not tags
    "environment" = "production"
  }
}
```

## Module Documentation

Each module includes auto-generated documentation in a `terraform.md` file located in the module directory. This documentation includes:
- Input variables with types, descriptions, and defaults
- Output values with descriptions
- Provider requirements

Example: View OCI IAM user module documentation at `oci/iam-user/terraform.md`

## Provider Configuration

### Cloudflare

Cloudflare DNS management modules for programmatic DNS record updates.

**Provider Requirements:**
```hcl
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
  required_version = "~> 1.9"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
```

**Authentication:** Requires a valid [Cloudflare API token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)

**Example Usage:**
```hcl
module "dns_record" {
  source = "git::https://github.com/tnoff/terraform-modules.git//cloudflare/dns?ref=<sha>"

  zone_id = var.cloudflare_zone_id
  name    = "example.com"
  type    = "A"
  value   = "192.0.2.1"
}
```

### GitHub

GitHub repository and webhook management with support for branch protection, action secrets, and Discord integration.

**Provider Requirements:**
```hcl
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
  token = var.github_token
}
```

**Authentication:** Requires a valid [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

**Example Usage:**
```hcl
module "my_repo" {
  source           = "git::https://github.com/tnoff/terraform-modules.git//github/repo?ref=<sha>"
  repo_name        = "my-project"
  repo_description = "My awesome project"
  is_public        = true
  topics           = ["terraform", "automation"]

  action_secrets = {
    DEPLOY_KEY = var.deploy_key
  }

  required_status_checks = [
    "build",
    "test"
  ]
}
```

### Discord

Discord server management modules for roles, channels, and permissions.

**Provider Requirements:**
```hcl
terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 2.0"
    }
  }
  required_version = "~> 1.9"
}

provider "discord" {
  token = var.discord_token
}
```

**Authentication:** The Discord token must belong to a [Discord bot](https://discord.com/developers/docs/intro) with appropriate permissions in the target server.

**Required Bot Permissions:** The bot must have permissions for all actions being managed (e.g., Manage Channels, Manage Roles).

**Example Usage:**
```hcl
module "admin_role" {
  source          = "git::https://github.com/tnoff/terraform-modules.git//discord/role?ref=<sha>"
  server_id       = var.discord_server_id
  role_name       = "Admin"
  permission_bits = data.discord_permission.admin.allow_bits
  position        = 1
  hex_color       = "#ff0000"
  hoist           = true
}

module "general_channel" {
  source        = "git::https://github.com/tnoff/terraform-modules.git//discord/text-channel?ref=<sha>"
  server_id     = var.discord_server_id
  category_id   = module.main_category.channel_group.id
  channel_name  = "general"
  channel_topic = "General discussion"
  position      = 0
}
```

### OCI (Oracle Cloud Infrastructure)

Comprehensive OCI modules for IAM, compute (OKE), storage, networking, and security.

**Provider Requirements:**
```hcl
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

**Example Usage:**
```hcl
# Create a compartment
module "app_compartment" {
  source       = "git::https://github.com/tnoff/terraform-modules.git//oci/iam-compartment?ref=<sha>"
  tenancy_ocid = var.oci_tenancy_ocid
  display_name = "applications"
  freeform_tags = {
    "environment" = "production"
  }
}

# Create an object storage bucket
module "backup_bucket" {
  source                  = "git::https://github.com/tnoff/terraform-modules.git//oci/object-storage-bucket?ref=<sha>"
  compartment_ocid        = module.app_compartment.compartment.id
  display_name            = "backups"
  namespace               = var.oci_namespace
  kms_key_ocid            = var.kms_key_ocid
  versioning_enabled      = true
  archive_after           = 30
  delete_after            = 365
  freeform_tags = {
    "purpose" = "backups"
  }
}

# Create OKE cluster
module "oke_network" {
  source           = "git::https://github.com/tnoff/terraform-modules.git//oci/oke-networking?ref=<sha>"
  compartment_ocid = module.app_compartment.compartment.id
  display_name     = "oke-network"
}

module "oke_cluster" {
  source             = "git::https://github.com/tnoff/terraform-modules.git//oci/oke-cluster?ref=<sha>"
  compartment_ocid   = module.app_compartment.compartment.id
  display_name       = "production"
  vcn_ocid           = module.oke_network.vcn.id
  api_subnet_ocid    = module.oke_network.subnet_k8s.id
  lb_subnet_ocids    = [module.oke_network.subnet_lb.id]
  kms_key_ocid       = var.kms_key_ocid
  kubernetes_version = "1.34.1"
}
```

### Kubernetes

Kubernetes-specific modules for integration with OCI services.

**Example Usage:**
```hcl
module "ocir_secret" {
  source = "git::https://github.com/tnoff/terraform-modules.git//kubernetes/ocir-image-pull?ref=<sha>"

  namespace = "default"
  secret_name = "ocir-credentials"
  registry_server = "iad.ocir.io"
  username = var.ocir_username
  password = var.ocir_token
}
```

## Development

For information on developing and contributing to these modules, see [AGENTS.md](AGENTS.md), which includes:
- Pre-commit hook setup and usage
- Terraform formatting guidelines
- Documentation generation with terraform-docs
- Module structure and design patterns
- Variable naming conventions
- Testing and validation procedures

### Quick Start

```bash
# Install pre-commit hooks
pre-commit install

# Format all Terraform files
docker run --rm -v "$(pwd):/workspace" -w /workspace hashicorp/terraform:1.11 fmt -write=true -recursive

# Generate documentation for all modules
for provider in cloudflare discord github kubernetes oci; do
  docker run --rm -v "$(pwd):/workspace" -w /workspace quay.io/terraform-docs/terraform-docs:0.19.0 $provider/
done
```

## License

Personal use modules - use at your own risk.
