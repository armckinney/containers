#!/usr/bin/env bash
set -e

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/config.env" ]; then
    source "${SCRIPT_DIR}/config.env"
fi

WORKSPACE_ROOT=$(pwd)

# 1. Setup central rule symlink if configured
if [ -n "${RULEFILE_PATH}" ] && [ "${RULEFILE_PATH}" != "none" ] && [ "${RULEFILE_PATH}" != "false" ]; then
    echo "Setting up AI agent rules symlink..."
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

# 2. Setup context folder symlink if configured
if [ -n "${CONTEXT_PATH}" ] && [ "${CONTEXT_PATH}" != "none" ] && [ "${CONTEXT_PATH}" != "false" ]; then
    if [ -d "${WORKSPACE_ROOT}/${CONTEXT_PATH}" ]; then
        echo "Setting up AI agent context symlink..."
        mkdir -p "${WORKSPACE_ROOT}/${TARGET_SUBDIR}"
        ln -sf "../${CONTEXT_PATH}" "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/context"
    fi
fi

# 3. Setup skills folder symlink if configured
if [ -n "${SKILLS_PATH}" ] && [ "${SKILLS_PATH}" != "none" ] && [ "${SKILLS_PATH}" != "false" ]; then
    if [ -d "${WORKSPACE_ROOT}/${SKILLS_PATH}" ]; then
        echo "Setting up AI agent skills symlink..."
        mkdir -p "${WORKSPACE_ROOT}/${TARGET_SUBDIR}"
        ln -sf "../${SKILLS_PATH}" "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/skills"
    fi
fi

echo "AI agent symlinks initialized successfully!"
