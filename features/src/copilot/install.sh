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
INSTRUCTIONFILEPATH="${INSTRUCTIONFILEPATH:-}"
INSTRUCTIONSPATH="${INSTRUCTIONSPATH:-}"
SKILLSPATH="${SKILLSPATH:-}"
FEATURE_ID="copilot"
TARGET_SUBDIR=".github"
TARGET_FILENAME="copilot-instructions.md"

echo "Configuring GitHub Copilot instruction symlinks..."
echo "Central instruction file path: ${INSTRUCTIONFILEPATH}"
echo "Instructions path: ${INSTRUCTIONSPATH}"
echo "Skills path: ${SKILLSPATH}"

INSTALL_DIR="/usr/local/share/copilot"
mkdir -p "${INSTALL_DIR}"

# 1. Store option configuration for runtime lifecycle hooks
{
  printf 'INSTRUCTION_FILE_PATH=%q\n' "${INSTRUCTIONFILEPATH}"
  printf 'INSTRUCTIONS_PATH=%q\n' "${INSTRUCTIONSPATH}"
  printf 'SKILLS_PATH=%q\n' "${SKILLSPATH}"
  printf 'FEATURE_ID=%q\n' "${FEATURE_ID}"
  printf 'TARGET_SUBDIR=%q\n' "${TARGET_SUBDIR}"
  printf 'TARGET_FILENAME=%q\n' "${TARGET_FILENAME}"
} > "${INSTALL_DIR}/config.env"

# 2. Copy the symlink setup script
cp "$(dirname "$0")/setup-symlinks.sh" "${INSTALL_DIR}/setup-symlinks.sh"

echo "✓ GitHub Copilot feature installation completed"
