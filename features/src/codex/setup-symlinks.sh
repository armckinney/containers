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

  # -L also catches dangling symlinks, which -e alone does not detect.
  if [[ ! -e "${destination}" && ! -L "${destination}" ]]; then
    mkdir -p "$(dirname "${destination}")"
    ln -s "${source}" "${destination}"
  fi
}

# Only create links when the configured source exists. Existing destinations
# may have been created by the workspace or another tool, so preserve them.
if [[ -n "${INSTRUCTION_FILE_PATH}" && -f "${WORKSPACE_ROOT}/${INSTRUCTION_FILE_PATH}" \
  && "${INSTRUCTION_FILE_PATH}" != "AGENTS.md" ]]; then
  link_if_missing "${INSTRUCTION_FILE_PATH}" "${WORKSPACE_ROOT}/AGENTS.md"
fi

if [[ -n "${RULES_PATH}" && -d "${WORKSPACE_ROOT}/${RULES_PATH}" ]]; then
  link_if_missing "../${RULES_PATH}" "${WORKSPACE_ROOT}/.codex/rules"
fi

if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" \
  && "${SKILLS_PATH}" != ".agents/skills" ]]; then
  link_if_missing "../${SKILLS_PATH}" "${WORKSPACE_ROOT}/.agents/skills"
fi
