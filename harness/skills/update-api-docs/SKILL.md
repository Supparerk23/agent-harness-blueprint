---
name: update-api-docs
description: >-
  Sync the OpenAPI YAML documentation file and response examples with the
  current FastAPI router endpoints. Use when adding, removing, or modifying API
  endpoints in app/routers/, when the user says to update the API docs, update
  openapi.yaml, refresh the swagger spec, re-export from FastAPI, or add/update
  response examples.
---

# Update API Docs

Keeps `docs/api/openapi.yaml` (the OpenAPI spec exported from FastAPI) accurate with the live router code in `app/routers/`.

## Two ways to update

### Option A — Re-export directly from the app (preferred, no server needed)

```bash
uv run python -c "
import yaml
from app.main import app
spec = app.openapi()
with open('docs/api/openapi.yaml', 'w') as f:
    yaml.dump(spec, f, allow_unicode=True, sort_keys=False, default_flow_style=False)
"
```

Or, if the local dev server is already running:

```bash
curl -s http://localhost:8000/openapi.json | \
  uv run python -c "
import sys, json, yaml
spec = json.load(sys.stdin)
print(yaml.dump(spec, allow_unicode=True, sort_keys=False))
" > docs/api/openapi.yaml
```

Then verify the file looks correct:
```bash
head -20 docs/api/openapi.yaml
```

### Option B — Manual edit (server not available)

Edit `docs/api/openapi.yaml` directly to reflect the router changes. Follow the existing structure.

## Manual edit workflow

1. **Read the changed router file** to understand the new/modified endpoint.
2. **Find the matching path block** in `docs/api/openapi.yaml` (search by path string).
3. **Apply the change** using one of these patterns:

**New endpoint** — add a new path entry under `paths:` in `docs/api/openapi.yaml`:
```yaml
paths:
  /private/api/v1/your/path:
    post:
      tags:
        - 'YourTag'
      summary: 'Short summary'
      description: 'Longer description of what this endpoint does.'
      operationId: 'generated_operation_id'
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/YourRequestModel'
        required: true
      responses:
        '200':
          description: 'Successful Response'
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/YourResponseModel'
        '422':
          description: 'Validation Error'
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
```

**Modified endpoint** — update only the fields that changed (summary, description, request/response schema refs, path parameters).

**Deleted endpoint** — remove the entire path block from `paths:`.

**Schema change** — add or update the matching entry under `components/schemas/`.

## What to keep in sync

| Router change | YAML change |
|---|---|
| New route decorator | New path block in `paths:` |
| Deleted route | Remove path block |
| Path/prefix change | Rename the path key |
| Request model change | Update `requestBody` schema ref + `components/schemas/` |
| Response model change | Update `responses` schema ref + `components/schemas/` |
| `summary=` / `description=` on route | Update `summary` / `description` in path block |
| New path parameter | Add to `parameters:` list in path block |

## Conventions from this project

- Path prefixes: `/private/api/v1/` or `/public/api/v1/` (see `app/constants.py`).
- Tags map to router files: `OCR`, `Health Check`, `Reports`, `Advisors`, `Management`, `Tasks`, `Results`.
- `operationId` follows FastAPI's auto-generated pattern: `{function_name}_{full_path_underscored}_{method}`.
- Keep `servers:` block intact (localhost + staging URLs).
- Preserve `externalValue` example references under `responses` if they exist.

## Response examples

Real response examples are stored as individual JSON files under `docs/api/example/90-ai-wealth-health-check/`, organized by tag:

```
docs/api/example/
  90-ai-wealth-health-check/
    ocr/           → OCR endpoints
    health-check/  → Health Check endpoints
    reports/       → Reports endpoints
    advisors/      → Advisors endpoints
    management/    → Management endpoints
    tasks/         → Tasks endpoints
    results/       → Results endpoints
    misc/          → Root / health probe endpoints
    requests/      → Requests endpoints
```

### Naming convention

Use the last segment(s) of the endpoint path, hyphenated:

| Endpoint | Example file |
|---|---|
| `POST /private/api/v1/ocr/portfolio-stock-ocr-image` | `90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image.json` |
| `POST /private/api/v1/reports/generate` | `90-ai-wealth-health-check/reports/generate.json` |
| `GET /private/api/v1/health-check/{report_id}` | `90-ai-wealth-health-check/health-check/get-by-report-id.json` |

