---
name: create-adr
description: Template and instructions to create a new Architecture Design Record (ADR) using Gyrus.
applyTo:
  - .gyrus/docs/**
  - docs/**
---

# Create ADR

Use this skill when you need to document a new architectural or design decision. All ADRs are managed by the Gyrus Context Control Plane.

## Creating an ADR with Gyrus CLI

Run the following command to scaffold a new ADR:

```bash
gyrus create \
  --id "adr-00X-name-of-decision" \
  --title "Title of Decision" \
  --category architecture \
  --type adr \
  --owner-group root \
  --scope reference
```

Alternatively, create the file manually in `.gyrus/docs/root/reference/`:

* **Directory**: `.gyrus/docs/root/reference/`
* **Filename**: `adr-00X-name-of-decision.md`
  * Use 3-digit zero-padded numbers for `00X`.
  * Use lowercase kebab-case for the name.

## ADR Template

```markdown
---
id: adr-00X-name-of-decision
title: Title of Decision
category: architecture
type: adr
format: markdown
owner_group: root
version: 1
status: proposed
immutable: true
last_modified_by: <author>
last_updated: YYYY-MM-DD
tags:
  - architecture
  - adr
dependencies: []
---

# Architecture Decision Record: Title of Decision

## Context

* **Status:** Proposed
* **Date:** YYYY-MM-DD
* **Author:** [Name/Agent]

Describe the background, the problem we are trying to solve, and the forces/constraints at play.

---

## Decision

State the decision clearly, including chosen options, technical choices, and the specific rationale for why this option was preferred.

---

## Consequences

* **Positive / Gains:**
  * [Detail positive impact]
* **Negative / Trade-offs:**
  * [Detail drawbacks or trade-offs]
```

## Synchronizing with Gyrus

After creating or modifying an ADR, re-index and link the decision:

```bash
# Link to related specifications or ADRs
gyrus link adr-00X-name-of-decision <related-id> --rel-type depends_on

# Re-sync search index and graph
gyrus sync
```
