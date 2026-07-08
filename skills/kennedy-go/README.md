# Kennedy Go

Modern Go syntax guidelines from the Ardan Labs `service` project.

## What is this?

This skill tells the agent how to apply modern Go syntax based on the target repository's Go version. It favors standard library helpers and language features that are available for the detected version.

## Command

```text
/kennedy-go
```

## Installation

```bash
npx skills add harmsworth/agent-skills -g --skill kennedy-go
```

Or copy manually:

```bash
cp -r skills/kennedy-go ~/.agents/skills/
```

## How to Use

Use it whenever writing, editing, modernizing, or reviewing Go code:

- "/kennedy-go update this package to modern Go style"
- "/kennedy-go review this Go diff"
- "/kennedy-go apply modern Go syntax here"

## Key Rules

- Use features only up to the target repository's Go version.
- Prefer modern standard library helpers such as `slices`, `maps`, `cmp`, `strings.Cut`, and `errors.Is`.
- Prefer `any` over `interface{}` when the target Go version supports it.
- Use `go fix` first when the installed toolchain and target package make that appropriate.
- Avoid outdated patterns when a supported modern alternative is clearer.

## Source

Copied from `service/.agents/skills/use-modern-go` and renamed to `kennedy-go`.
