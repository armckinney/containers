#!/bin/bash
set -e

source dev-container-features-test-lib

check "Databricks CLI is installed" command -v databricks
check "Databricks CLI version matches" bash -c "databricks --version | grep -F '1.16.1'"

reportResults