If two endpoints in the same tag share a slug (different HTTP methods), append the method: `generate-post.json`.

### File format — success responses

Each success file contains a single realistic `200` response body. The service wraps all responses in a standard envelope:

```json
{
  "status": true,
  "service_code": "90",
  "message": "Success",
  "data": { ... }
}
```

- Use realistic but anonymized values — not placeholder strings like `"string"` or `null`.
- Match the exact shape of the Pydantic response model for that endpoint.

### File format — error responses

**Every endpoint MUST have example files for every possible error it can return.**

Error example files use the naming convention `<endpoint-slug>-<status-code>.json` and live alongside the success file in the same tag folder.

Error files follow the standard `ErrorResponse` envelope:

```json
{
  "status": false,
  "service_code": "90",
  "error_code": "17",
  "error_message": "Descriptive error message matching what the router actually returns"
}
```

- `error_code` is the application code (string `"00"`–`"99"`) from `docs/api/ERROR_MESSAGES.md`, not the HTTP status.
- Filename suffix uses the HTTP status (e.g. `-400.json`).

Common HTTP statuses to cover (check the router source for each endpoint):

| HTTP | When to add |
|---|---|
| `400` | Missing/invalid query params, bad input data |
| `404` | Resource not found (request, report, task, etc.) |
| `409` | Conflict (already processed, duplicate) |
| `413` | Too many files uploaded |
| `415` | File type or size invalid |
| `422` | Business-logic 422 (e.g. no data extracted from image) |
| `429` | Rate limit exceeded |
| `500` | Unexpected internal error, external service failure |

#### Example — OCR endpoint errors

`docs/api/example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image-400.json`:
```json
{
  "status": false,
  "service_code": "90",
  "error_code": "19",
  "error_message": "At least one file is required"
}
```

`docs/api/example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image-422.json`:
```json
{
  "status": false,
  "service_code": "90",
  "error_code": "12",
  "error_message": "No stock information found in the uploaded images."
}
```

### Linking examples to openapi.yaml

**Success response** — add under `'200'`:

```yaml
responses:
  '200':
    description: Successful Response
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/YourResponseModel'
        examples:
          success:
            externalValue: example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image.json
```

**Error responses** — add a block per error code, referencing `ErrorResponse` schema:

```yaml
  '400':
    description: Bad Request
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/ErrorResponse'
        examples:
          error_400:
            externalValue: example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image-400.json
  '413':
    description: Payload Too Large
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/ErrorResponse'
        examples:
          error_413:
            externalValue: example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image-413.json
  '422':
    description: Validation Error
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/HTTPValidationError'
        examples:
          error_422_business:
            summary: Business-level 422 – no data extracted
            externalValue: example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image-422.json
  '500':
    description: Internal Server Error
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/ErrorResponse'
        examples:
          error_500:
            externalValue: example/90-ai-wealth-health-check/ocr/portfolio-stock-ocr-image-500.json
```

The `externalValue` path is **relative to `docs/api/`** (where `openapi.yaml` lives).

> **Note on 422**: FastAPI auto-generates a `'422'` block for Pydantic request validation failures (`HTTPValidationError`). If the endpoint also has a *business-level* 422 (e.g. "no data extracted"), add it as an additional named example (`error_422_business`) inside the existing `'422'` block rather than replacing it.

### When to update examples

| Change | Required action |
|---|---|
| Response model field added | Add the field to the matching success example file |
| Response model field removed | Remove the field from the matching success example file |
| New error path added to router | Create `<slug>-<code>.json` error file and add response block in `openapi.yaml` |
| Error message changed | Update the `error_message` in the matching error example file |
| New endpoint added | Create success file + all error files; add all response blocks in `openapi.yaml` |
| Endpoint deleted | Delete all example files (success + errors); remove all response blocks from `openapi.yaml` |

See `docs/api/example/README.md` and `docs/api/example/90-ai-wealth-health-check/` for the full reference.

## After updating

- Run `app/routers/README.md` check — the router-endpoint-readme-sync rule also requires README to be updated.
- Confirm path count in `paths:` matches the number of routes across all routers.
- The canonical API doc lives at `docs/api/openapi.yaml`. Do not commit to the legacy `example.yaml` at the project root.
