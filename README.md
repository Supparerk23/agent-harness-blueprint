# Agent harness blueprint

Portable **Cursor** harness: `.cursor/commands` (slash playbooks), `.cursor/skills` (curated procedures), and `.cursor/rules` (`.mdc` policy). The bundle nudges agents toward safer automation, traceable planning, and layered memory.

Originated with Finnomena's *AI Wealth Health Check* FastAPI + worker service—update or delete rules that mention `app/` layouts, GitLab `glab`, or Alembic when you target a different stack.

## Quick start

1. Copy `.cursor/` (or cherry-pick files) into the repo you want to instrument.
2. Run **`/start`**: branch `feature/[slug]` or `hotfix/[slug]`, reset task-memory files from [.cursor/commands/start.md](.cursor/commands/start.md) + template sources under `.cursor/skills/*/templates.md`.
3. Browse **[documents/quick-start.md](documents/quick-start.md)** for the full ritual and file list.

```bash
# optional sanity check once the kit is copied
git status
```

## Documentation map

Detailed concepts live under **[documents/](documents/README.md)**:

| Topic | File |
|---|---|
| **`/start` + branch ritual** | [documents/quick-start.md](documents/quick-start.md) |
| **Repo-root memory layers** (`PLANNING`, `RUN_LOG`, …) | [documents/memory-and-planning.md](documents/memory-and-planning.md) |
| **Slash commands** | [documents/slash-commands.md](documents/slash-commands.md) |
| **Skills (concepts)** | [documents/skills.md](documents/skills.md) |
| **Rules (`.mdc` concepts)** | [documents/rules.md](documents/rules.md) |
| **Adopting in new repos + naming lineage** | [documents/adoption-and-lineage.md](documents/adoption-and-lineage.md) |

Need the docs index first? Start at **[documents/README.md](documents/README.md)**.
