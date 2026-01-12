#!/bin/bash

# configuration
if [ -n "$WORKSPACE" ]; then
    WORKSPACE_DIR="$WORKSPACE"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi
DEVCONTAINER_JSON="$WORKSPACE_DIR/.devcontainer/devcontainer.json"

# find the antigravity binary
ANTIGRAVITY_BIN="agy"

if ! command -v "$ANTIGRAVITY_BIN" >/dev/null 2>&1; then
    echo "Error: $ANTIGRAVITY_BIN command not found in PATH."
    exit 1
fi

if [ ! -f "$DEVCONTAINER_JSON" ]; then
    echo "Error: .devcontainer/devcontainer.json not found at $DEVCONTAINER_JSON"
    exit 1
fi

echo "Installing extensions from $DEVCONTAINER_JSON..."

# parse extensions using sed/grep (no jq required)
EXTENSIONS=$(sed -n '/"extensions": \[/,/\]/p' "$DEVCONTAINER_JSON" | grep '"' | grep -v '"extensions": \[' | sed 's/.*"\([^"]*\)".*/\1/')

if [ -z "$EXTENSIONS" ]; then
    echo "No extensions found in $DEVCONTAINER_JSON."
    exit 0
fi

for EXT in $EXTENSIONS; do
    # the --force flag is used to ensure we at least try to get the latest version if possible
    if ! "$ANTIGRAVITY_BIN" --install-extension "$EXT" --force > /tmp/ext_install.log 2>&1; then
        echo "Warning: Failed to install $EXT. It might not be available in the marketplace or for this architecture."
    fi
done

"$ANTIGRAVITY_BIN" --list-extensions
