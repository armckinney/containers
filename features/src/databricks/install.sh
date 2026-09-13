#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

VERSION="${VERSION:-latest}"

echo "Installing Databricks CLI (${VERSION})..."

# Ensure prerequisites are installed
if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y --no-install-recommends ca-certificates curl unzip
fi

# Ensure existing installation at target path does not block installation
if [ -f "/usr/local/bin/databricks" ]; then
    rm -f "/usr/local/bin/databricks"
fi

if [ "${VERSION}" = "latest" ]; then
    curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh
else
    # Normalize version: strip leading 'v' if present
    NORMALIZED_VERSION="${VERSION#v}"

    ARCH="$(uname -m)"
    case "${ARCH}" in
        x86_64|amd64)
            ARCH_NAME="amd64"
            ;;
        aarch64|arm64)
            ARCH_NAME="arm64"
            ;;
        i386)
            ARCH_NAME="386"
            ;;
        arm)
            ARCH_NAME="arm"
            ;;
        *)
            echo "ERROR: Unsupported architecture: ${ARCH}"
            exit 1
            ;;
    esac

    TMP_DIR="$(mktemp -d)"
    ARCHIVE_NAME="databricks_cli_${NORMALIZED_VERSION}_linux_${ARCH_NAME}.zip"
    DOWNLOAD_URL="https://github.com/databricks/cli/releases/download/v${NORMALIZED_VERSION}/${ARCHIVE_NAME}"

    echo "Downloading Databricks CLI from ${DOWNLOAD_URL}..."
    curl -fsSL "${DOWNLOAD_URL}" -o "${TMP_DIR}/${ARCHIVE_NAME}"
    unzip -q -o "${TMP_DIR}/${ARCHIVE_NAME}" -d "${TMP_DIR}"

    install -m 0755 "${TMP_DIR}/databricks" /usr/local/bin/databricks
    rm -rf "${TMP_DIR}"
fi

# Ensure executable permissions
chmod +x /usr/local/bin/databricks

if command -v databricks >/dev/null 2>&1; then
    echo "✓ Databricks CLI is available via 'databricks'"
    databricks --version
else
    echo "ERROR: Databricks CLI install completed but 'databricks' is not on PATH"
    exit 1
fi

echo "✓ Databricks feature installation completed"
