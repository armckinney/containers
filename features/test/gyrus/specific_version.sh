#!/bin/bash
set -e

source dev-container-features-test-lib

check "Gyrus CLI is installed" command -v gyrus
check "Gyrus CLI help works" gyrus --help
check "Gyrus version matches" grep -a -q "0.1.11" /usr/local/bin/gyrus

reportResults
