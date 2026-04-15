#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

# Docker-in-Docker Installation Script
# Installs Docker inside the container using privileged mode
echo "Installing Docker-in-Docker..."

# Update package lists
apt-get update

# Install prerequisite packages
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again with Docker repo
apt-get update

# Install Docker CE
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Start dockerd automatically when the container starts.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p /usr/local/share/docker-in-docker
install -m 0755 "$SCRIPT_DIR/start-dockerd.sh" /usr/local/share/docker-in-docker/start-dockerd.sh

echo "✓ Docker-in-Docker installation completed"
