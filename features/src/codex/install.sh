#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Installing OpenAI Codex CLI..."

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl

# Install to a system-wide location so Codex is available to all container users.
curl -fsSL https://chatgpt.com/codex/install.sh \
  | CODEX_INSTALL_DIR=/usr/local/bin CODEX_NON_INTERACTIVE=1 sh

if command -v codex >/dev/null 2>&1; then
  echo "✓ OpenAI Codex CLI is available via 'codex' ($(codex --version 2>/dev/null || true))"
else
  echo "ERROR: OpenAI Codex CLI install completed but 'codex' is not on PATH"
  exit 1
fi

# AI agent instructions and skills symlink setup
INSTRUCTIONFILEPATH="${INSTRUCTIONFILEPATH:-}"
RULESPATH="${RULESPATH:-}"
SKILLSPATH="${SKILLSPATH:-}"
INSTALL_DIR="/usr/local/share/codex"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${INSTALL_DIR}"
{
  printf 'INSTRUCTION_FILE_PATH=%q\n' "${INSTRUCTIONFILEPATH}"
  printf 'RULES_PATH=%q\n' "${RULESPATH}"
  printf 'SKILLS_PATH=%q\n' "${SKILLSPATH}"
} > "${INSTALL_DIR}/config.env"
install -m 0755 "${SCRIPT_DIR}/setup-symlinks.sh" "${INSTALL_DIR}/setup-symlinks.sh"

rm -rf /var/lib/apt/lists/*

echo "✓ OpenAI Codex feature installation completed"
