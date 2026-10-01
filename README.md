# Terraform Modules

Reusable Terraform modules for personal infrastructure across several cloud
providers and services. Consumed by the `terraform` and `terraform-admin`
repos; never applied on its own.

## Usage

Consume modules by Git ref, pinned to a commit SHA so deployments are
reproducible:

```hcl
module "example" {
  source = "git::https://github.com/tnoff/terraform-modules.git//oci/iam-user?ref=<commit-sha>"

  tenancy_ocid       = var.oci_tenancy_ocid
  user_display_name  = "my-user"
  group_display_name = "my-group"

  compartment_policies = [{
    compartments = ["compartment-name"]
    verbs        = ["manage object-family"]
    where_clause = ""
  }]
}
```

Always pin `ref` to a specific commit SHA, never a branch.

## Available modules

Each module has an auto-generated `terraform.md` next to its code listing its
inputs, outputs, and provider requirements; that file is the reference for
usage. Provider constraints are in each module's `provider.tf`.

| Provider | Authentication | Modules |
|---|---|---|
| `cloudflare/` | [API token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/) | `dns` (DNS records) |
| `github/` | [Personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) | `repo` (repository, rulesets, secrets, webhooks), `discord-webhook` (Discord webhook for GitHub events) |
| `gitlab/` | [Personal access token](https://docs.gitlab.com/user/profile/personal_access_tokens/) with `api` scope | `repo` (project, CI/CD variables, schedules, triggers) |
| `discord/` | Bot token; the bot needs Manage Channels / Manage Roles in the server | `base-permissions`, `role`, `channel-group`, `text-channel` |
| `oci/` | API key (user, tenancy, fingerprint, private key) | `bastion`, `container-repo`, `iam-compartment`, `iam-user`, `kms-policies`, `object-storage-bucket`, `object-storage-lifecycle-policies`, `oke-cluster`, `oke-node-pool`, `oke-vcn`, `oke-security-lists`, `oke-subnet`, `secret-vault` |
| `kubernetes/` | Kubernetes provider configured by the caller | `ocir-image-pull` (OCIR image pull secrets) |

OKE networking has no wrapper module: see the
[OKE networking recipe](oke-networking.md) for how `oke-vcn`,
`oke-security-lists`, and `oke-subnet` compose. Node-pool boot customizations
are described in [OKE node init customizations](node-init-customizations.md).

## Variable naming conventions

- **OCI modules**: identifiers use the `*_ocid` suffix (`compartment_ocid`,
  `kms_key_ocid`, `vcn_ocid`); names use `display_name`; tags use
  `freeform_tags` (`map(any)`, default `{}`).
- **Other modules**: descriptive names (`repo_name`, `channel_name`,
  `role_name`).

```hcl
module "bucket" {
  source           = "git::https://github.com/tnoff/terraform-modules.git//oci/object-storage-bucket?ref=<sha>"
  compartment_ocid = var.compartment_ocid
  display_name     = "my-bucket"
  kms_key_ocid     = var.kms_key_ocid
  freeform_tags    = { environment = "production" }
}
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup, pre-commit, doc generation,
and adding a module or provider, and [AGENTS.md](AGENTS.md) for module
conventions. Contributions go to GitHub; see [CONTRIBUTING.md](CONTRIBUTING.md).

```bash
pre-commit install
pre-commit run --all-files
```

## License

See [LICENSE](https://github.com/tnoff/terraform-modules/blob/main/LICENSE).
These are personal-use modules; use at your own risk.
