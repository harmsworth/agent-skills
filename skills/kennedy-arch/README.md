# Kennedy Arch

Layered architecture type-boundary rules from the Ardan Labs `service` project.

## What is this?

This skill enforces the App / Business / Storage type boundaries used in the service architecture:

- API edges use primitive request and response types.
- Business models use strong domain types.
- Storage rows use native database-friendly types.
- Every boundary crossing uses a named converter.

## Command

```text
/kennedy-arch
```

## Installation

```bash
npx skills add harmsworth/agent-skills -g --skill kennedy-arch
```

Or copy manually:

```bash
cp -r skills/kennedy-arch ~/.agents/skills/
```

## How to Use

Use it when editing or reviewing files under `app/*`, `business/domain/*`, or `.../stores/*db`:

- "/kennedy-arch review this user domain change"
- "/kennedy-arch check these request and response types"
- "/kennedy-arch verify the storage converters"

## Boundary Model

| Layer | Type shape | Converter examples |
|-------|------------|--------------------|
| App | Primitive API structs | `toBus<Type>`, `fromBus<Type>Response` |
| Business | Strong domain types | Domain constructors and validation |
| Storage | Native DB row structs | `toDB<Type>`, `toBus<Type>` |

## Key Rules

- Do not expose `business/types/*` strong types in API request or response structs.
- Do not store `business/types/*` strong types directly in DB row structs.
- Do not assign across layer boundaries without a named converter.
- Do not import sideways across Business domains or App domains.
- Confirm concrete type choices before finalizing boundary changes.

## Source

Copied from `service/.agents/skills/layered-architecture-types` and renamed to `kennedy-arch`.
