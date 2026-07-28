# Test Strategy

The purpose of testing during refactoring is to preserve behavior while safely reducing complexity.

Tests should prioritize:
- behavior verification
- regression prevention
- confidence during incremental refactors
- fast feedback loops

Avoid writing tests that tightly couple to implementation details.

---

# Core Principles

## Preserve Existing Behavior

Before major refactors:

- identify critical business behavior
- identify risky execution paths
- identify edge cases
- identify existing undocumented behavior

Refactoring must not silently change system behavior unless explicitly requested.

---

## Prefer Behavior Tests Over Implementation Tests

Good tests validate:
- inputs
- outputs
- side effects
- contracts
- business rules

Avoid tests that:
- depend on private methods
- assert internal implementation
- break during harmless refactors
- snapshot unstable internals

Prefer:
- public API tests
- service-level tests
- integration boundary tests

---

# Test Coverage Priorities

Prioritize tests for:

## High-Risk Logic
- payment logic
- authentication
- authorization
- financial calculations
- state transitions
- concurrency-sensitive code
- retry/idempotency flows

## Complexity Hotspots
- deeply nested logic
- large orchestrator functions
- branching-heavy flows
- legacy modules
- fragile integrations

## Shared Reusable Components
- utility functions
- validators
- transformers
- repositories
- shared services

---

# Refactor Safety Workflow

Before refactoring:

1. Identify existing tests
2. Run baseline tests
3. Add missing safety tests if needed
4. Capture current behavior
5. Refactor incrementally
6. Re-run tests after each major step

If behavior is unclear:
- preserve current behavior first
- document ambiguity separately

---

# Test Design Rules

Prefer tests that are:
- deterministic
- isolated
- fast
- readable
- minimal
- stable

Avoid:
- flaky tests
- network dependency
- real external services
- sleep-based timing tests
- giant fixtures
- over-mocking

Use:
- dependency injection
- fakes
- lightweight fixtures
- test factories
- explicit setup

---

# Mocking Guidelines

Mock only:
- external APIs
- infrastructure boundaries
- slow dependencies
- non-deterministic systems

Avoid mocking:
- core business logic
- internal pure functions
- simple data structures

Over-mocking creates brittle tests.

---

# Incremental Refactor Rules

During refactor:

- keep tests passing continuously
- avoid giant unreviewable rewrites
- preserve public interfaces
- preserve API contracts
- preserve database semantics

If interface changes are necessary:
- add compatibility layers when possible
- migrate incrementally
- document breaking changes clearly

---

# Test Pyramid Guidance

Prefer:

## Unit Tests
For:
- pure functions
- validators
- transformations
- business rules

## Integration Tests
For:
- repositories
- database interactions
- service boundaries
- queue/event systems

## End-to-End Tests
Only for:
- critical user journeys
- core production flows

Avoid excessive E2E coverage.

---

# Legacy Code Strategy

For legacy systems with low coverage:

1. Do NOT rewrite immediately
2. Add characterization tests first
3. Capture existing behavior
4. Refactor gradually behind safety tests

Prefer stabilization before modernization.

---

# Performance & Reliability Checks

During refactor also verify:

- no major performance regression
- no additional database round trips
- no memory leak introduction
- no concurrency regression
- no retry/idempotency breakage

Flag potential risks explicitly.

---

# Test Documentation

For major refactors, document:

## Added Tests
- what behavior is protected

## Changed Tests
- why updates were necessary

## Remaining Risks
- uncovered paths
- ambiguous behavior
- technical debt left intentionally

---

# Final Goal

The test suite should provide:

- confidence to refactor safely
- fast developer feedback
- reliable regression detection
- clear behavioral documentation

Tests should support maintainability, not become a maintenance burden.
