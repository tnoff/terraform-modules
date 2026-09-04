#!/usr/bin/env bash
#
# Assert every terraform-docs version pin in the repo agrees, and that the
# checksums in ci/renovate-terraform-docs.sh belong to the pinned version.
#
# Why: terraform-docs output changes between minor versions, so a repo that
# pins two different versions generates docs in one place that CI rejects in
# another. That is exactly what happened -- .pre-commit-config.yaml sat on
# 0.19.0 while CI used 0.20.0, so `pre-commit run --all-files` could produce a
# terraform.md that the terraform-docs job then failed. This check exists so
# that drift is caught at review time rather than discovered by a confusing
# red PR.
#
# Deliberately NOT a count-based check. Counting pins means the count itself
# drifts, and a grep that matches nothing looks identical to a grep that
# matches agreeing pins -- a detector that silently passes is worse than none.
# Instead every discovered pin must agree AND every file that must carry a pin
# is asserted to carry one, so deleting or renaming one fails loudly.

set -euo pipefail

# Files that MUST contain at least one pin. Anything else carrying a pin is
# still discovered and still has to agree; this list only guards against a pin
# silently disappearing. .gitlab-ci.yml is intentionally absent -- it is
# vestigial after the GitHub migration and may be deleted, but while it exists
# its pin still has to match.
REQUIRED_FILES=(
  '.github/workflows/ci.yml'
  '.pre-commit-config.yaml'
  '.pre-commit-scripts/check-terraform-docs.sh'
  'ci/renovate-terraform-docs.sh'
)

fail=0
log() { printf 'check-terraform-docs-pins: %s\n' "$*" >&2; }

for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "${f}" ]; then
    log "ERROR: ${f} is missing but is required to carry a terraform-docs pin"
    fail=1
  fi
done
[ "${fail}" -eq 0 ] || exit 1

# Every way a version is written in this repo:
#   quay.io/terraform-docs/terraform-docs:X.Y.Z   image pins
#   TERRAFORM_DOCS_VERSION='X.Y.Z'                the download script
#   .../releases/download/vX.Y.Z/...              the checksum-source comment
#   terraform-docs-vX.Y.Z...                      tarball / sha256sum names
PATTERN='quay\.io/terraform-docs/terraform-docs:[0-9]+\.[0-9]+\.[0-9]+|TERRAFORM_DOCS_VERSION='"'"'[0-9]+\.[0-9]+\.[0-9]+'"'"'|terraform-docs/releases/download/v[0-9]+\.[0-9]+\.[0-9]+|terraform-docs-v[0-9]+\.[0-9]+\.[0-9]+'

matches="$(grep -rEno "${PATTERN}" . \
  --exclude-dir=.git --exclude-dir=.terraform --exclude='*.tar.gz' || true)"

if [ -z "${matches}" ]; then
  log 'ERROR: found no terraform-docs pins at all -- the patterns above have'
  log '       stopped matching. Fix the patterns; do not delete this check.'
  exit 1
fi

# Extract ONLY the version substrings. Parsing whole matched lines would let a
# malformed match be reported as if it were a version, which turns a broken
# check into a confident green.
versions="$(grep -oE '[0-9]+\.[0-9]+\.[0-9]+' <<<"${matches}" | sort -u || true)"

if [ -z "${versions}" ]; then
  log 'ERROR: matched pins but parsed no version out of them:'
  printf '%s\n' "${matches}" | sed 's/^/  /' >&2
  exit 1
fi
count="$(wc -l <<<"${versions}")"

if [ "${count}" -ne 1 ]; then
  log 'ERROR: terraform-docs pins disagree.'
  log "versions found: $(tr '\n' ' ' <<<"${versions}")"
  log 'offending lines:'
  printf '%s\n' "${matches}" | sed 's/^/  /' >&2
  exit 1
fi

version="${versions}"
log "all pins agree on ${version}"

for f in "${REQUIRED_FILES[@]}"; do
  if ! grep -qE "${PATTERN}" "${f}"; then
    log "ERROR: ${f} carries no terraform-docs pin"
    fail=1
  fi
done
[ "${fail}" -eq 0 ] || exit 1

# The download script verifies a sha256 before trusting the binary, so a
# version bump that leaves those constants behind would fail at RUNTIME --
# inside a Renovate branch, which is a confusing place to find out. Catch it
# here instead, against the checksums the release itself publishes.
sums="$(curl -sSfL --retry 3 --retry-delay 2 \
  "https://github.com/terraform-docs/terraform-docs/releases/download/v${version}/terraform-docs-v${version}.sha256sum")" || {
  log "ERROR: could not fetch published checksums for v${version}"
  exit 1
}

for arch in amd64 arm64; do
  tarball="terraform-docs-v${version}-linux-${arch}.tar.gz"
  published="$(awk -v t="${tarball}" '$2 == t {print $1}' <<<"${sums}")"
  if [ -z "${published}" ]; then
    log "ERROR: release v${version} publishes no checksum for ${tarball}"
    fail=1
    continue
  fi
  if ! grep -q "${published}" ci/renovate-terraform-docs.sh; then
    log "ERROR: ci/renovate-terraform-docs.sh has no sha256 matching ${tarball}"
    log "       expected: ${published}"
    log '       A version bump must update the checksums beside it.'
    fail=1
  fi
done
[ "${fail}" -eq 0 ] || exit 1

log "checksums match the published sums for v${version}"
