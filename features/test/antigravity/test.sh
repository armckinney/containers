#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Antigravity CLI is installed and accessible
check "Antigravity CLI is installed" command -v agy

# Test 2: Verify Antigravity CLI version works
check "Antigravity CLI version works" agy --version

# Test 3: Verify Antigravity config directory exists
check "Antigravity config directory exists" [ -d "/root/.gemini/antigravity-cli" ]

# Setup dummy workspace files for testing symlinking
mkdir -p docs/agents/context
echo "# Agent Configuration" > docs/agents/AGENTS.md
echo "# Context Rules" > docs/agents/context/docker-build.instructions.md
mkdir -p docs/agents/skills

# Re-execute setup-symlinks.sh to ensure symlinks are created based on these files
/usr/local/share/antigravity/setup-symlinks.sh

# Test 4: Verify default rules symlink exists and points to central rules file
check "Default rules symlink exists" [ -L ".agents/AGENTS.md" ]
check "Default rule file exists" [ -f "docs/agents/AGENTS.md" ]

# Test 5: Verify default context folder symlink exists
check "Default context symlink exists" [ -L ".agents/context" ]

# Test 6: Verify default skills folder symlink exists
check "Default skills symlink exists" [ -L ".agents/skills" ]

# Report results
reportResults
