#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Installing Claude Code CLI..."

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl

# Use Anthropic's native installer, then expose its launcher to all container users.
curl -fsSL https://claude.ai/install.sh | bash

if [[ -x "/root/.local/bin/claude" ]]; then
  ln -sfn /root/.local/bin/claude /usr/local/bin/claude
fi

if command -v claude >/dev/null 2>&1; then
  echo "✓ Claude Code CLI is available via 'claude' ($(claude --version 2>/dev/null || true))"
else
  echo "ERROR: Claude Code installation completed but 'claude' is not on PATH"
  exit 1
fi

INSTRUCTIONFILEPATH="${INSTRUCTIONFILEPATH:-}"
RULESPATH="${RULESPATH:-}"
SKILLSPATH="${SKILLSPATH:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/usr/local/share/claude-code"

mkdir -p "${INSTALL_DIR}"
{
  printf 'INSTRUCTION_FILE_PATH=%q\n' "${INSTRUCTIONFILEPATH}"
  printf 'RULES_PATH=%q\n' "${RULESPATH}"
  printf 'SKILLS_PATH=%q\n' "${SKILLSPATH}"
} > "${INSTALL_DIR}/config.env"
install -m 0755 "${SCRIPT_DIR}/setup-symlinks.sh" "${INSTALL_DIR}/setup-symlinks.sh"

rm -rf /var/lib/apt/lists/*

echo "✓ Claude Code feature installation completed"
