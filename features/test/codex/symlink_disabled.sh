#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Create sources after feature setup, then rerun the hook to verify empty
# options leave workspace files untouched.
mkdir -p docs/agents/skills
echo "# Agent Configuration" > docs/agents/AGENTS.md
/usr/local/share/codex/setup-symlinks.sh

check "Codex root AGENTS.md link is disabled" [ ! -e "AGENTS.md" ]
check "Codex root AGENTS.md has no dangling link" [ ! -L "AGENTS.md" ]
check "Codex skills link is disabled" [ ! -e ".agents/skills" ]
check "Codex skills path has no dangling link" [ ! -L ".agents/skills" ]

# Report results
reportResults
