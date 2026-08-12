# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Community health files for open-source adoption (license, contributing guide, code of conduct, security policy, GitHub templates)

## [1.2.0] - 2026-08-03

### Added

- `blueprint` CLI with interactive menu and commands: `init`, `install`, `update`, `sync`, `del`, `doctor`
- Blueprint profiles: `default`, `engineering`, `startup`
- Optional GitLab overlay (`--overlay gitlab`)
- Multi-runtime projection (`--runtime cursor|claude|all`)
- Managed consumer contract via `HARNESS.md` and harness reference injection into `AGENTS.md` / `agents.md`
- Memory skeletons and preserve-local sync behavior
- Remote `source` URL cache under `$XDG_CACHE_HOME/blueprint/repos/`
- Package docs under `docs/` and example consumer under `examples/consumer/`
- CLI smoke and harness ownership tests under `tests/cli/`

### Changed

- Harness skills, workflow, and TUI refinements for install/sync flows

[Unreleased]: https://github.com/Supparerk23/agent-harness-blueprint/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/Supparerk23/agent-harness-blueprint/releases/tag/v1.2.0
