#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify GitHub Copilot CLI is installed and accessible
check "GitHub Copilot CLI is installed" command -v copilot

# Test 2: Verify GitHub Copilot CLI help works
check "GitHub Copilot CLI help works" copilot help

# Setup dummy workspace files for testing
mkdir -p docs/agents/context
echo "# Agent Configuration" > docs/agents/AGENTS.md
echo -e "---\napplyTo:\n  - containers/**\n---\n# Docker Build\nRules..." > docs/agents/context/docker-build.instructions.md
mkdir -p docs/agents/skills/docker-build
echo -e "---\nname: Docker Build\n---\n# Docker Build\nRules..." > docs/agents/skills/docker-build/SKILL.md

# Re-execute setup-symlinks.sh to create symlinks
/usr/local/share/copilot/setup-symlinks.sh

# Test 3: Verify Copilot central instructions symlink exists
check "Copilot central rules symlink exists" [ -L ".github/copilot-instructions.md" ]

# Test 4: Verify Copilot path-scoped context instructions symlink exists
check "Copilot path-scoped instructions symlink exists" [ -L ".github/instructions/docker-build.instructions.md" ]

# Test 5: Verify Copilot prompts symlink exists
check "Copilot prompts symlink exists" [ -L ".github/prompts/docker-build.prompt.md" ]

# Report results
reportResults
