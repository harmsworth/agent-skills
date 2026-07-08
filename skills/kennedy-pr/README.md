# Kennedy PR

Service Diffguard PR review workflow from the Ardan Labs `service` project.

## What is this?

This skill reviews a diff through focused lenses for correctness, error visibility, documentation truthfulness, test coverage, type and contract boundaries, and simplification.

It is read-only by design: it reports findings and suggested patch directions, but does not edit files.

## Command

```text
/kennedy-pr
```

## Installation

```bash
npx skills add harmsworth/agent-skills -g --skill kennedy-pr
```

Or copy manually:

```bash
cp -r skills/kennedy-pr ~/.agents/skills/
```

## How to Use

Use it for PR review, pre-commit review, unstaged diffs, branch ranges, or targeted review:

- "/kennedy-pr review this diff"
- "/kennedy-pr review unstaged changes"
- "/kennedy-pr run a boundary-focused review"
- "/kennedy-pr review branch main...HEAD"

## Review Lenses

| Lens | Focus |
|------|-------|
| Service Steward | General correctness and repo conventions |
| Error Tripwire | Failure-path visibility and error handling |
| Doc Drift Check | Comment and documentation truthfulness |
| Harness Map | Behavior-to-test coverage |
| Boundary Keeper | Type and contract boundaries |
| Straight-Line Pass | Behavior-preserving simplification |

## Gate Scale

| Gate | Meaning |
|------|---------|
| G4 | Stop: likely correctness, security, data-integrity, compile, or reliability failure |
| G3 | Repair: likely user-visible bug, operational blind spot, or real test gap |
| G2 | Tighten: avoidable risk, ambiguity, weak design, or brittleness |
| G1 | Polish: low-risk clarity or naming improvement |
| G0 | Clear: no issue found |

## Source

Copied from `service/.agents/skills/review-pr` and renamed to `kennedy-pr`.
