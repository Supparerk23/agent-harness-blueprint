---
name: docs-style
description: Refactor repository docs into a short root README and modular docs/ structure. Use when users ask to shorten README, split docs by topic, preserve missing context, rename docs, fix broken doc links, or create architecture docs with Mermaid diagrams.
disable-model-invocation: true
---

# Docs Onboarding Style

## Objective

Apply this repository documentation pattern consistently:

1. Keep root `README.md` short.
2. Move detailed content into `docs/`.
3. Split large docs into focused topic files.
4. Preserve all important operational content during refactors.

In this blueprint package, `documents/` is a compatibility symlink to `docs/`. Prefer writing and linking `docs/` in new work.

## Rules

- Root `README.md` must be a landing page with:
  - short project summary
  - minimal quick start commands
  - links to `docs/` and key operational references
- Keep detailed content under `docs/`.
- Use clean file names without numeric prefixes.
- Maintain `docs/README.md` as the docs index.
- Never drop meaningful content when splitting; relocate it.
- Do not maintain a second parallel docs tree (no `docs/` + `documents/` content duplication).

## Default Document Layout

Use these files unless the user asks for another layout:

- `docs/README.md`
- `docs/quick-start.md`
- `docs/architecture-overview.md`
- `docs/development-workflow.md`
- `docs/api-basics.md`
- `docs/project-structure.md`
- `docs/detailed-reference.md`

Common topic files under detailed reference:

- `docs/request-examples.md`
- `docs/async-report-flow.md`
- `docs/database-migrations.md`
- `docs/image-checking-api.md`
- `docs/environment-variables.md`
- `docs/database-schema.md`
- `docs/security-operations.md`

## Execution Workflow

1. Read current root `README.md` and `docs/*`.
2. Identify high-value sections that must be preserved (migrations, env vars, troubleshooting, security scans, async/retry flows).
3. Split large docs into focused topic files.
4. Update internal links in:
   - `README.md`
   - `docs/README.md`
   - any file that references renamed/moved docs
5. Delete deprecated duplicate docs only after links are corrected.
6. Validate no stale references remain.

## Architecture Document Pattern

When creating or updating `ARCHITECTURE.md`:

- Include required headings from user (for example `## System Overview`, `## Data Flow`).
- Include text plus Mermaid diagrams.
- If user provides explicit lifecycle/state flow, mirror it faithfully (prefer `stateDiagram-v2` for state-heavy behavior).

## Guardrails

- Prefer relocation over deletion when uncertain about content value.
- Keep operational runbooks and env/migration details discoverable from the root README via links.
- Avoid inventing new top-level doc folders when `docs/` already exists.
