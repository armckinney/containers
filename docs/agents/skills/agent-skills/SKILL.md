---
name: Agent Skills
description: Rules and guidelines for creating and structuring reusable agent skills in this repository.
applyTo:
  - docs/agents/skills/**
---

# Agent Skills Standard

All instruction files are structured as modular **skills** to ensure reusability, isolation, and tooling compatibility.

## Structure

Each skill must live in a dedicated subfolder under `docs/agents/skills/` and have a `SKILL.md` entry point:

```text
docs/agents/skills/<skill-name>/
└── SKILL.md
```

At container runtime, these skills are mapped as follows:
* **Google Antigravity**: Symlinked to `.agents/skills/<skill-name>/SKILL.md`
* **GitHub Copilot**: Symlinked to `.github/prompts/<skill-name>.prompt.md` as reusable custom prompts/slash commands.

## Writing `SKILL.md`

Every `SKILL.md` file must adhere to these guidelines:
1. **YAML Frontmatter**: Start the file with a YAML frontmatter block containing `name`, `description`, and `applyTo` keys:
   ```yaml
   ---
   name: Skill Name
   description: 1-2 sentence summary of when and why this skill is active.
   applyTo:
     - path/to/target/**
   ---
   ```
   * `name`: Human-readable name of the skill.
   * `description`: Purpose and context of the skill.
   * `applyTo`: A YAML list of glob patterns mapping this skill to specific workspace paths for Copilot. Use `**` to apply repository-wide.
2. **Markdown formatting**: Use standard Markdown format for headings, bullet points, and code samples.
