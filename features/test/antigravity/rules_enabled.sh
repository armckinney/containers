#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Setup dummy workspace files for testing symlinking
mkdir -p docs/agents/context
echo "# Agent Configuration" > docs/agents/AGENTS.md
echo "# Context Rules" > docs/agents/context/docker-build.instructions.md
mkdir -p docs/agents/skills

# Re-execute setup-symlinks.sh to create symlink
/usr/local/share/antigravity/setup-symlinks.sh

# Verify rules symlink exists and points to central rules file
check "Rules symlink exists when configured" [ -L ".agents/AGENTS.md" ]
check "Rule file exists" [ -f "docs/agents/AGENTS.md" ]

# Verify context folder symlink exists
check "Context symlink exists when configured" [ -L ".agents/context" ]

# Verify skills folder symlink exists
check "Skills symlink exists when configured" [ -L ".agents/skills" ]

# Report results
reportResults
