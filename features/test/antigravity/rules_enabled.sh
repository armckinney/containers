#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Setup dummy workspace files for testing symlinking
echo "# Agent Configuration" > docs/agents/AGENTS.md
mkdir -p docs/agents/skills

# Re-execute setup-symlinks.sh to create symlink
/usr/local/share/antigravity/setup-symlinks.sh

# Verify rules symlink exists and points to central rules file
check "Rules symlink exists when configured" [ -L ".agents/AGENTS.md" ]
check "Rule file exists" [ -f "docs/agents/AGENTS.md" ]

# Verify skills folder symlink exists
check "Skills symlink exists when configured" [ -L ".agents/skills" ]

# Report results
reportResults
