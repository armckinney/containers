#!/usr/bin/env bash
set -e

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/config.env" ]; then
    source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT=$(pwd)

# 1. Setup Copilot central instructions (rules) if configured
if [ -n "${RULEFILE_PATH}" ] && [ "${RULEFILE_PATH}" != "none" ] && [ "${RULEFILE_PATH}" != "false" ]; then
    echo "Setting up GitHub Copilot central instructions..."
    mkdir -p "${WORKSPACE_ROOT}/${TARGET_SUBDIR}"

    # If the target central rule file does not exist, initialize a baseline
    if [ ! -f "${WORKSPACE_ROOT}/${RULEFILE_PATH}" ]; then
        echo "Rule file ${RULEFILE_PATH} not found. Creating a baseline..."
        mkdir -p "$(dirname "${WORKSPACE_ROOT}/${RULEFILE_PATH}")"
        cat << 'INNER_EOF' > "${WORKSPACE_ROOT}/${RULEFILE_PATH}"
# Project Rules

## AI Agent Guidelines
- All configuration changes must adhere to the conventions defined in this file.
INNER_EOF
    fi

    ln -sf "../${RULEFILE_PATH}" "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/${TARGET_FILENAME}"
fi

# 2. Setup path-scoped instructions (context) if configured
if [ -n "${CONTEXT_PATH}" ] && [ "${CONTEXT_PATH}" != "none" ] && [ "${CONTEXT_PATH}" != "false" ]; then
    if [ -d "${WORKSPACE_ROOT}/${CONTEXT_PATH}" ]; then
        echo "Mapping path-scoped Copilot instructions..."
        mkdir -p "${WORKSPACE_ROOT}/${TARGET_SUBDIR}"

        # Remove any stale instructions directory or symlink
        rm -rf "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/instructions"

        # Symlink the context directory directly
        ln -sf "../${CONTEXT_PATH}" "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/instructions"
    fi
fi

# 3. Setup prompts (skills) if configured
if [ -n "${SKILLS_PATH}" ] && [ "${SKILLS_PATH}" != "none" ] && [ "${SKILLS_PATH}" != "false" ]; then
    if [ -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]; then
        echo "Mapping modular skills to Copilot prompts..."
        mkdir -p "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/prompts"

        # Remove any stale/dangling prompts symlinks
        rm -f "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/prompts"/*.prompt.md

        # Symlink each skill folder's SKILL.md as a prompt file
        for skill_dir in "${WORKSPACE_ROOT}/${SKILLS_PATH}"/*; do
            if [ -d "${skill_dir}" ] && [ -f "${skill_dir}/SKILL.md" ]; then
                skill_name=$(basename "${skill_dir}")
                ln -sf "../../${SKILLS_PATH}/${skill_name}/SKILL.md" "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/prompts/${skill_name}.prompt.md"
            fi
        done
    fi
fi

echo "AI agent symlinks initialized successfully!"
