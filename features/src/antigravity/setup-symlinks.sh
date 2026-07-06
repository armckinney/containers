#!/usr/bin/env bash
set -e

# Source the configuration generated during installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/config.env" ]; then
    source "${SCRIPT_DIR}/config.env"
fi

if [ -z "${RULEFILE_PATH}" ] || [ "${RULEFILE_PATH}" = "none" ] || [ "${RULEFILE_PATH}" = "false" ]; then
    echo "Rules symlink is disabled for ${FEATURE_ID}."
    exit 0
fi

WORKSPACE_ROOT=$(pwd)

echo "Setting up AI agent symlinks in workspace: ${WORKSPACE_ROOT}"
echo "Source rule file: ${RULEFILE_PATH}"

# Ensure directories exist
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

# Create symbolic links pointing to the central rule file
# Relative symlinks are preferred so they work inside and outside the container environment
ln -sf "../${RULEFILE_PATH}" "${WORKSPACE_ROOT}/${TARGET_SUBDIR}/${TARGET_FILENAME}"

echo "AI agent symlinks initialized successfully!"
