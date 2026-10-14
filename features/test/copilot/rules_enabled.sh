#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Setup dummy workspace files for testing
mkdir -p docs/agents
echo "# Agent Configuration" > docs/agents/AGENTS.md
mkdir -p docs/agents/skills/docker-build
mkdir -p docs/agents/instructions
echo -e "---\nname: Docker Build\n---\n# Docker Build\nRules..." > docs/agents/skills/docker-build/SKILL.md

# Re-execute setup-symlinks.sh to create symlinks
/usr/local/share/copilot/setup-symlinks.sh

# Verify Copilot central instructions symlink exists
check "Copilot central rules symlink exists when configured" [ -L ".github/copilot-instructions.md" ]
check "Copilot instructions directory symlink exists when configured" [ -L ".github/instructions" ]
check "Copilot instructions directory is accessible through symlink" [ -d ".github/instructions" ]

# Verify Copilot prompts symlink exists
check "Copilot prompts symlink exists when configured" [ -L ".github/prompts/docker-build.prompt.md" ]

# Report results
reportResults
