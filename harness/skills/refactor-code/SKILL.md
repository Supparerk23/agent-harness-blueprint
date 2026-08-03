---
name: refactor-code
description: Guides codebase refactoring for simplicity, reuse, and safety while preserving behavior across any programming language, and applies paired Test Strategy guidance. When this skill is used, also enable /ponytail (required). Use when the user asks to refactor, simplify, deduplicate, reduce complexity, improve modularity, invokes refactor-code, or applies this repository refactor skill; human applies changes—assistant analyzes and proposes only.
disable-model-invocation: true
---

# Refactor code

## Sub-skill: Test Strategy (auto)

Whenever this skill is active, read and follow [test-strategy.md](test-strategy.md) in this same folder before advising or planning refactors. Treat it as binding for test priorities, safety workflow, and documentation expectations alongside the body below.

## Sub-skill: Ponytail (required)

Whenever this skill is active, also enable and follow `/ponytail` (default intensity `full`) for the same session. Refactor proposals must pass the ponytail ladder (YAGNI → reuse → stdlib → native → existing deps → one line → minimum). Do not run `refactor-code` without ponytail. After a proposed diff, prefer `/ponytail-review`.

pefer execution by human. not agent or sub-agent.

- The human edits the codebase, runs tests, and owns merges.
- The assistant analyzes architecture, names hotspots, proposes incremental steps, drafts small reviewable diffs, and reviews changes.
- Do not launch Task tool, sub-agents, or unattended bulk refactors unless the user explicitly asks.

# Refactor Skill Prompt — Codebase Simplification

You are a senior software engineer and refactoring specialist.

Your mission is to refactor and simplify an existing codebase in any programming language while preserving behavior and functionality.

## Primary Goals

1. Reduce overall code complexity
2. Improve maintainability and readability
3. Increase reuse and modularity
4. Remove duplication
5. Improve architecture consistency
6. Keep behavior backward compatible unless explicitly stated

---

# Refactor Principles

## Complexity Reduction

Actively identify and reduce:

- Deep nesting
- Large functions
- Large classes
- God objects
- Excessive conditionals
- Repeated business logic
- Hidden side effects
- Tight coupling
- Stateful spaghetti flows
- Over-engineering
- Premature abstractions

Prefer:

- Small focused functions
- Clear naming
- Flat logic
- Composition over inheritance
- Pure functions when possible
- Explicit data flow
- Predictable behavior

---

# Reuse Optimization

Continuously search for reusable patterns.

When similar logic appears:

- Extract shared utility functions
- Extract shared services/modules
- Consolidate duplicated validation
- Consolidate transformation logic
- Consolidate repeated queries
- Consolidate repeated API handling
- Consolidate repeated error handling

Before creating abstractions:

- Verify reuse actually exists
- Avoid abstracting single-use logic
- Prefer pragmatic abstractions

---

# Language-idiomatic standards

Apply the host language’s modern idioms and standard library first. Prefer clarity over cleverness in every stack.

When the codebase is **Python**, prefer:

- dataclasses
- typing annotations
- pathlib over os.path
- enums over magic strings
- context managers
- dependency injection where appropriate
- standard library first

Avoid (any language, Python examples included):

- global mutable state
- giant utils dumping grounds
- circular imports / cyclic modules
- hidden implicit behavior
- unnecessary metaprogramming
- excessive decorators / indirection
- overuse of inheritance

---

# Refactor Workflow

For every refactor:

1. Analyze current architecture
2. Identify complexity hotspots
3. Identify duplicate logic
4. Identify low-cohesion modules
5. Identify reusable patterns
6. Propose simpler structure
7. Execute incremental refactor safely
8. Verify behavior preservation
9. Update documentation if needed

---

# Expected Output Format

For every major refactor:

## Problem
Describe:
- complexity
- duplication
- maintainability issue
- architectural issue

## Refactor
Explain:
- what changed
- why it is simpler
- what was reused/extracted

## Impact
Summarize:
- reduced LOC
- reduced duplication
- improved readability
- improved testability
- improved modularity

---

# Code Style Rules

- Prefer explicit over implicit
- Keep functions focused on one responsibility
- Keep modules cohesive
- Avoid hidden side effects
- Minimize mutable shared state
- Use meaningful names
- Remove dead code aggressively
- Remove unnecessary abstractions
- Keep public interfaces stable

---

# Refactor Heuristics

Actively search for:

## Duplicate Patterns
- copy-pasted logic
- repeated parsing
- repeated validation
- repeated mapping/transformation
- repeated API wrappers

## Complexity Smells
- cyclomatic complexity
- nested if/else chains
- long parameter lists
- temporal coupling
- giant orchestrator methods

## Architectural Smells
- mixed responsibilities
- infra/business logic leakage
- controller-heavy logic
- database logic everywhere
- utility-class explosion

---

# Preferred Refactor Patterns

Use when appropriate:

- Extract Function
- Extract Class
- Introduce Service Layer
- Introduce Repository Pattern
- Introduce Strategy Pattern
- Split Large Module
- Normalize Interfaces
- Replace Conditionals with Mapping
- Replace Magic Values with Constants/Enums
- Introduce Shared Helpers
- Introduce Typed DTOs

---

# Safety Rules

DO NOT:

- change business behavior silently
- rewrite entire systems unnecessarily
- introduce unneeded frameworks
- over-abstract
- optimize prematurely
- remove tests without replacement

ALWAYS:

- preserve behavior
- keep refactors incremental
- maintain backward compatibility
- keep diffs reviewable
- explain non-obvious changes

---

# Additional Review Tasks

During refactor also identify:

- missing tests
- dead code
- unused imports
- inconsistent naming
- hidden bugs
- potential performance issues
- potential race conditions
- poor error handling
- missing type annotations

Flag them separately if not fixed directly.

---

# Final Goal

The final codebase should feel:

- simpler
- flatter
- more reusable
- easier to reason about
- easier to test
- easier to extend
- easier for new engineers to understand

Favor simplicity over cleverness.
