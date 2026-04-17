#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Installing GitHub Copilot CLI..."

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl

curl -fsSL https://gh.io/copilot-install | bash

if command -v copilot >/dev/null 2>&1; then
  echo "✓ GitHub Copilot CLI is available via 'copilot'"
else
  echo "ERROR: GitHub Copilot CLI install completed but 'copilot' is not on PATH"
  exit 1
fi

echo "✓ GitHub Copilot feature installation completed"
