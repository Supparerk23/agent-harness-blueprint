# Review checklist

## Correctness
- [ ] Behavior matches stated goal / ticket
- [ ] Edge cases and failure paths handled
- [ ] No accidental breaking API or schema changes

## Security
- [ ] No secrets committed or logged
- [ ] AuthZ/AuthN boundaries preserved
- [ ] Input validation at trust boundaries

## Reliability & performance
- [ ] No blocking work on request hot paths (where applicable)
- [ ] Retries/idempotency considered for async flows
- [ ] Obvious N+1 or unbounded loops avoided

## Maintainability
- [ ] Changes are minimal and consistent with local conventions
- [ ] Docs/README updated when public surface changes
- [ ] Tests cover the changed behavior (or explicitly deferred with reason)

## Process
- [ ] PLANNING / DECISIONS / RUN_LOG updated if this repo uses the memory harness
- [ ] Branch / PR target matches team policy
