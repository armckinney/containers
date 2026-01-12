#!/bin/bash

# configuration
DEVCONTAINER_NAME="armckinneygithubio"
SERVICE_NAME="devcontainer"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMPOSE_FILE="$WORKSPACE_DIR/.devcontainer/docker-compose.yaml"

echo "rebuilding devcontainer..."

docker compose -p "${DEVCONTAINER_NAME}_devcontainer" -f "$COMPOSE_FILE" down --volumes --rmi all
docker compose -p "${DEVCONTAINER_NAME}_devcontainer" -f "$COMPOSE_FILE" up -d --build
docker compose -p "${DEVCONTAINER_NAME}_devcontainer" -f "$COMPOSE_FILE" exec -u 0 "${SERVICE_NAME}" ln -sf "/workspaces/${DEVCONTAINER_NAME}/.devcontainer/scripts/agy_install_extensions.sh" /usr/local/bin/agy_install_extensions

echo "Done! please 'Reopen in Container' to connect and 'agy_install_extensions' to install extensions."
