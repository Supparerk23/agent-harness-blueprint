---
name: generate-test-cases
description: >-
  Generate a Testiny-importable CSV of QA test cases for a software change.
  Use when the user explicitly asks to generate test cases, Testiny CSV,
  QA test suite, or /generate-test-cases. Manual / opt-in only — do not
  auto-invoke for ordinary coding, refactor, or unit-test work.
disable-model-invocation: true
---

# Generate Test Cases

Act as a Senior QA Engineer. Understand the change thoroughly, inspect implementation and project knowledge, think through meaningful risk, and produce a Testiny-ready CSV suite that gives the team confidence to release.

Do not merely mirror the implementation or dump trivial duplicates. Prefer quality over quantity.

## Constraints

- Never modify source code, project documentation, existing tests, or any user-supplied template file.
- Only create the requested CSV output.
- Prefer read-only repository inspection; avoid unnecessary full-repo scans.
- Do not fabricate requirements, acceptance criteria, business rules, or a JIRA identifier.
- Never invent a different CSV schema than the one documented here (or a user-supplied template header).

## Manual workflow

Execute only when the user explicitly requests this skill. Do not generate the CSV until the change, JIRA id, and output directory are resolved.

### 1. Resolve the change

Determine what to analyze. Sources may include a JIRA ticket, branch, commit, pull request, feature description, or existing `PLANNING.md`.

If scope is unclear, ask the user before continuing.

### 2. Resolve the JIRA ticket

Obtain a real ticket identifier (examples: `FIN-123`, `CORE-18`, `APP-901`). It is required for the output filename.

If it cannot be determined from context, ask. Never invent a JIRA id.

### 3. Confirm output directory

Always ask where to save the CSV. Suggest `~/Downloads/` as the default.

Do **not** expand `~` into an absolute path (username varies by machine). Accept paths such as:

- `~/Downloads/`
- `~/Desktop/`
- `./tests/testcases/`
- `./docs/testcases/`

Do not generate until the user confirms the location.

### 4. Resolve CSV schema

Default: use the **canonical schema** in this skill (exact header and column rules below).

If the user supplies a different Testiny CSV template path, read that file and use **its** header order instead. If the template cannot be found or read, stop and ask — do not invent columns.

### 5. Analyze the repository

Read project knowledge (priority below), then inspect only the implementation relevant to the change (code, APIs, config, schemas, migrations, existing tests, contracts).

### 6. Generate and review test cases

Design a comprehensive suite, then perform a mandatory coverage self-review. Fill important gaps before exporting.

### 7. Export CSV

Write UTF-8 CSV to:

`<output-directory>/testcases-<JIRA>.csv`

Example: `~/Downloads/testcases-FIN-123.csv`

## Repository knowledge sources

Read these when available, in order:

1. **PLANNING.md** — goals, scope, acceptance criteria, tasks, business requirements (primary source of truth)
2. **DECISIONS.md** — design rationale and trade-offs
3. **ARCHITECTURE.md** — components, data flow, integration points (read only; do not modify)
4. **ANTI-PATTERNS.md** — high-confidence bans; add regression coverage when relevant
5. **LEARNING.md** — prior defects and lessons; strengthen regression coverage
6. **HOTCACHE.md** — short-lived operational context for in-progress work
7. **RUN_LOG.md** — supporting telemetry only; never treat as requirements

If `PLANNING.md` is missing, search other change docs and the implementation. Continue only with sufficient context, and report that `PLANNING.md` was unavailable.

## Understanding the change

Determine current vs new / changed / removed behavior; impacted users and systems; integration points; dependencies; data flow; business rules; acceptance criteria.

Do not assume unverified implementation details.

## Test design

For every requirement ask: what should work, what should fail, edges and boundaries, regression risk, dependency failure, existing data, repeated actions, and production breakage modes.

Generate meaningful scenarios across these categories when applicable:

