#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

VERSION="${VERSION:-latest}"

echo "Installing Gyrus CLI (${VERSION})..."

# Ensure prerequisites are installed
if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y --no-install-recommends ca-certificates curl tar
    rm -rf /var/lib/apt/lists/*
fi

# Ensure existing installation at target path does not block installation
if [ -f "/usr/local/bin/gyrus" ]; then
    rm -f "/usr/local/bin/gyrus"
fi

# Determine architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64|amd64)
        ARCH_NAME="amd64"
        ;;
    aarch64|arm64)
        ARCH_NAME="arm64"
        ;;
    *)
        echo "ERROR: Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Resolve version
if [ "${VERSION}" = "latest" ]; then
    echo "Resolving latest release of Gyrus..."
    LATEST_TAG=$(curl -sSL "https://api.github.com/repos/armckinney/gyrus/releases/latest" 2>/dev/null | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' || true)

    if [ -z "${LATEST_TAG}" ]; then
        LATEST_TAG=$(curl -sIL "https://github.com/armckinney/gyrus/releases/latest" 2>/dev/null | grep -i "^location:" | sed -E 's/.*tag\/(v?[^[:space:]]+).*/\1/' | tr -d '\r' || true)
    fi

    if [ -z "${LATEST_TAG}" ]; then
        echo "ERROR: Could not resolve latest release version for armckinney/gyrus"
        exit 1
    fi
    RESOLVED_VERSION="${LATEST_TAG}"
else
    RESOLVED_VERSION="${VERSION}"
fi

# Normalize version: strip leading 'v' for archive naming, preserve/ensure 'v' for release tag
NORMALIZED_VERSION="${RESOLVED_VERSION#v}"
TAG="v${NORMALIZED_VERSION}"

TMP_DIR="$(mktemp -d)"
ARCHIVE_NAME="gyrus_${NORMALIZED_VERSION}_linux_${ARCH_NAME}.tar.gz"
DOWNLOAD_URL="https://github.com/armckinney/gyrus/releases/download/${TAG}/${ARCHIVE_NAME}"

echo "Downloading Gyrus CLI from ${DOWNLOAD_URL}..."
if ! curl -fsSL "${DOWNLOAD_URL}" -o "${TMP_DIR}/${ARCHIVE_NAME}"; then
    echo "ERROR: Failed to download Gyrus from ${DOWNLOAD_URL}"
    rm -rf "${TMP_DIR}"
    exit 1
fi

tar -xzf "${TMP_DIR}/${ARCHIVE_NAME}" -C "${TMP_DIR}"

if [ ! -f "${TMP_DIR}/gyrus" ]; then
    echo "ERROR: 'gyrus' binary not found in archive"
    rm -rf "${TMP_DIR}"
    exit 1
fi

install -m 0755 "${TMP_DIR}/gyrus" /usr/local/bin/gyrus
rm -rf "${TMP_DIR}"

# Ensure executable permissions
chmod +x /usr/local/bin/gyrus

if command -v gyrus >/dev/null 2>&1; then
    echo "✓ Gyrus CLI is available via 'gyrus'"
    gyrus --help >/dev/null
else
    echo "ERROR: Gyrus CLI install completed but 'gyrus' is not on PATH"
    exit 1
fi

echo "✓ Gyrus feature installation completed"
