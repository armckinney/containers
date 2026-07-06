#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Antigravity CLI is installed and accessible
check "Antigravity CLI is installed" command -v agy

# Test 2: Verify Antigravity CLI version works
check "Antigravity CLI version works" agy --version

# Test 3: Verify symlink does not exist
check "Rules symlink is disabled" [ ! -f ".agents/AGENTS.md" ]

# Report results
reportResults
