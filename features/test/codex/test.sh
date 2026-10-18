#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Verify Codex CLI is installed and usable
check "Codex CLI is installed" command -v codex
check "Codex CLI version works" codex --version

# A global command must not depend on root's private or host-mounted home.
check "Codex package is outside root's home" bash -c \
  '[[ "$(readlink -f /usr/local/bin/codex)" == /usr/local/share/codex/* ]]'
check "Codex CLI works as root with a standard PATH" su -s /bin/sh root -c \
  'PATH=/usr/local/bin:/usr/bin:/bin codex --version'
check "Codex CLI works as an unprivileged user with a standard PATH" su -s /bin/sh nobody -c \
  'PATH=/usr/local/bin:/usr/bin:/bin codex --version'

# Verify the feature lifecycle hook is installed
check "Codex symlink setup script is installed" [ -x "/usr/local/share/codex/setup-symlinks.sh" ]

# Report results
reportResults
