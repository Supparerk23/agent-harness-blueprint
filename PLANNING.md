## Goal

Document this Cursor harness with a thin root `README` plus focused pages under `documents/`, covering memory layers, commands, skill/rule concepts, and adoption notes.

## Task

- [x] Run `/start` memory reset (fresh planning, telemetry header, HOTCACHE)
- [x] Author README explaining skills/rules/concepts
- [x] Shorten root README and relocate detail into `documents/`
- [ ] Optional follow-up: align rules with repo stack (`develop` branch, MR host, Alembic layout) before shipping

## ✅ Done

- Reset task-scoped memory files from Cursor templates (`/start`).
- Replaced verbose README with landing page linking to modular docs (quick-start, memory, slash commands, skills, rules, adoption).
- Split prior README prose into dedicated `documents/*.md` files with cross-links preserved.

## Blockers

- None currently

## Context for AI

This repo is primarily a portable **Cursor kit** (.cursor/commands, rules, skills) plus blueprint docs. Heavy application code may live elsewhere; several rules assume a FastAPI + workers layout from the upstream healthcheck origin—call that out instead of implying every path exists here.
