# Kennedy If

Go branching logic guidelines from the Ardan Labs `service` project.

## What is this?

This skill helps keep shallow Go branching readable. It prefers default-first assignment and naked `switch` statements over nested `if/else` chains when the logic has 1 to 3 branches.

## Command

```text
/kennedy-if
```

## Installation

```bash
npx skills add harmsworth/agent-skills -g --skill kennedy-if
```

Or copy manually:

```bash
cp -r skills/kennedy-if ~/.agents/skills/
```

## How to Use

Use it when writing or refactoring conditional logic in Go:

- "/kennedy-if refactor this branching logic"
- "/kennedy-if review this function"
- "/kennedy-if simplify these nested conditionals"

## Key Rules

- Start with the default value, then override only for special cases.
- Prefer naked `switch` over `if/else if/else` ladders for shallow branching.
- Use modern Go built-ins like `min` and `max` where they make the code simpler.
- Avoid reshaping complex behavior just to fit this pattern.

## Source

Copied from `service/.agents/skills/branching-logic-flow` and renamed to `kennedy-if`.
