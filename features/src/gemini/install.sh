#!/bin/bash
set -e

# Gemini CLI Installation Script
# Installs Google's Gemini CLI via npm and configures it for use in the container

export DEBIAN_FRONTEND=noninteractive

VERSION="${VERSION:-latest}"
NODE_CHANNEL="${NODE_CHANNEL:-current}"

echo "Installing Node.js (${NODE_CHANNEL})..."

# Install prerequisites and add the official NodeSource repo so we avoid stale distro packages.
apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg

curl -fsSL "https://deb.nodesource.com/setup_${NODE_CHANNEL}.x" | bash -
apt-get install -y --no-install-recommends nodejs

echo "Installing Gemini CLI..."
npm install -g @google/gemini-cli@${VERSION}

echo "✓ Gemini CLI configuration completed"
