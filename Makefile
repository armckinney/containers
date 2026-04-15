.PHONY: test-features test-feature test-image

# Run all feature tests
test-features:
	@devcontainer features test \
		--project-folder features

# Test a specific devcontainer feature
# Usage: make test-feature FEATURE=<feature-name>
test-feature:
	@if [ -z "$(FEATURE)" ]; then \
		echo "Error: FEATURE variable not set"; \
		echo "Usage: make test-feature FEATURE=<feature-name>"; \
		echo "Available features:"; \
		ls -1 features/test/ | sed 's/^/  - /'; \
		exit 1; \
	fi
	@devcontainer features test \
		--project-folder features \
		--features "$(FEATURE)"

# Build a container image
# Usage: make build IMAGE=ubuntu TAG=24.04 [SUFFIX=dev] [MULTIARCH=1]
test-image:
	@if [ -z "$(IMAGE)" ] || [ -z "$(TAG)" ]; then \
		echo "Error: IMAGE and TAG variables are required"; \
		echo "Usage: make build IMAGE=<image> TAG=<tag> [SUFFIX=dev] [MULTIARCH=1]"; \
		echo ""; \
		echo "Examples:"; \
		echo "  make build IMAGE=ubuntu TAG=24.04"; \
		echo "  make build IMAGE=ubuntu TAG=24.04 SUFFIX=prod"; \
		echo "  make build IMAGE=python TAG=3.12.3 MULTIARCH=1"; \
		exit 1; \
	fi
	@suffix="$(SUFFIX)"; \
	if [ -z "$$suffix" ]; then suffix="dev"; fi; \
	flags=""; \
	if [ "$(MULTIARCH)" = "1" ]; then flags="-a"; fi; \
	./scripts/build-image.sh -i $(IMAGE) -t $(TAG) -s $$suffix $$flags
