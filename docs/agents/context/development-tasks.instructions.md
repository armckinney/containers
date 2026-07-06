---
name: Development Tasks
description: Step-by-step instructions for adding new container images or modifying existing ones.
applyTo:
  - containers/**
---

# Development Tasks

## Adding New Images

1. Create directory structure: `containers/<image>/<version>/`
2. Add both `Dockerfile` and `Dockerfile.dev`
3. Update GitHub workflows to include new image in build matrix
4. Add documentation entry in `containers/README.md`
5. Test build locally before committing

## Modifying Existing Images

1. **ALWAYS** build and test the image locally first.
2. Understand dependency chain - changes to base images affect dependent images.
3. Test functionality with real scenarios, not just build success.
4. Update version numbers if making significant changes.
