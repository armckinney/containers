#!/bin/bash
set -e

source dev-container-features-test-lib

check "Claude Code CLI is installed" command -v claude
check "Claude Code CLI version works" claude --version

reportResults
