---
name: create-rule
description: Create and maintain modular rule files in the repository's .agents/rules directory.
applyTo:
  - .agents/rules/**
  - .agents/skills/create-rule/**
---

# Create and Maintain Rule Files

Use this skill when adding, changing, renaming, or removing a modular repository rule. The source files belong directly under `.agents/rules/`. Keep this skill's rule authoring workflow scoped to `.agents`; devcontainer feature lifecycle hooks handle any runtime mapping or symlinks.

## Choose a trigger mode

Choose one mode based on when the rule should apply:

1. Use **glob-scoped** mode when the rule applies only to named file types or directories. This is the default for a rule targeting specific files.
2. Use **always-on** mode when the rule applies across the whole repository.

For task-based instructions that should load by semantic relevance, create a skill instead of a rule. A polyglot rule cannot express semantic-only behavior consistently across tools.

## Create the source rule

1. Choose a concise kebab-case name, such as `typescript-style`.
2. Create `.agents/rules/<kebab-case-name>.md` directly in `.agents/rules/`. Do not create rule subdirectories.
3. Add frontmatter for the selected mode using one of the templates below.
4. Write concise, actionable guidance in the Markdown body. Keep the rule focused on one topic.
5. Verify the source file and frontmatter.

### Mode 1: Path/glob-scoped rule

Keep `globs`, `paths`, and `applyTo` semantically equivalent. Use recursive `**` patterns for nested files and quote glob values in YAML. The arrays and string express the same file scope in the shared rule source.

```yaml
---
description: "Apply these conventions when editing TypeScript source and test files."
trigger: glob
globs: ["src/**/*.ts", "src/**/*.tsx"]
paths: ["src/**/*.ts", "src/**/*.tsx"]
applyTo: "src/**/*.ts,src/**/*.tsx"
---
```

Use patterns that describe the same file set in all three fields. For example, do not use `src/*.ts` if nested files under `src/` should match; use `src/**/*.ts`.

### Mode 2: Always-on repository rule

Use this mode only when the rule applies throughout the repository. Omit `paths` and set `applyTo` to `"**"`.

```yaml
---
description: "Apply these conventions to all work in this repository."
trigger: always_on
applyTo: "**"
---
```

Do not add `globs` or `paths` to this mode. If the guidance belongs in a root instruction file instead of a modular rule, use the existing root instruction mechanism.

## Frontmatter and naming requirements

- Use an Antigravity trigger value in exact snake_case: `glob`, `always_on`, `model_decision`, or `manual`. Do not use camelCase forms such as `alwaysOn`.
- Put every rule at `.agents/rules/<kebab-case-name>.md`. Never nest files under `.agents/rules/`.
- In glob-scoped mode, use recursive `**` patterns wherever matching nested directories is intended.
- Keep `globs` (array), `paths` (array), and `applyTo` (comma-separated string) semantically synchronized.
- Use `description` to say when the rule applies. Keep it concise and specific.
- Keep rule authoring changes under `.agents/rules/`. Do not create integration files, directories, or symlinks elsewhere; devcontainer feature hooks own runtime mapping.

## Verify the source rule

Run these commands from the repository root, replacing the example name with the rule's kebab-case name:

```bash
rule_name="typescript-style"
test -f ".agents/rules/${rule_name}.md"
rg -n '^---$|^description:|^trigger:|^globs:|^paths:|^applyTo:' \
  ".agents/rules/${rule_name}.md"
```

For a rename or removal, update only source files and references within `.agents/`. Do not perform tool-specific link cleanup here.