- **Functional** — happy paths, workflows, valid UI/API usage
- **Negative** — invalid/missing input, invalid state, permissions, dependency failures
- **Boundary** — min/max, empty, null, zero, limits, large payloads, date/time edges
- **Validation** — required fields, formats, length, type, business and cross-field rules
- **Error handling** — expected errors, messages/codes, retry, timeout, partial failure
- **Integration** — DB, queue, events, storage, APIs, authn/authz, external services
- **Regression** — adjacent existing behavior at risk
- **Data** — CRUD, duplicates, migrations, persistence, idempotency
- **Security** — authn/authz, sensitive data, privilege escalation, injection, access control
- **Reliability** — retries, duplicates, concurrency, races, event ordering/duplication
- **Compatibility** — existing clients, APIs, config, data, backward compatibility

Inspect existing automated tests to learn behavior and gaps. Do not simply duplicate them.

### Coverage review (mandatory)

Before export, ensure every important requirement, acceptance criterion, business rule, and implementation change has at least one corresponding case. Review functional, negative, boundary, validation, integration, regression, security, and reliability coverage. Add cases for gaps.

## Canonical Testiny CSV schema

Use this exact header (column names and order). Do not add, rename, or reorder columns unless the user supplied a different template file.

```text
Folder,Component,Platform,Features,Sub-Features,TC#,Summary,Test Data,Pre-condition,Test Steps,Expected Result,Jira,Sprint,Regression,Priority,Automation status,Active?,Test Result,Test By,Test Date,Remark
```

### Column fill rules

| Column | Guidance |
|---|---|
| Folder | Hierarchical path; nest with ` > ` (example shape: `folder > sub folder1 > sub folder2`) |
| Component | Component under test when known; else empty |
| Platform | Project-known platform values only (multi-select style). Do not invent platforms |
| Features | Feature name for the change |
| Sub-Features | Finer slice when useful; else empty |
| TC# | Prefer leave empty for import (Testiny does not store this as a durable id). Do not invent fake ids |
| Summary | Clear, unique case title |
| Test Data | Inputs/fixtures needed; multiline OK |
| Pre-condition | Setup state required before steps |
| Test Steps | Numbered multiline steps (`1. …` then newline `2. …`). Quote the field so newlines survive |
| Expected Result | Numbered multiline outcomes aligned with steps. Quote for newlines |
| Jira | Resolved ticket id (e.g. `FIN-123`). Never invent |
| Sprint | Period string when known (example shape: `2026-11`); ask or leave empty if unknown |
| Regression | Use project convention; example value `Yes` when the case is regression-relevant |
| Priority | Prefer labels already used in the project (example shape: `Critical`) |
| Automation status | Multi-select style; default `Manual` when unknown |
| Active? | Boolean; use `TRUE` for new active cases |
| Test Result | Leave empty for newly generated suites unless the user asks to fill execution results |
| Test By | Leave empty unless the user asks |
| Test Date | Leave empty unless the user asks |
| Remark | Optional notes; leave empty when none |

### Custom field types (value guidance)

These types describe how Testiny treats related fields. They guide **values**, not extra columns. Do not invent columns that are absent from the header.

| Field | Type | Notes |
|---|---|---|
| Automation status | Multi-Select | |
| Remark | Multi-Line Text | |
| Priority | Number (integer) in Testiny config; import examples often use text labels like `Critical` — prefer values the project already uses |
| Type | Text | Not a separate import column in the canonical header; omit unless present in a user-supplied template |
| Sprint | Text | |
| Jira | Text | |
| Platform | Multi-Select | Use only known platform values |
| Test Data | Multi-Line Text | |
| Section | Text | Not a separate import column in the canonical header |
| Sub-Features | Text | |
| Regression | Multi-Select | |
| Active | Boolean | Import column name is `Active?` |

### CSV encoding

- UTF-8
- Proper CSV escaping; quote fields that contain commas, quotes, or line breaks
- Preserve commas and multiline content inside quoted fields
- No Markdown, no code fences inside the CSV file
- The file must be directly importable into Testiny without manual cleanup

Treat any example row the user or a template file shows as **formatting only**, not as required content.

## Final response

After a successful write, report only:

- Saved file path
- Jira ticket
- Number of generated test cases
- Coverage summary
- Important assumptions
- Limitations (including missing `PLANNING.md` if applicable)

Do **not** print all generated test cases in chat. The CSV is the primary deliverable.

If the output directory cannot be written, report the failure and do not claim success.
