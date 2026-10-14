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
INSTRUCTIONFILEPATH="${INSTRUCTIONFILEPATH:-}"
RULESPATH="${RULESPATH:-}"
SKILLSPATH="${SKILLSPATH:-}"
FEATURE_ID="antigravity"
TARGET_SUBDIR=".agents"
TARGET_FILENAME="AGENTS.md"

echo "Configuring Antigravity instruction and rules symlinks..."
echo "Central instruction file path: ${INSTRUCTIONFILEPATH}"
echo "Rules path: ${RULESPATH}"
echo "Skills path: ${SKILLSPATH}"

INSTALL_DIR="/usr/local/share/antigravity"
mkdir -p "${INSTALL_DIR}"

# 1. Store option configuration for runtime lifecycle hooks
{
  printf 'INSTRUCTION_FILE_PATH=%q\n' "${INSTRUCTIONFILEPATH}"
  printf 'RULES_PATH=%q\n' "${RULESPATH}"
  printf 'SKILLS_PATH=%q\n' "${SKILLSPATH}"
  printf 'FEATURE_ID=%q\n' "${FEATURE_ID}"
  printf 'TARGET_SUBDIR=%q\n' "${TARGET_SUBDIR}"
  printf 'TARGET_FILENAME=%q\n' "${TARGET_FILENAME}"
} > "${INSTALL_DIR}/config.env"

# 2. Copy the symlink setup script
cp "$(dirname "$0")/setup-symlinks.sh" "${INSTALL_DIR}/setup-symlinks.sh"

echo "✓ Antigravity CLI feature installation completed"
