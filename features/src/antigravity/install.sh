#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Installing Antigravity CLI..."

# Install prerequisites
apt-get update
apt-get install -y --no-install-recommends ca-certificates curl

# Install Antigravity CLI via the official script
curl -fsSL https://antigravity.google/cli/install.sh | bash

# Ensure the binary is globally accessible (for non-root users in the container)
if [ -f "/root/.local/bin/agy" ]; then
  cp /root/.local/bin/agy /usr/local/bin/agy
  chmod +x /usr/local/bin/agy
elif [ -f "$HOME/.local/bin/agy" ]; then
  cp "$HOME/.local/bin/agy" /usr/local/bin/agy
  chmod +x /usr/local/bin/agy
fi

if command -v agy >/dev/null 2>&1; then
  echo "✓ Antigravity CLI is available via 'agy'"
else
  echo "ERROR: Antigravity CLI install completed but 'agy' is not on PATH"
  exit 1
fi

echo "✓ Antigravity CLI feature installation completed"
