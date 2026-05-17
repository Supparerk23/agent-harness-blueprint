---
name: docs-style
description: Refactor repository docs into a short root README and modular documents/ structure. Use when users ask to shorten README, split docs by topic, preserve missing context, rename docs, fix broken doc links, or create architecture docs with Mermaid diagrams.
disable-model-invocation: true
---

# Docs Onboarding Style

## Objective

Apply this repository documentation pattern consistently:

1. Keep root `README.md` short.
2. Move detailed content into `documents/`.
3. Split large docs into focused topic files.
4. Preserve all important operational content during refactors.

## Rules

- Root `README.md` must be a landing page with:
  - short project summary
  - minimal quick start commands
  - links to `documents/` and key operational references
- Keep detailed content under `documents/`.
- Use clean file names without numeric prefixes.
- Maintain `documents/README.md` as the docs index.
- Never drop meaningful content when splitting; relocate it.

## Default Document Layout

Use these files unless the user asks for another layout:

- `documents/README.md`
- `documents/quick-start.md`
- `documents/architecture-overview.md`
- `documents/development-workflow.md`
- `documents/api-basics.md`
- `documents/project-structure.md`
- `documents/detailed-reference.md`

Common topic files under detailed reference:

- `documents/request-examples.md`
- `documents/async-report-flow.md`
- `documents/database-migrations.md`
- `documents/image-checking-api.md`
- `documents/environment-variables.md`
- `documents/database-schema.md`
- `documents/security-operations.md`

## Execution Workflow

1. Read current root `README.md` and `documents/*`.
2. Identify high-value sections that must be preserved (migrations, env vars, troubleshooting, security scans, async/retry flows).
3. Split large docs into focused topic files.
4. Update internal links in:
   - `README.md`
   - `documents/README.md`
   - any file that references renamed/moved docs
5. Delete deprecated duplicate docs only after links are corrected.
6. Validate no stale references remain.

## Architecture Document Pattern

When creating or updating `ARCHITECTURE.md`:

- Include required headings from user (for example `## System Overview`, `## Data Flow`).
- Include text plus Mermaid diagrams.
- If user provides explicit lifecycle/state flow, mirror it faithfully (prefer `stateDiagram-v2` for state-heavy behavior).

## Output Template

Use this response format after doc changes:

- What changed (short bullets)
- Added files
- Updated files
- Any preserved/migrated content notes
