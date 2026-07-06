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

# AI Agent Rules Symlinker Setup
RULEFILEPATH="${RULEFILEPATH-AGENTS.md}"
FEATURE_ID="copilot"
TARGET_SUBDIR=".github"
TARGET_FILENAME="copilot-instructions.md"

echo "Configuring GitHub Copilot rules symlink..."
echo "Central rule file path: ${RULEFILEPATH}"

INSTALL_DIR="/usr/local/share/copilot"
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

echo "✓ GitHub Copilot feature installation completed"
