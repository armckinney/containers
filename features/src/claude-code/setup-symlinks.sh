#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/config.env" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT="$(pwd -P)"
INSTRUCTION_FILE_PATH="${INSTRUCTION_FILE_PATH:-}"
RULES_PATH="${RULES_PATH:-}"
SKILLS_PATH="${SKILLS_PATH:-}"

link_if_missing() {
  local source="$1"
  local destination="$2"

  # Preserve workspace files, directories, and even dangling symlinks.
  if [[ ! -e "${destination}" && ! -L "${destination}" ]]; then
    mkdir -p "$(dirname "${destination}")"
    ln -s "${source}" "${destination}"
  fi
}

if [[ -n "${INSTRUCTION_FILE_PATH}" && -f "${WORKSPACE_ROOT}/${INSTRUCTION_FILE_PATH}" ]]; then
  if [[ "${INSTRUCTION_FILE_PATH}" != "CLAUDE.md" ]]; then
    link_if_missing "${INSTRUCTION_FILE_PATH}" "${WORKSPACE_ROOT}/CLAUDE.md"
  fi
elif [[ -n "${INSTRUCTION_FILE_PATH}" ]]; then
  echo "Instruction file ${INSTRUCTION_FILE_PATH} not found. Skipping CLAUDE.md symlink."
fi

if [[ -n "${RULES_PATH}" && -d "${WORKSPACE_ROOT}/${RULES_PATH}" ]]; then
  link_if_missing "../${RULES_PATH}" "${WORKSPACE_ROOT}/.claude/rules"
elif [[ -n "${RULES_PATH}" ]]; then
  echo "Rules directory ${RULES_PATH} not found. Skipping rules symlink."
fi

if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]]; then
  link_if_missing "../${SKILLS_PATH}" "${WORKSPACE_ROOT}/.claude/skills"
elif [[ -n "${SKILLS_PATH}" ]]; then
  echo "Skills directory ${SKILLS_PATH} not found. Skipping skills symlink."
fi

echo "Claude Code symlinks initialized successfully!"
