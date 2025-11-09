#!/bin/bash
# Check if terraform-docs would make changes to terraform.md files
# Fails if documentation is out of date

set -e

PROVIDER_DIR=$1

if [ -z "$PROVIDER_DIR" ]; then
    echo "Error: Provider directory not specified"
    exit 1
fi

# Run terraform-docs with --output-check flag
# This checks if the output file is up to date without modifying it
if docker run --rm \
    -v "$(pwd):/workspace" \
    -w /workspace \
    quay.io/terraform-docs/terraform-docs:0.19.0 \
    --output-check \
    "$PROVIDER_DIR/"; then
    echo "✓ terraform-docs is up to date for $PROVIDER_DIR"
    exit 0
else
    echo "ERROR: terraform-docs output is out of date for $PROVIDER_DIR"
    echo "Please run: terraform-docs $PROVIDER_DIR/"
    echo "Then stage the changes: git add $PROVIDER_DIR/terraform.md"
    exit 1
fi
