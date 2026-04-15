#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "Installing GitHub CLI and GitHub Copilot CLI extension..."

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl gnupg

# Add GitHub CLI apt repository for supported distro builds.
mkdir -p /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  > /etc/apt/sources.list.d/github-cli.list

apt-get update
apt-get install -y --no-install-recommends gh

# Install gh-copilot when auth is available; skip without failing image builds.
set +e
gh extension install github/gh-copilot --force
install_exit_code=$?
set -e

if [ "$install_exit_code" -eq 0 ]; then
  echo "✓ Installed gh-copilot extension"
elif [ "$install_exit_code" -eq 4 ]; then
  echo "! Skipping gh-copilot extension install: GitHub authentication is not configured"
  echo "! After container start, run 'gh auth login' (or set GH_TOKEN) and then: gh extension install github/gh-copilot --force"
else
  echo "ERROR: Failed to install gh-copilot extension (exit code: $install_exit_code)"
  exit "$install_exit_code"
fi

echo "✓ GitHub Copilot feature installation completed"
