#!/usr/bin/env bash
set -euo pipefail

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/config.env" ]; then
    source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT="$(pwd -P)"
INSTRUCTION_FILE_PATH="${INSTRUCTION_FILE_PATH:-}"
RULES_PATH="${RULES_PATH:-}"
SKILLS_PATH="${SKILLS_PATH:-}"
TARGET_SUBDIR="${TARGET_SUBDIR:-.agents}"
TARGET_FILENAME="${TARGET_FILENAME:-AGENTS.md}"

link_if_missing() {
    local source="$1"
    local destination="$2"

    # Preserve files, directories, and symlinks from the workspace or other tools.
    if [ ! -e "${destination}" ] && [ ! -L "${destination}" ]; then
        mkdir -p "$(dirname "${destination}")"
        ln -s "${source}" "${destination}"
    fi
}

# 1. Setup central instruction symlink if configured
if [[ -n "${INSTRUCTION_FILE_PATH}" && -f "${WORKSPACE_ROOT}/${INSTRUCTION_FILE_PATH}" ]]; then
    DESTINATION="${WORKSPACE_ROOT}/${TARGET_SUBDIR}/${TARGET_FILENAME}"
    link_if_missing "../${INSTRUCTION_FILE_PATH}" "${DESTINATION}"
elif [[ -n "${INSTRUCTION_FILE_PATH}" ]]; then
    echo "Instruction file ${INSTRUCTION_FILE_PATH} not found. Skipping instruction symlink."
fi

# 2. Setup rules folder symlink if configured
if [[ -n "${RULES_PATH}" && -d "${WORKSPACE_ROOT}/${RULES_PATH}" ]]; then
    DESTINATION="${WORKSPACE_ROOT}/${TARGET_SUBDIR}/rules"
    link_if_missing "../${RULES_PATH}" "${DESTINATION}"
elif [[ -n "${RULES_PATH}" ]]; then
    echo "Rules directory ${RULES_PATH} not found. Skipping rules symlink."
fi

# 3. Setup skills folder symlink if configured
if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]]; then
    DESTINATION="${WORKSPACE_ROOT}/${TARGET_SUBDIR}/skills"
    link_if_missing "../${SKILLS_PATH}" "${DESTINATION}"
fi

echo "AI agent symlinks initialized successfully!"
