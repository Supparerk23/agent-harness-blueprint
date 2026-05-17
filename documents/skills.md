# Skills — concepts

Skills live under [.cursor/skills/](../.cursor/skills/) as `SKILL.md` plus optional bundles (templates, scripts, references). They are **human-curated** procedures—load them when the task matches their scope.

## `planning-execution-tracking`

**Intent:** Tie each implementation batch back to observable artifacts:

- reconcile `PLANNING.md` checkboxes / `## ✅ Done`,
- append a succinct `DECISIONS.md` line (did / why),
- append one capped `RUN_LOG.md` telemetry row,
- enforce RUN_LOG retention (keep ~30 freshest rows beneath the header).

Use whenever execution must leave audit breadcrumbs—not casual Q&A.

## `memory-system-protocol`

**Intent:** Define *how layered memory behaves* versus chat history:

- what belongs in telemetry vs rationale vs drafts,
- which layers to read before executing,
- how humans promote `LEARNING.md` ideas into curated skills/rules.

## `refactor-code` (+ `test-strategy.md`)

**Intent:** Opinionated Python simplification playbook—flatten complexity, extract duplication thoughtfully, preserve behavior. Ships with **`disable-model-invocation`** so tooling does not auto-load it—invoke deliberately when refactoring.

Companion **test-strategy** lays out regression priorities and safety rails. The workflow expects humans to apply risky edits/tests while the assistant analyzes and proposes increments.

## `docs-style`

**Intent:** Opinionated docs layout—thin root `README`, deeper material inside `documents/` with indexes plus guidance for richer `ARCHITECTURE.md` write-ups (Mermaid, lifecycle fidelity). Also `disable-model-invocation`; use when refactoring documentation IA.

## `skill-creator`

**Intent:** Meta-playbook for authoring new skills:

- interviewing intent/trigger phrases,
- bundling supplementary assets,
- qualitative + quantitative evaluation loops,
- tightening descriptions (“slightly pushy” wording) so retrieval triggers reliably.

Treat it as **authoring infrastructure**, not coding policy baked into builds.
