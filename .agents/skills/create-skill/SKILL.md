---
name: create-skill
description: Create and maintain focused, reusable agent skills in this repository.
applyTo:
  - .agents/skills/**
---

# Create Skills

Use this skill when adding or revising an agent skill in this repository. A skill gives agents reusable instructions for a specific task; keep each skill focused, easy to trigger, and self-contained. This workflow creates and maintains source skills under `.agents/skills/` only. Devcontainer feature hooks handle runtime mapping.

## Create or update a skill

1. Check the existing skills under `.agents/skills/` and reuse or extend one when it already covers the task.
2. Choose a short kebab-case identifier that describes the task, such as `create-rule`.
3. Create the skill at `.agents/skills/<skill-name>/SKILL.md`.
4. Add valid YAML frontmatter with `name`, `description`, and `applyTo` fields. The `name` must match the directory name.
5. Write steps that tell the agent when to use the skill, what context to inspect, how to complete the task, and how to verify the result.
6. Include examples, commands, or templates only when they make the task easier to perform consistently.
7. Update any skill catalog or documentation under `.agents/` that explicitly lists the skill, and fix references affected by a rename.

## Frontmatter

Use this structure:

```yaml
---
name: example-task
description: Explain when this skill applies and what task it helps complete.
applyTo:
  - path/to/relevant/files/**
---
```

- Keep `name` lowercase kebab-case and identical to the parent directory name.
- Make `description` specific enough that an agent can decide whether the skill is relevant.
- Use narrow `applyTo` globs for the files the skill helps create or maintain. Use a repository-wide glob only when the skill is broadly useful across the repository.

## Skill content

- Start with a short statement of when to use the skill.
- Organize instructions in the order an agent should follow them.
- Identify important constraints, expected outputs, and validation steps.
- Prefer direct, actionable instructions and repository-relative paths.
- Keep task-specific details in this skill rather than expanding a general skill with unrelated procedures.
- Use fenced code blocks for commands and templates. Ensure placeholders are clearly marked and examples are internally consistent.
- Link to related repository skills with relative links where useful.

## Repository conventions

Skills live in dedicated directories under `.agents/skills/` and use `SKILL.md` as the entry point. Keep skill source changes in `.agents/`; do not create tool-specific integration files or symlinks as part of this workflow.

For creating or maintaining modular rule files in `.agents/rules/`, follow the [create-rule skill](../create-rule/SKILL.md).

## Verify the result

After adding or moving a skill, confirm the file path and frontmatter agree:

```bash
skill_name="example-task"
test -f ".agents/skills/${skill_name}/SKILL.md"
rg -n "^name: ${skill_name}$|^description:|^applyTo:" \
  ".agents/skills/${skill_name}/SKILL.md"
```

Review all references to the old skill name after a rename and update any links or catalog entries that should point to the new path.
