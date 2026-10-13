#!/usr/bin/env bash
set -euo pipefail

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/config.env" ]; then
    source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT="$(pwd -P)"
RULEFILE_PATH="${RULEFILE_PATH:-}"
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

# 1. Setup central rule symlink if configured
if [[ -n "${RULEFILE_PATH}" && -f "${WORKSPACE_ROOT}/${RULEFILE_PATH}" ]]; then
    DESTINATION="${WORKSPACE_ROOT}/${TARGET_SUBDIR}/${TARGET_FILENAME}"
    link_if_missing "../${RULEFILE_PATH}" "${DESTINATION}"
elif [[ -n "${RULEFILE_PATH}" ]]; then
    echo "Rule file ${RULEFILE_PATH} not found. Skipping rules symlink."
fi

# 2. Setup skills folder symlink if configured
if [[ -n "${SKILLS_PATH}" && -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]]; then
    DESTINATION="${WORKSPACE_ROOT}/${TARGET_SUBDIR}/skills"
    link_if_missing "../${SKILLS_PATH}" "${DESTINATION}"
fi

echo "AI agent symlinks initialized successfully!"
