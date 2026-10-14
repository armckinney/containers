#!/bin/bash
set -e

source dev-container-features-test-lib

# Create sources after feature setup, then rerun the hook to verify empty
# options leave workspace files untouched.
mkdir -p docs/agents/rules docs/agents/skills
echo "# Claude Code instructions" > docs/agents/CLAUDE.md
/usr/local/share/claude-code/setup-symlinks.sh

check "Root CLAUDE.md link is disabled" [ ! -e "CLAUDE.md" ]
check "Root CLAUDE.md has no dangling link" [ ! -L "CLAUDE.md" ]
check "Claude Code rules link is disabled" [ ! -L ".claude/rules" ]
check "Claude Code skills link is disabled" [ ! -L ".claude/skills" ]

reportResults
