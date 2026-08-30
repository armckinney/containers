#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Antigravity CLI (agy) is installed and accessible
check "Antigravity CLI (agy) is installed" command -v agy

# Test 2: Verify Antigravity CLI version works
check "Antigravity CLI version works" agy --version

# Test 3: Verify runtime helper scripts exist and are executable
check "start-daemon.sh is executable" [ -x "/usr/local/share/antigravity-remote/start-daemon.sh" ]
check "entrypoint.sh is executable" [ -x "/usr/local/share/antigravity-remote/entrypoint.sh" ]

# Test 4: Verify config.env exists
check "config.env exists" [ -f "/usr/local/share/antigravity-remote/config.env" ]

# Test 5: Verify start-daemon script execution
check "start-daemon runs without errors" /usr/local/share/antigravity-remote/start-daemon.sh

# Test 6: Verify log file is generated
check "Daemon log file created" [ -f "/root/.antigravity/agy_daemon.log" ]

# Test 7: Verify fallback GUID is created
check "Fallback GUID generated" [ -s "/root/.antigravity/.instance_guid" ]

# Report results
reportResults
