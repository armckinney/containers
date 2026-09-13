#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Databricks CLI is installed and accessible
check "Databricks CLI is installed" command -v databricks

# Test 2: Verify Databricks CLI version works
check "Databricks CLI version works" databricks --version

# Report results
reportResults
