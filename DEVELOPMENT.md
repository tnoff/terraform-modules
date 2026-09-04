# Development

Setup, conventions, and workflows for developing the modules in this
repository. User-facing module documentation is in [README.md](README.md);
non-obvious internals are in [AGENTS.md](AGENTS.md).

## Prerequisites

- **Terraform** ≥ 1.9
- **Docker** — every pre-commit hook runs inside a pinned container, so
  Docker must be running before `git commit`
- **pre-commit** — `pip install pre-commit` (any Python ≥ 3.10)

## One-time setup

```bash
pre-commit install
```

This installs the git hook that runs `terraform fmt` and per-provider
`terraform-docs` on every commit.

## Pre-commit hooks

Configured in [.pre-commit-config.yaml](.pre-commit-config.yaml). Each
hook uses `pass_filenames: false` and operates on a whole provider
directory:

| Hook | What it does |
|---|---|
| `terraform-fmt` | Runs `terraform fmt -recursive` across the whole repo |
| `terraform-docs-cloudflare` | Regenerates `cloudflare/**/terraform.md` |
| `terraform-docs-discord` | Regenerates `discord/**/terraform.md` |
| `terraform-docs-github` | Regenerates `github/**/terraform.md` |
| `terraform-docs-gitlab` | Regenerates `gitlab/**/terraform.md` |
| `terraform-docs-kubernetes` | Regenerates `kubernetes/**/terraform.md` |
| `terraform-docs-oci` | Regenerates `oci/**/terraform.md` |

Run all hooks manually:

```bash
pre-commit run --all-files
```

Run one hook:

```bash
pre-commit run terraform-docs-oci --all-files
```

## Formatting

`terraform-fmt` runs automatically on commit. To format manually:

```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace \
  hashicorp/terraform:1.11 fmt -write=true -recursive
```

## Documentation

Every module has an auto-generated `terraform.md`. **Never edit it by
hand** — the pre-commit hook will overwrite changes.

Regenerate all docs without committing:

```bash
for provider in cloudflare discord github gitlab kubernetes oci; do
  docker run --rm -v "$(pwd):/workspace" -w /workspace \
    quay.io/terraform-docs/terraform-docs:0.19.0 ${provider}/
done
```

Regenerate one provider:

```bash
docker run --rm -v "$(pwd):/workspace" -w /workspace \
  quay.io/terraform-docs/terraform-docs:0.19.0 oci/
```

### Why lockfile is disabled in terraform-docs

`.terraform.lock.hcl` is gitignored. Reading it during doc generation
(where it exists locally but not in CI) produced inconsistent
provider-version output. Each provider's `.terraform-docs.yml` sets
`lockfile: false` so docs only reflect `required_providers` constraints,
not the resolved lock.

## Validating that docs are up to date

The repo ships a helper script that re-runs `terraform-docs` and fails
if the working tree changed afterward — useful for CI checks:

```bash
./.pre-commit-scripts/check-terraform-docs.sh <provider-dir>
```

## Renovate regenerates the docs for you

Dependency PRs keep their own docs current. `renovate.json` registers
`ci/renovate-terraform-docs.sh` as a `postUpgradeTasks` command, so
Renovate re-runs the generator on its branch and folds any `terraform.md`
change into the same commit as the bump.

This is not a nicety. Each module's Providers table renders the version
*constraint* out of its `provider.tf`, so a plain constraint bump
(`~> 8.0` -> `~> 9.0`) staleness the docs in every module using that
provider while touching no variable, output or resource — 13 modules at
once in #50. Renovate has no way to infer that; only re-running
`terraform-docs` fixes it.

Two things about that script are worth knowing before editing it:

* It downloads the `terraform-docs` binary instead of running the
  `quay.io/terraform-docs/terraform-docs` image that CI and the
  pre-commit hooks use. It executes *inside* the Renovate container,
  which has no Docker socket mounted, so `docker run` is not available
  to it. Same generator, different delivery.
* Its pinned version has to match the image pinned in
  `.github/workflows/ci.yml`, because satisfying that job is the entire
  point. Note the two are already ahead of `.pre-commit-config.yaml`,
  which still pins 0.19.0.

The command string in `renovate.json` must also match the allowlist
regex in the shared `renovate.yml` workflow byte for byte. Renovate
refuses to run `postUpgradeTasks` shell unless the *self-hosted* config
allowlists it; a repo cannot authorize its own commands.

## Adding a new module

1. Create the directory under the appropriate provider:

   ```
   <provider>/<module>/
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   └── provider.tf
   ```

2. Follow the conventions in [AGENTS.md](AGENTS.md): primary resource
   named `this`, `*_ocid` suffixes for OCI identifiers, `display_name` for
   OCI resource names, `freeform_tags` for tagging.

3. Run `pre-commit run --all-files`. The provider-level `terraform.md`
   regenerates and picks up your new module automatically.

4. Add an example to the relevant section in [README.md](README.md).

## Adding a new provider

1. Create the provider directory (e.g. `aws/`) with at least one module.
2. Append a new hook to `.pre-commit-config.yaml`, mirroring the
   existing entries:

   ```yaml
   - id: terraform-docs
     name: terraform-docs-aws
     language: docker_image
     entry: quay.io/terraform-docs/terraform-docs:0.19.0
     args: ["aws/"]
     pass_filenames: false
   ```

3. Add a leg to the `docs` matrix in
   [.github/workflows/ci.yml](.github/workflows/ci.yml), which lists the
   provider directories literally. `ci/renovate-terraform-docs.sh` works
   its own list out from the tree and needs no change.
4. Add a `Provider Configuration` block to [README.md](README.md) with
   the provider requirements and an example.

## Branch and remote layout

The authoritative remote is GitLab
(`gitlab.com/tnoff-projects/terraform-modules`); GitHub is a mirror.
Module `source = "git::..."` references in consuming repos should use
the GitLab URL.
