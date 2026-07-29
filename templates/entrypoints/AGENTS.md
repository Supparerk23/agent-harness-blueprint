# AGENTS.md

Shared agent contract for this repository. Every coding agent (Cursor, Claude Code, Copilot, or others) should follow this file.

This project uses **shared-agent-blueprints**: a team harness for rules, commands, skills, and memory so AI work stays consistent across tools and sessions.

## Required setup

Before starting product work, install the harness:

```bash
# 1) Shared contract + memory skeletons (no tool runtime yet)
/path/to/shared-agent-blueprints/scripts/agent init --target .

# 2) Project commands/rules/skills into tool runtimes
/path/to/shared-agent-blueprints/scripts/agent install default --runtime all --target .
# engineering + GitLab MR playbooks:
# /path/to/shared-agent-blueprints/scripts/agent install engineering --overlay gitlab --runtime all --target .
```

`--runtime` may be `cursor`, `claude`, or `all`. Omit it to pick interactively (Cursor and Claude are both optional). Re-sync later with `scripts/agent sync --target .`.

## Harness overview

| Layer | Role |
|---|---|
| **Commands** | Named playbooks (`/start`, `/review`, `/commit`, forge overlays) |
| **Rules** | Always-on or path-scoped policy |
| **Skills** | Curated multi-step procedures (`SKILL.md` + optional templates) |
| **Memory files** | Cross-session planning, decisions, telemetry, scratch state |

Canonical sources live in the blueprint package under `harness/`. This repo only holds **projections** into tool-specific runtimes.

## Runtime layout

After `install --runtime …`:

| Tool | Runtime root | Commands | Rules | Skills | Templates |
|---|---|---|---|---|---|
| Cursor | `.cursor/` | `.cursor/commands/` | `.cursor/rules/` | `.cursor/skills/` | `.cursor/templates/` |
| Claude Code | `.claude/` | `.claude/commands/` | `.claude/rules/` | `.claude/skills/` | `.claude/templates/` |

Workflow templates (`adr`, `prd`, `review-checklist`) stay under the runtime — they are not copied to a project-root `templates/` folder.

Agents that only read root markdown still get this contract from `AGENTS.md`. Claude Code also loads `CLAUDE.md` (thin pointer here).

Prefer updating the blueprint package, then `scripts/agent sync --target .` — do not fork shared playbooks in-place unless you intend a local override.

## AI workflow

1. **Orient** — Read this file, then `AGENTS.local.md` / `CLAUDE.local.md` if present, then relevant rules/skills for the task.
2. **Start a task** — Run `/start` (or follow that playbook): create a feature/hotfix branch and reset task-scoped memory templates.
3. **Plan** — Keep goals and checklists truthful in `PLANNING.md`.
4. **Execute in batches** — Implement, then update memory together:
   - `PLANNING.md` — checkboxes / done list
   - `DECISIONS.md` — what changed and why
   - `RUN_LOG.md` — short telemetry only
   - `HOTCACHE.md` — replace stale operational scratch
5. **Review / ship** — Use `/review`, `/commit`, and forge commands (`/pr`, etc.) when installed.
6. **Learn carefully** — Draft notes in `LEARNING.md`; promote to skills/rules only after human review. Ban repeats in `ANTI-PATTERNS.md`.

## Memory harness

| File | Role |
|---|---|
| `PLANNING.md` | Goals and task checklists |
| `DECISIONS.md` | Why logs |
| `RUN_LOG.md` | Execution telemetry only |
| `HOTCACHE.md` | Short-lived operational state |
| `LEARNING.md` | Candidate insights |
| `ANTI-PATTERNS.md` | High-confidence safety bans |
| `ARCHITECTURE.md` | Stable design (never auto-reset) |

Install/sync never overwrites these once they exist. `/start` may reset **content** of task-scoped files from skill templates; it must not reset `ARCHITECTURE.md` or installed skill trees.

## Overrides (always win)

- `AGENTS.local.md`
- `CLAUDE.local.md`
- `.agent-blueprint.local.yaml`
- `*.local.mdc` / local rule files under the active runtime

Shared installs must not overwrite local state or unmanaged local files (conflict siblings use `*.blueprint-conflict`).

## Do

- Follow existing project patterns; prefer composition over inventing architecture
- Keep handlers/routes thin when the project uses that pattern
- Update planning, decisions, and run-log together after execution batches
- Confirm before destructive Git, DB, infra, credential, or mass-refactor operations

## Don't

- Skip `init` / `install` and invent a parallel agent layout
- Treat forge (GitHub vs GitLab) or stack rules as universal unless this repo installed them
- Store reflections in `RUN_LOG.md` or promote every `LEARNING.md` note into a rule without review
- Commit secrets into `.agent-blueprint.yaml` or playbooks
