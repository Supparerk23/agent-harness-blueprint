# Documentation index

Narrative docs for this shared agent blueprint package. Prefer this folder (`docs/`) as the canonical path. The `documents/` path is a compatibility symlink to `docs/`.

| Document | Contents |
|---|---|
| [compatibility.md](compatibility.md) | Shared sources vs `.cursor/` runtime compatibility |
| [quick-start.md](quick-start.md) | `/start` workflow, branching rules, warm `HOTCACHE.md` reminders |
| [memory-and-planning.md](memory-and-planning.md) | Repo-root memory files, telemetry vs rationale vs drafts |
| [slash-commands.md](slash-commands.md) | Cursor slash playbook inventory + Git/GitLab notes |
| [skills.md](skills.md) | Concept + intent for each skill under `.cursor/skills/` / `harness/skills/` |
| [rules.md](rules.md) | Concept + scope for each rule under `.cursor/rules/` / `harness/rules/` |
| [adoption-and-lineage.md](adoption-and-lineage.md) | Checklist for adopting the kit + lineage metadata |

## CLI

```bash
scripts/agent init
scripts/agent install default
scripts/agent install engineering-fastapi --overlay gitlab
scripts/agent doctor
```

Prefer `scripts/agent install <blueprint>` for new consumers; direct `.cursor/` copy remains supported.
