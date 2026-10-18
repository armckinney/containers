#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Installing OpenAI Codex CLI..."

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl

# The installer stores packages under CODEX_HOME and links the visible command
# to them. Keep both outside /root and the host-mounted /root/.codex directory.
# Scope CODEX_HOME to installation so runtime config remains per-user.
INSTALL_DIR="/usr/local/share/codex"
mkdir -p "${INSTALL_DIR}"
curl -fsSL https://chatgpt.com/codex/install.sh \
  | CODEX_HOME="${INSTALL_DIR}" CODEX_INSTALL_DIR=/usr/local/bin CODEX_NON_INTERACTIVE=1 sh

chmod -R a+rX "${INSTALL_DIR}"

if CODEX_VERSION="$(/usr/local/bin/codex --version)"; then
  echo "✓ OpenAI Codex CLI is available via 'codex' (${CODEX_VERSION})"
else
  echo "ERROR: OpenAI Codex CLI install completed but /usr/local/bin/codex cannot run"
  exit 1
fi

# AI agent instructions and skills symlink setup
INSTRUCTIONFILEPATH="${INSTRUCTIONFILEPATH:-}"
RULESPATH="${RULESPATH:-}"
SKILLSPATH="${SKILLSPATH:-}"
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
