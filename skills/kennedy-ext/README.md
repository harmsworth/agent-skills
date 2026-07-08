# Kennedy Ext

Business-layer extension guidelines from the Ardan Labs `service` project.

## What is this?

This skill documents the `ExtBusiness` / `Extension` decorator pattern used to add cross-cutting concerns without modifying the core business implementation.

Use it for tracing, logging, metrics, caching, authorization, and similar concerns.

## Command

```text
/kennedy-ext
```

## Installation

```bash
npx skills add harmsworth/agent-skills -g --skill kennedy-ext
```

Or copy manually:

```bash
cp -r skills/kennedy-ext ~/.agents/skills/
```

## How to Use

Use it before adding or reviewing business-layer extensions:

- "/kennedy-ext add OTEL to this business domain"
- "/kennedy-ext review this extension wiring"
- "/kennedy-ext check whether this concern should wrap Business"

## Pattern Summary

1. Define the seam in the `*bus` package with `ExtBusiness` and `Extension`.
2. Implement the extension under `business/domain/*/extensions/*`.
3. Wrap the relevant methods and pass every other method straight through.
4. Wire extensions in the service startup code in the intended order.

## Key Rules

- Wrap the core `Business`; do not modify it for cross-cutting concerns.
- Implement every method required by `ExtBusiness`.
- Keep extension packages focused on one concern.
- Use `kennedy-arch` for layer boundary questions and `kennedy-go` for Go syntax.

## Source

Copied from `service/.agents/skills/business-layer-extensions` and renamed to `kennedy-ext`.
