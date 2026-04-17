#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify GitHub Copilot CLI is installed and accessible
check "GitHub Copilot CLI is installed" command -v copilot

# Test 2: Verify GitHub Copilot CLI help works
check "GitHub Copilot CLI help works" copilot help

# Report results
reportResults
