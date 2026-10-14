#!/usr/bin/env bash
set -euo pipefail

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/config.env" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT="$(pwd -P)"
INSTRUCTION_FILE_PATH="${INSTRUCTION_FILE_PATH:-}"
INSTRUCTIONS_PATH="${INSTRUCTIONS_PATH:-}"
SKILLS_PATH="${SKILLS_PATH:-}"
TARGET_SUBDIR="${TARGET_SUBDIR:-.github}"
TARGET_FILENAME="${TARGET_FILENAME:-copilot-instructions.md}"

link_if_missing() {
  local source="$1"
  local destination="$2"

  # Preserve files, directories, and symlinks already present in the workspace.
  if [[ ! -e "${destination}" && ! -L "${destination}" ]]; then
    mkdir -p "$(dirname "${destination}")"
    ln -s "${source}" "${destination}"
  fi
}

# 1. Setup Copilot central instructions (rules) if configured
if [[ -n "${INSTRUCTION_FILE_PATH}" && -f "${WORKSPACE_ROOT}/${INSTRUCTION_FILE_PATH}" ]]; then
  link_if_missing "../${INSTRUCTION_FILE_PATH}" \
    "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/${TARGET_FILENAME}"
elif [[ -n "${INSTRUCTION_FILE_PATH}" ]]; then
  echo "Instruction file ${INSTRUCTION_FILE_PATH} not found. Skipping Copilot central instructions."
fi

# 2. Map each flat source instruction file into Copilot's instructions directory.
if [[ -n "${INSTRUCTIONS_PATH}" && -d "${WORKSPACE_ROOT}/${INSTRUCTIONS_PATH}" ]]; then
  for instruction_file in "${WORKSPACE_ROOT}/${INSTRUCTIONS_PATH}"/*.md; do
    [[ -f "${instruction_file}" ]] || continue
    instruction_filename="$(basename "${instruction_file}")"
    if [[ "${instruction_filename}" == *.instructions.md ]]; then
      destination_filename="${instruction_filename}"
    else
      destination_filename="${instruction_filename%.md}.instructions.md"
    fi
    link_if_missing "../../${INSTRUCTIONS_PATH}/${instruction_filename}" \
      "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/instructions/${destination_filename}"
  done
elif [[ -n "${INSTRUCTIONS_PATH}" ]]; then
  echo "Instructions directory ${INSTRUCTIONS_PATH} not found. Skipping instructions symlink."
fi

# 3. Link project skills into Copilot's supported .agents/skills location.
if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]]; then
  link_if_missing "../${SKILLS_PATH}" \
    "${WORKSPACE_ROOT}/.agents/skills"
fi

echo "AI agent symlinks initialized successfully!"
