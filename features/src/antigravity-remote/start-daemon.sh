#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/config.env" ]; then
    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/config.env"
fi

LOG_FILE="/root/.antigravity/agy_daemon.log"
PID_FILE="/root/.antigravity/agy_daemon.pid"
mkdir -p "$(dirname "$LOG_FILE")"

# Check if daemon is already running via PID file or pgrep
if [ -f "$PID_FILE" ]; then
    PID="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        echo "Antigravity Remote Control is already running (PID: $PID)."
        exit 0
    fi
fi

if pgrep -f '[a]gy.*--remote-control' >/dev/null 2>&1; then
    echo "Antigravity Remote Control is already running."
    exit 0
fi

# Ensure agy is on PATH
AGY_BIN="$(command -v agy || true)"
if [ -z "$AGY_BIN" ] && [ -x "/root/.local/bin/agy" ]; then
    AGY_BIN="/root/.local/bin/agy"
elif [ -z "$AGY_BIN" ] && [ -x "/usr/local/bin/agy" ]; then
    AGY_BIN="/usr/local/bin/agy"
fi

if [ -z "$AGY_BIN" ] || [ ! -x "$AGY_BIN" ]; then
    echo "ERROR: 'agy' binary was not found or is not executable." >&2
    exit 1
fi

# Ensure agy is updated to latest release
"$AGY_BIN" update >/dev/null 2>&1 || true

# Find a free local hub port (4400..4500)
PORT=4400
while (( PORT < 4500 )) && (exec 3<>"/dev/tcp/127.0.0.1/${PORT}") 2>/dev/null; do
    PORT=$((PORT + 1))
done

# Determine registration name: user-configured name or persistent GUID fallback
REG_NAME="${REGISTRATION_NAME:-${ANTIGRAVITY_REGISTRATION_NAME:-${AGY_DAEMON_NAME:-}}}"
GUID_FILE="/root/.antigravity/.instance_guid"

if [ -z "$REG_NAME" ]; then
    if [ -f "$GUID_FILE" ] && [ -s "$GUID_FILE" ]; then
        REG_NAME="$(cat "$GUID_FILE" | tr -d '[:space:]')"
    else
        if [ -f /proc/sys/kernel/random/uuid ]; then
            NEW_UUID="$(cat /proc/sys/kernel/random/uuid | tr -d '[:space:]')"
        elif command -v uuidgen >/dev/null 2>&1; then
            NEW_UUID="$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
        else
            NEW_UUID="$(cat /proc/sys/kernel/random/uuid 2>/dev/null || od -x /dev/urandom 2>/dev/null | head -1 | awk '{print $2$3"-"$4"-"$5}')"
        fi
        REG_NAME="devcontainer-${NEW_UUID}"
        echo "$REG_NAME" > "$GUID_FILE"
    fi
fi

# Ensure registration name has 'devcontainer-' prefix
if [ -n "$REG_NAME" ]; then
    case "$REG_NAME" in
        devcontainer-*) ;;
        *) REG_NAME="devcontainer-${REG_NAME}" ;;
    esac
fi

NAME_ARG=""
if [ -n "$REG_NAME" ]; then
    NAME_ARG="--remote-control-name ${REG_NAME}"
fi

echo "Starting Antigravity Remote Control daemon on port ${PORT}${REG_NAME:+ (name: $REG_NAME)}..."

# Launch headless Remote Control daemon in background
if command -v setsid >/dev/null 2>&1; then
    # shellcheck disable=SC2086
    setsid "$AGY_BIN" --remote-control --hub-port "$PORT" ${NAME_ARG} > "$LOG_FILE" 2>&1 &
else
    # shellcheck disable=SC2086
    nohup "$AGY_BIN" --remote-control --hub-port "$PORT" ${NAME_ARG} </dev/null > "$LOG_FILE" 2>&1 &
fi
echo $! > "$PID_FILE"

echo "Antigravity Remote Control daemon started (PID: $(cat "$PID_FILE"), log: $LOG_FILE)."
