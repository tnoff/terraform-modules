#!/bin/bash
# Run terraform fmt on provider directories only, excluding dot-prefixed directories

set -e

PROVIDER_DIRS=("cloudflare" "discord" "github" "oci")

for dir in "${PROVIDER_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "Formatting: $dir/"
    docker run --rm \
      -v "$(pwd):/workspace" \
      -w /workspace \
      hashicorp/terraform:1.11 \
      fmt -write=true -recursive "$dir/" || exit 1
  fi
done

echo "✓ Terraform formatting complete (provider directories only)"
