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

# AI Agent Rules Symlinker Setup
RULEFILEPATH="${RULEFILEPATH-AGENTS.md}"
FEATURE_ID="antigravity"
TARGET_SUBDIR=".agents"
TARGET_FILENAME="AGENTS.md"

echo "Configuring Antigravity rules symlink..."
echo "Central rule file path: ${RULEFILEPATH}"

INSTALL_DIR="/usr/local/share/antigravity"
mkdir -p "${INSTALL_DIR}"

# 1. Store option configuration for runtime lifecycle hooks
cat << EOF > "${INSTALL_DIR}/config.env"
RULEFILE_PATH="${RULEFILEPATH}"
FEATURE_ID="${FEATURE_ID}"
TARGET_SUBDIR="${TARGET_SUBDIR}"
TARGET_FILENAME="${TARGET_FILENAME}"
EOF

# 2. Copy the symlink setup script
cp "$(dirname "$0")/setup-symlinks.sh" "${INSTALL_DIR}/setup-symlinks.sh"

echo "✓ Antigravity CLI feature installation completed"
