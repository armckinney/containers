#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Setup dummy workspace files for testing
mkdir -p docs/agents/context
echo "# Agent Configuration" > docs/agents/AGENTS.md
echo -e "---\napplyTo:\n  - containers/**\n---\n# Docker Build\nRules..." > docs/agents/context/docker-build.instructions.md
mkdir -p docs/agents/skills/docker-build
echo -e "---\nname: Docker Build\n---\n# Docker Build\nRules..." > docs/agents/skills/docker-build/SKILL.md

# Re-execute setup-symlinks.sh to create symlinks
/usr/local/share/copilot/setup-symlinks.sh

# Verify Copilot central instructions symlink exists
check "Copilot central rules symlink exists when configured" [ -L ".github/copilot-instructions.md" ]

# Verify Copilot path-scoped context instructions directory symlink exists
check "Copilot instructions directory symlink exists when configured" [ -L ".github/instructions" ]
check "Copilot path-scoped instruction file exists" [ -f ".github/instructions/docker-build.instructions.md" ]

# Verify Copilot prompts symlink exists
check "Copilot prompts symlink exists when configured" [ -L ".github/prompts/docker-build.prompt.md" ]

# Report results
reportResults
