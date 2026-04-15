#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Gemini CLI is installed and accessible
check "Gemini CLI is installed" command -v gemini

# Test 2: Verify Gemini CLI can show version
check "Gemini CLI version works" gemini --version

# Test 3: Verify Gemini config directory exists
check "Gemini config directory exists" [ -d "/root/.gemini" ]

# Report results
reportResults
