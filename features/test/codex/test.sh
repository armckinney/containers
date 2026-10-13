#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Verify Codex CLI is installed and usable
check "Codex CLI is installed" command -v codex
check "Codex CLI version works" codex --version

# Verify the feature lifecycle hook is installed
check "Codex symlink setup script is installed" [ -x "/usr/local/share/codex/setup-symlinks.sh" ]

# Report results
reportResults
