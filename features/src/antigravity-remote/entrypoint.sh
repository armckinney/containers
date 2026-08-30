#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Start Antigravity Remote Control daemon on container startup
if [ -x "${SCRIPT_DIR}/start-daemon.sh" ]; then
    "${SCRIPT_DIR}/start-daemon.sh" || echo "Warning: Failed to start Antigravity Remote daemon" >&2
fi

exec "$@"
