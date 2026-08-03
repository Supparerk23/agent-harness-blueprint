---
name: memory-system-protocol
description: Maintain layered AI engineering memory across planning, telemetry, decisions, architecture, hot cache, learning, anti-patterns, and curated skills. Use when executing work from memory files or when the user mentions PLANNING.md, RUN_LOG.md, ARCHITECTURE.md, DECISIONS.md, HOTCACHE.md, LEARNING.md, ANTI-PATTERNS.md, or skills.
---

# AI Engineering Memory System Protocol

You are operating inside an AI-assisted engineering workflow with layered memory and execution systems.

Your responsibility is NOT only to execute tasks, but also to maintain clean operational cognition and reusable engineering knowledge.

---

# Core Principle

Do NOT treat memory as a chat transcript.

The system separates:
- execution state
- telemetry
- decisions
- reflections
- reusable skills
- safety constraints

Each layer has different retention and retrieval behavior.

---

# System Files

## PLANNING.md

Source of truth for active tasks, goals, status, and priorities. Execute work from this file.

For checklist workflow, `## ✅ Done`, and task updates, use the **planning-execution-tracking** skill. For `PLANNING.md` copy-paste body on `/start`, see [planning-execution-tracking/templates.md](../planning-execution-tracking/templates.md).

---

## RUN_LOG.md

Execution telemetry only (timestamps, scope, files, tests, status, errors). Not reflections or lessons.

For table format, example rows, workflow, and row defaults, use the **planning-execution-tracking** skill and its [templates.md](../planning-execution-tracking/templates.md).

---

## ARCHITECTURE.md

Contains:
- system design
- technical structure
- module relationships
- infrastructure patterns
- constraints

Use this as architectural context during implementation.

Update only when architectural understanding changes.

---

## DECISIONS.md

Engineering tradeoffs, rationale, rejected alternatives — not raw logs. Focus on why and consequences.

For append format and updates during execution, use the **planning-execution-tracking** skill and [templates.md](../planning-execution-tracking/templates.md) (`## DECISIONS entry format`).

---

# HOTCACHE.md

HOTCACHE is short-lived operational working memory.

Purpose:
- maintain execution continuity
- reduce repeated context loading
- preserve current assumptions and active state

HOTCACHE may contain:
- active branch
- current hypothesis
- pending validations
- active files
- temporary debugging state
- current environment
- immediate next steps

HOTCACHE is:
- volatile
- replaceable
- aggressively compacted

Do NOT treat HOTCACHE as long-term memory.

Do NOT append endlessly.

Remove stale information aggressively.

HOTCACHE should optimize token efficiency and execution continuity.

---

# LEARNING.md

LEARNING.md is a reflection buffer for candidate insights.

Purpose:
- capture reusable lessons
- identify repeated patterns
- preserve operational discoveries
- record debugging heuristics
- capture possible future skills

LEARNING.md is NOT authoritative knowledge.

It may contain:
- uncertainty
- partial observations
- duplicate ideas
- incomplete heuristics

Entries should be concise and generalized where possible.

Good examples:
- repeated deployment failures
- debugging patterns
- workflow improvements
- validation heuristics
- operational discoveries

Bad examples:
- raw logs
- full transcripts
- long narratives
- emotional commentary

Do NOT automatically convert learning into permanent rules.

Human review and consolidation are required.

---

# ANTI-PATTERNS.md

ANTI-PATTERNS.md contains dangerous or repeatedly harmful behaviors.

Purpose:
- prevent destructive execution
- preserve safety constraints
- reduce repeated operational mistakes

Examples:
- force push without confirmation
- production migrations during rolling deployment
- deleting infrastructure without validation
- unsafe schema modifications
- bypassing health checks

Anti-patterns should be:
- concise
- actionable
- high confidence
- operationally important

Treat anti-patterns as safety memory.

---

# skills/

The skills directory contains curated procedural knowledge.

Skills are:
- reusable
- concise
- operational
- human-approved
- generalized

Examples:
- kubernetes-debugging.md
- deployment-checklist.md
- incident-triage.md
- database-migration-safety.md

Skills are NOT generated automatically from every execution.

Skills emerge through repeated validated learning.

---

# Execution Workflow

## Phase 1 — Read Context

Before execution:
1. Read relevant PLANNING entries
2. Read relevant ARCHITECTURE sections
3. Read relevant DECISIONS
4. Read relevant skills
5. Read relevant anti-patterns
6. Read HOTCACHE

Do NOT load entire history unnecessarily.

Minimize token usage.

---

## Phase 2 — Execute

Perform the requested engineering work carefully.

While executing:
- update RUN_LOG
- update task status
- maintain HOTCACHE

Avoid destructive actions unless explicitly confirmed.

Examples requiring confirmation:
- rm -rf
- force push
- production migration
- irreversible database operations
- infrastructure deletion
- credential rotation
- mass refactors with unclear blast radius

---

## Phase 3 — Reflect

After execution:
- optionally append concise candidate insights to LEARNING.md

Reflections should:
- focus on reusable patterns
- avoid verbosity
- avoid repetition
- avoid speculative claims

Do NOT automatically create skills.

---

# Human Consolidation Model

The human operator periodically reviews:
- LEARNING.md
- ANTI-PATTERNS.md
- recurring execution patterns

The human may:
- promote reusable insights into skills/
- refine anti-patterns
- discard noisy reflections
- merge duplicate learnings

The system prioritizes:
- high-signal memory
- low-noise retrieval
- token efficiency
- operational reliability

---

# Memory Rules

## HOTCACHE.md
Short-lived execution cognition.

## RUN_LOG.md
Telemetry and execution history.

## LEARNING.md
Reflection candidates.

## skills/
Curated procedural intelligence.

## ANTI-PATTERNS.md
Operational safety memory.

## DECISIONS.md
Reasoned engineering tradeoffs.

---

# Task start reset

When resetting files for a new task (`/start`):

- [templates.md](templates.md) → `HOTCACHE.md`, `ANTI-PATTERNS.md`, `LEARNING.md`
- [planning-execution-tracking/templates.md](../planning-execution-tracking/templates.md) → `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`

Do not reset files listed under **Do not reset** in [templates.md](templates.md).

---

# Critical Constraints

- Do NOT endlessly append context.
- Do NOT preserve stale assumptions.
- Do NOT treat all observations as reusable knowledge.
- Do NOT convert every execution into permanent memory.
- Prefer compact operational summaries.
- Prefer retrieval over accumulation.
- Prefer signal over volume.

The objective is to create:
- scalable engineering memory
- reusable operational intelligence
- efficient execution continuity
- safe autonomous assistance
without uncontrolled memory growth.
