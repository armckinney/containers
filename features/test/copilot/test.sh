#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify GitHub CLI is installed and accessible
check "GitHub CLI is installed" command -v gh

# Test 2: Verify GitHub CLI version command works
check "GitHub CLI version works" gh --version

# Test 3: Verify extension is installed when auth is available, otherwise allow skip.
check "gh-copilot extension install behavior" /bin/bash -c '
if gh extension list | grep -q "github/gh-copilot"; then
	exit 0
fi

if gh auth status >/dev/null 2>&1 || [ -n "${GH_TOKEN:-}" ] || [ -n "${GITHUB_TOKEN:-}" ]; then
	exit 1
fi

exit 0
'

# Test 4: Verify Copilot command is available when extension is installed.
check "gh copilot command availability behavior" /bin/bash -c '
if gh extension list | grep -q "github/gh-copilot"; then
	gh copilot --help >/dev/null
	exit $?
fi

exit 0
'

# Report results
reportResults
