#!/bin/bash
set -e

source dev-container-features-test-lib

mkdir -p docs/agents/rules docs/agents/skills .claude
echo "# Source instructions" > docs/agents/CLAUDE.md
echo "# Existing workspace instructions" > CLAUDE.md
ln -s "keep-this-target" .claude/rules
mkdir -p .claude/skills
echo "existing skill destination" > .claude/skills/marker.txt

/usr/local/share/claude-code/setup-symlinks.sh

check "Existing CLAUDE.md remains a regular file" [ -f "CLAUDE.md" ]
check "Existing CLAUDE.md is not replaced by a symlink" [ ! -L "CLAUDE.md" ]
check "Existing CLAUDE.md content is preserved" [ "$(cat CLAUDE.md)" = "# Existing workspace instructions" ]
check "Dangling Claude Code rules symlink is preserved" [ -L ".claude/rules" ]
check "Dangling Claude Code rules symlink target is preserved" [ "$(readlink .claude/rules)" = "keep-this-target" ]
check "Existing Claude Code skills directory is preserved" [ -d ".claude/skills" ]
check "Existing Claude Code skills directory is not replaced by a symlink" [ ! -L ".claude/skills" ]
check "Existing Claude Code skills contents are preserved" [ "$(cat .claude/skills/marker.txt)" = "existing skill destination" ]

reportResults
