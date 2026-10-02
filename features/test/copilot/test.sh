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

# Test 3: Verify Copilot central instructions symlink is disabled by default
check "Copilot central rules symlink is disabled" [ ! -e ".github/copilot-instructions.md" ]

# Test 4: Verify Copilot path-scoped context instructions directory symlink is disabled
check "Copilot instructions directory symlink is disabled" [ ! -e ".github/instructions" ]

# Test 5: Verify Copilot prompts symlink is disabled
check "Copilot prompts symlink is disabled" [ ! -e ".github/prompts" ]

# Report results
reportResults
