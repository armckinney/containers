#!/bin/bash
set -e

# Import test library
source dev-container-features-test-lib

# Test 1: Verify Docker CLI is installed and accessible
check "Docker CLI is installed" command -v docker

# Test 2: Verify Docker daemon is running
check "Docker daemon is running" docker ps

# Test 3: Verify Docker version works
check "Docker version command works" docker --version

# Test 4: Verify Docker can pull images
check "Docker can pull images" docker pull alpine:latest

# Test 5: Verify Docker can run containers
check "Docker can run containers" docker run --rm alpine:latest echo "Docker-in-Docker works!"

# Report results
reportResults
