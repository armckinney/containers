#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Antigravity CLI is installed and accessible
check "Antigravity CLI is installed" command -v agy

# Test 2: Verify Antigravity CLI runs
check "Antigravity CLI version works" agy --version

# Test 3: Verify Antigravity config directory exists
check "Antigravity config directory exists" [ -d "/root/.gemini/antigravity-cli" ]

# Test 4: Verify default rules symlink exists and points to central rules file
check "Default rules symlink exists" [ -L ".agents/AGENTS.md" ]
check "Default rule file exists" [ -f "AGENTS.md" ]

# Report results
reportResults
