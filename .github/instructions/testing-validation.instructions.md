---
applyTo: "containers/**"
---

# Testing and Validation Instructions

## Manual Validation Steps

- **ALWAYS** validate every built image before considering it complete.
- Test image functionality: `docker run --rm armck/<image>:<tag>-<suffix> echo "Image works!"`
- Verify installed tools work:
  - Ubuntu: `docker run --rm armck/ubuntu:24.04-dev bash -c "echo 'Ubuntu validation passed'"`
  - Python: `docker run --rm armck/python:3.12.3-dev python3 --version`
  - .NET: `docker run --rm armck/dotnet:8.0-dev dotnet --version`
  - Terraform: `docker run --rm armck/terraform:1.10.5-dev terraform version`

## End-to-End Validation Scenarios

**ALWAYS** run these scenarios after making any changes to validate your work:

### Scenario 1: Base Ubuntu Image Changes
1. Build Ubuntu image: `docker buildx build --no-cache -t "armck/ubuntu:24.04-test" -f "containers/ubuntu/24.04/Dockerfile.dev" .`
2. Test basic functionality: `docker run --rm armck/ubuntu:24.04-test bash -c "echo 'Ubuntu test passed'"`
3. Verify tools: `docker run --rm armck/ubuntu:24.04-test which curl git apt`
4. Test derived images still build (Python, .NET, Terraform)

### Scenario 2: Python Image Changes  
1. Build Python image: `docker buildx build --no-cache -t "armck/python:3.12.3-test" -f "containers/python/3.12.3/Dockerfile.dev" .`
2. Test Python functionality: `docker run --rm armck/python:3.12.3-test python3 --version`
3. Test package management: `docker run --rm armck/python:3.12.3-test pipx --version`
4. Test Pyspark dependency builds correctly

### Scenario 3: Build Script Validation
1. Test corrected build command: `docker buildx build --no-cache -t "armck/dotnet:8.0-test" -f "containers/dotnet/8.0/Dockerfile.dev" .`
2. Verify functionality: `docker run --rm armck/dotnet:8.0-test dotnet --version`
3. Confirm multi-platform capability (if supported): `docker buildx build --platform linux/amd64,linux/arm64 --no-cache -t "test-multi" -f "containers/ubuntu/24.04/Dockerfile.dev" .`

## Validation Requirements

- **No traditional tests**: Validation is through successful Docker builds and basic functionality tests
- **ALWAYS validate functionality** after building, not just build success

## Timing Reference

- .NET 8.0 dev build: 16.7 seconds (add 50% buffer = 25 second timeout minimum)
  - **Note:** Despite these minimums, always use the recommended timeout of 180+ seconds for Ubuntu and .NET builds, to account for variability and ensure reliability.
- Python builds: May fail due to network constraints downloading source from python.org
- Complex builds with compilation: Allow 10-30 minutes minimum
