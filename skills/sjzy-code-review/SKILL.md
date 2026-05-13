---
name: sjzy-code-review
description: "AI code review scoring system for Vue 3 / TypeScript frontend and NestJS backend. Reviews code diffs against comprehensive scoring rubric: public rules + frontend rules + NestJS backend rules. Output must be legal JSON with score, deductions array. Triggers: code review, review code, 代码审查, 评审代码, 代码评审, check code quality, review diff, review PR"
user_invocable: true
version: "1.0.0"
---

# SJZY Code Review

AI-powered code review scoring system for Vue 3 / TypeScript frontend and NestJS backend projects.

## When to Use

Invoke this skill when:
- The user asks to "review code", "code review", "score code", or "check code quality"
- The user mentions "代码审查", "评审代码", "代码评审"
- The user submits a code diff, PR, or file for review
- The user wants to evaluate Vue 3 / TypeScript / NestJS code quality

## How It Works

1. **Input**: User provides code (git diff, file path, or pasted code)
2. **File Type Detection**: Determine if each file is frontend (Vue/TSX/frontend hooks/utils) or backend (NestJS controller/service/module/dto/entity/etc.)
3. **Rule Selection**:
   - All files: public rules (correctness, stability, type contracts)
   - Frontend files: public rules + frontend rules
   - Backend files: public rules + NestJS backend rules
4. **Scoring**: Start from 100, deduct points for each violation with evidence
5. **Output**: Structured JSON report with score, deductions, and suggestions

## Scoring System

### Score Calculation

- **Initial score**: 100 points per review fragment
- **Deduction levels**:
  - `blocker`: 20-35 points. Causes production failure, data errors, core flow broken, compile failure, or startup failure.
  - `major`: 8-15 points. Clear business logic defect, missing exception branch, type safety risk, performance or concurrency risk.
  - `minor`: 2-5 points. Convention, readability, maintainability issue.
  - `suggestion`: 0 points. Better way exists but insufficient evidence to classify as defect.
- **Final score**: 100 - total deductions. Min 0, max 100.
- **Same root cause**: Deduct every occurrence.

### Non-Deductible Items

- Do NOT deduct for contributor name, commit count, file count, line count, or commit message style.
- Do NOT deduct for auto-generated code, openapi/opengrpc artifacts, lock files, or pure documentation changes.
- Do NOT deduct backend security issues (permission, auth, SQL injection, XSS, SSRF) — report as suggestion only (points = 0).
- Do NOT deduct for historical legacy code itself (only deduct if the current change expands or depends on the historical issue).

## Review Process

When reviewing code:

1. **Read the code** — understand what it does and its context
2. **Detect file types** — for each file, determine frontend or backend
3. **Apply public rules first** — check all files for correctness, stability, type contract issues
4. **Apply frontend rules** — only for Vue/TSX/frontend business/hooks/API/state management/utility files
5. **Apply backend rules** — only for NestJS controller/service/module/dto/entity/guard/interceptor/pipe/provider/repository/backend utility files
6. **Score each issue** — assign severity and points based on impact
7. **Output JSON** — follow the exact JSON schema defined in the review prompt

## Special Notes

- **Scope restriction**: Only review changes shown in the current diff. Context lines are for understanding only.
- **File-by-file rules**: When a diff contains both frontend and backend files, apply rules per file individually. Never use frontend rules to penalize backend code.
- **No import checking for frontend**: Do NOT report missing imports for frontend symbols (useXXX, ref, computed, watch, etc.). Only deduct for non-import-related correctness issues.
- **Evidence required**: Every deduction must have clear evidence from the diff. Do NOT downgrade major/minor issues to suggestion.

## Prompt Reference

Detailed review rules and JSON output schema: `prompts/review-prompt.md`
