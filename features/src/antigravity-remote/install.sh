#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

REG_RAW="${REGISTRATIONNAME:-${REGISTRATION_NAME:-${NAME:-}}}"
REGISTRATION_NAME=""
if [ -n "$REG_RAW" ]; then
    case "$REG_RAW" in
        devcontainer-*) REGISTRATION_NAME="$REG_RAW" ;;
        *) REGISTRATION_NAME="devcontainer-${REG_RAW}" ;;
    esac
fi

echo "Installing Antigravity Remote Control feature..."

# Ensure prerequisites are present
apt-get update -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    procps

echo "Installing Antigravity CLI..."

# Install Antigravity CLI via official script
if ! curl -fsSL https://antigravity.google/cli/install.sh | bash; then
    echo "Falling back to https://antigravity.google/install.sh..."
    curl -fsSL https://antigravity.google/install.sh | bash
fi

# Locate the installed agy binary and update to latest release
AGY_SOURCE="/root/.local/bin/agy"
if [ ! -f "$AGY_SOURCE" ] && [ -f "$HOME/.local/bin/agy" ]; then
    AGY_SOURCE="$HOME/.local/bin/agy"
fi

if [ -f "$AGY_SOURCE" ]; then
    echo "Updating Antigravity CLI to latest release..."
    "$AGY_SOURCE" update || true
    install -m 0755 "$AGY_SOURCE" /usr/local/bin/agy
fi

if command -v agy >/dev/null 2>&1; then
    echo "✓ Antigravity CLI is available via 'agy' ($(agy --version 2>/dev/null || true))"
else
    echo "ERROR: Antigravity CLI install completed but 'agy' is not on PATH"
    exit 1
fi

# Configure /usr/local/share/antigravity-remote directory
INSTALL_DIR="/usr/local/share/antigravity-remote"
mkdir -p "${INSTALL_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Save configuration for runtime lifecycle hooks
cat << EOF > "${INSTALL_DIR}/config.env"
REGISTRATION_NAME="${REGISTRATION_NAME}"
EOF

# Install runtime scripts
install -m 0755 "${SCRIPT_DIR}/start-daemon.sh" "${INSTALL_DIR}/start-daemon.sh"
install -m 0755 "${SCRIPT_DIR}/entrypoint.sh" "${INSTALL_DIR}/entrypoint.sh"

# Ensure config directories exist
mkdir -p /root/.gemini /root/.antigravity

# Clean up apt caches
rm -rf /var/lib/apt/lists/*

echo "✓ Antigravity Remote Control feature installation complete."
