#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Gyrus CLI is installed and accessible
check "Gyrus CLI is installed" command -v gyrus

# Test 2: Verify Gyrus CLI help command works
check "Gyrus CLI help works" gyrus --help

# Test 3: Verify Gyrus config show works
check "Gyrus CLI config show works" gyrus config show

# Report results
reportResults
