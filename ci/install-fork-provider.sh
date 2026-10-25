#!/usr/bin/env bash
#
# Install the patched github provider (tnoff/terraform-provider-github) into a
# Terraform filesystem mirror and print the CLI config file that points at it.
#
# Why: github/repo uses github_actions_repository_fork_pr_contributor_approval,
# which the registry's integrations/github does not have yet
# (integrations/terraform-provider-github#3445, PR #3446). The fork carries it
# and is installed under the same integrations/github address, so `validate`
# needs this to pass on that module. Remove it once an upstream release ships
# the resource (the fork's upstream-watch workflow says when).
#
# tnoff/terraform has the pinned, lock-file-backed version of this
# (ci/install-provider-mirror.sh). This repo commits no lock files, so it just
# validates against the fork's latest release instead of keeping a second pin.
#
# Usage: export TF_CLI_CONFIG_FILE="$(ci/install-fork-provider.sh [--dir DIR])"
#   Needs `gh` authenticated (GH_TOKEN in CI). Verifies the zip against the
#   release's SHA256SUMS and, unless PROVIDER_MIRROR_NO_ATTESTATION is set, its
#   build-provenance attestation (gh >= 2.49).
set -euo pipefail

REPO="tnoff/terraform-provider-github"
dir="${RUNNER_TEMP:-${HOME}/.cache}/terraform-provider-mirror"
if [ "${1:-}" = "--dir" ]; then dir="$2"; fi

tag="$(gh release view --repo "${REPO}" --json tagName --jq .tagName)"
version="${tag#v}"
case "$(uname -s)" in Linux) os=linux ;; Darwin) os=darwin ;; *) echo "unsupported OS" >&2; exit 1 ;; esac
case "$(uname -m)" in x86_64|amd64) arch=amd64 ;; aarch64|arm64) arch=arm64 ;; *) echo "unsupported arch" >&2; exit 1 ;; esac
t="${os}_${arch}"

pkgdir="${dir}/registry.terraform.io/integrations/github"
dest="${pkgdir}/terraform-provider-github_${version}_${t}.zip"
mkdir -p "${pkgdir}"
work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

if [ ! -f "${dest}" ]; then
  gh release download "${tag}" --repo "${REPO}" --dir "${work}" \
    --pattern '*SHA256SUMS' --pattern "*_${t}.zip" >&2
  # GitHub may rewrite characters in an asset name (the '+' in the version), so
  # find the zip by its os_arch suffix and name the mirror file from the tag.
  got="$(ls "${work}"/*"_${t}.zip")"
  want="$(grep -E "_${t}\.zip\$" "${work}"/*SHA256SUMS | awk '{print $1}')"
  have="$(sha256sum "${got}" | awk '{print $1}')"
  if [ -z "${want}" ] || [ "${want}" != "${have}" ]; then
    echo "checksum mismatch for ${t}: SHA256SUMS says '${want}', zip is '${have}'" >&2
    exit 1
  fi
  if [ -z "${PROVIDER_MIRROR_NO_ATTESTATION:-}" ]; then
    if ! gh attestation --help >/dev/null 2>&1; then
      echo "this gh has no 'attestation' command (needs >= 2.49): upgrade gh, or set" >&2
      echo "PROVIDER_MIRROR_NO_ATTESTATION=1 to check only the release's SHA256SUMS" >&2
      exit 1
    fi
    gh attestation verify "${got}" --repo "${REPO}" >&2
    echo "verified attestation for ${tag} ${t}" >&2
  fi
  echo "verified sha256 for ${tag} ${t}" >&2
  mv "${got}" "${dest}"
fi

cfg="${dir}/terraform.rc"
cat > "${cfg}" <<RC
provider_installation {
  filesystem_mirror {
    path    = "${dir}"
    include = ["registry.terraform.io/integrations/github"]
  }
  direct {
    exclude = ["registry.terraform.io/integrations/github"]
  }
}
RC
echo "${cfg}"
