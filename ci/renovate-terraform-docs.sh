#!/usr/bin/env bash
#
# Regenerate every provider directory's terraform.md. Invoked by Renovate as a
# postUpgradeTask (see renovate.json), so a dependency PR arrives with its docs
# already current instead of red on `terraform-docs (<provider>)`.
#
# Why this exists: the Providers table in each terraform.md renders the version
# CONSTRAINT out of provider.tf, so a bare constraint bump (`~> 8.0` -> `~> 9.0`,
# tnoff/terraform-modules#50) staleness the docs in 13 modules at once without
# touching a variable, output or resource. Renovate cannot know that; only
# re-running the generator can.
#
# Runs INSIDE the Renovate container (ghcr.io/renovatebot/renovate), which has
# no Docker socket mounted -- the reusable workflow leaves the action's
# `mount-docker-socket` at its default of false. So this fetches the
# terraform-docs binary rather than reusing the `docker run
# quay.io/terraform-docs/terraform-docs` invocation that CI and
# .pre-commit-config.yaml both use. Same generator, different delivery.
#
# The version below MUST track .github/workflows/ci.yml's image pin. CI is the
# thing this script is trying to satisfy, and terraform-docs output does change
# between minor versions -- 0.19.0, which .pre-commit-config.yaml still pins,
# is NOT interchangeable with it.

set -euo pipefail

TERRAFORM_DOCS_VERSION='0.20.0'

log() { printf 'renovate-terraform-docs: %s\n' "$*" >&2; }

# Both architectures are resolved rather than assuming amd64. The reusable
# workflow's runner_labels default to ubuntu-24.04 today, but the fleet's
# self-hosted runners are OCI A1 (arm64), and an amd64 binary there fails with
# a bare "Exec format error" that reads like a corrupt download.
#
# Checksums come from the release's own sha256sum file:
# https://github.com/terraform-docs/terraform-docs/releases/download/v0.20.0/terraform-docs-v0.20.0.sha256sum
# Bump them together with TERRAFORM_DOCS_VERSION above.
case "$(uname -m)" in
  x86_64)
    arch='amd64'
    expected_sha='34ae01772412bb11474e6718ea62113e38ff5964ee570a98c69fafe3a6dff286'
    ;;
  aarch64 | arm64)
    arch='arm64'
    expected_sha='371b4ed983781d1efdd8f7de06264baac41b1d80927f7fd718c405a303d863a0'
    ;;
  *)
    log "unsupported architecture $(uname -m)"
    exit 1
    ;;
esac

# /tmp is bind-mounted from the host by the action's default docker-volumes, so
# this cache survives across every branch Renovate processes in one run -- the
# task fires once per branch and there can be a dozen.
cache_dir="${TMPDIR:-/tmp}/terraform-docs-${TERRAFORM_DOCS_VERSION}-${arch}"
binary="${cache_dir}/terraform-docs"

if [ ! -x "${binary}" ]; then
  log "fetching terraform-docs v${TERRAFORM_DOCS_VERSION} (${arch})"
  tarball="terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${arch}.tar.gz"
  work="$(mktemp -d)"
  trap 'rm -rf "${work}"' EXIT

  curl -sSfL --retry 3 --retry-delay 2 \
    "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/${tarball}" \
    -o "${work}/${tarball}"

  # Verified rather than trusted: this runs with the repository checked out and
  # a token in the environment, so an unauthenticated download is worth pinning.
  echo "${expected_sha}  ${work}/${tarball}" | sha256sum --check --status || {
    log "checksum mismatch on ${tarball}"
    exit 1
  }

  tar -xzf "${work}/${tarball}" -C "${work}" terraform-docs
  mkdir -p "${cache_dir}"
  install -m 0755 "${work}/terraform-docs" "${binary}"
fi

# Derived, not listed. ci.yml's matrix and .pre-commit-config.yaml both hardcode
# the six provider directories; a seventh would have to be added in three places
# and this is the one that can work it out for itself.
mapfile -t provider_dirs < <(
  find . -mindepth 2 -name '*.tf' -not -path './.git/*' -printf '%h\n' \
    | cut -d/ -f2 \
    | sort -u
)

if [ "${#provider_dirs[@]}" -eq 0 ]; then
  log 'no provider directories found -- refusing to report success'
  exit 1
fi

for dir in "${provider_dirs[@]}"; do
  log "regenerating ${dir}/"
  "${binary}" "${dir}/"
done

log "regenerated ${#provider_dirs[@]} provider directories"
