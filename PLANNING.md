## Goal

Refactor this repository into a reusable Shared Agent Blueprint package with blueprints, manifest, install CLI, and backward-compatible `.cursor/` runtime.

## Task

- [x] Run `/start` memory reset (fresh planning, telemetry header, HOTCACHE)
- [x] Author README explaining skills/rules/concepts
- [x] Shorten root README and relocate detail into `docs/` (legacy `documents/` kept as symlink)
- [x] Add `VERSION`, `manifest.yaml`, and blueprint profiles (`default`, `engineering`, `engineering-fastapi`, `startup`)
- [x] Extract shared sources into `harness/`, `prompts/`, `templates/`, `docs/`
- [x] Add `scripts/agent` CLI (`init|install|update|sync|doctor`) with preserve-local sync
- [x] Add compatibility layer (`AGENTS.md`, `CLAUDE.md`, keep `.cursor/`; `documents` → `docs` symlink)
- [x] Add example consumer under `examples/consumer/`
- [x] Deduplicate `docs/` vs `documents/` (canonical `docs/`, symlink alias)
- [ ] Optional follow-up: GitHub/`gh` forge overlay parity with GitLab overlay
- [ ] Optional follow-up: mark managed `.cursor/` files after first sync so package-self sync is quieter

## ✅ Done

- Reset task-scoped memory files from Cursor templates (`/start`).
- Replaced verbose README with landing page linking to modular docs (quick-start, memory, slash commands, skills, rules, adoption).
- Split prior README prose into dedicated topical docs under `docs/` (with `documents/` as legacy symlink).
- Introduced shared package layout: `blueprints/`, `harness/`, `prompts/`, `templates/`, `docs/`, `scripts/agent`, `VERSION`, `manifest.yaml`.
- Preserved existing `.cursor/` harness behavior; FastAPI/GitLab assets moved into optional blueprint/overlay paths.
- Added `AGENTS.md` / `CLAUDE.md` compatibility entrypoints and example consumer config.
- Validated `scripts/agent install engineering-fastapi --overlay gitlab` into a temp target; `doctor` healthy.
- Removed duplicated `documents/` content tree; single source of truth is `docs/`.

## Blockers

- None currently

## Context for AI

This repo is now both a portable Cursor kit (`.cursor/`) and a shared blueprint package. Prefer updating `harness/` / `blueprints/` / `templates/` then syncing; do not treat FastAPI or GitLab assumptions as part of `default`.
