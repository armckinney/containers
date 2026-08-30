#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Antigravity CLI (agy) is installed
check "Antigravity CLI (agy) is installed" command -v agy

# Test 2: Verify custom registration name is configured with devcontainer- prefix in config.env
check "Custom registration name configured with devcontainer- prefix" grep -q 'REGISTRATION_NAME="devcontainer-test-feature-antigravity-remote"' /usr/local/share/antigravity-remote/config.env

# Report results
reportResults
