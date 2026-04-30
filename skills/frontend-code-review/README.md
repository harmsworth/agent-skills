# Frontend Code Review

AI-powered code review scoring system for Vue 3 / TypeScript / JavaScript projects.

## What is this?

This skill provides a structured, 5-dimension code review framework that scores frontend code from P0 (excellent) to P3 (unqualified). It covers naming conventions, comments, Vue 3 TypeScript standards, Vue 3 development conventions, and JavaScript logic quality.

## Installation

### Option 1: Global skills directory (recommended for Claude Code)

```bash
cp -r frontend-code-review ~/.claude/skills/
```

Restart Claude Code. The skill will be loaded automatically.

### Option 2: Project-local usage

Drop the `frontend-code-review/` folder into your project repo, then reference it:

> "Use the instructions in `frontend-code-review/SKILL.md` to review this code."

## How to Use

Just ask naturally:

### Review code files
- "Review this Vue component for me"
- "Score this code submission"
- "检查这段代码的质量"
- "帮我评审这个 PR 的代码"

### Review a diff
- "Review this git diff"
- "Check this PR for code quality issues"

### Targeted review
- "Check if this code follows our naming conventions"
- "Are there any TypeScript type issues in this file?"

## Review Dimensions

| Dimension | Weight | Focus |
|-----------|--------|-------|
| Naming Convention | 10% | Component names, variable/function names, constants |
| Comments Convention | 10% | JSDoc, logic markers, TODO/FIXME/BUG tags |
| Vue 3 TypeScript Standards | 20% | Type coverage, ref annotations, defineProps/defineEmits/defineModel |
| Vue 3 Development Standards | 25% | v-for keys, code organization order, scoped styles, shallowRef |
| JS Development Standards | 35% | Cyclomatic complexity, functional programming, logic completeness |

## Scoring Grades

| Score | Grade | Description |
|-------|-------|-------------|
| 90-100 | P0 (卓越) | Fully compliant, robust logic |
| 75-89 | P1 (良好) | Minor naming or comment issues |
| 60-74 | P2 (合格) | Moderate deviations, fix required |
| <60 | P3 (不合格) | Serious logic defects or critical violations |

## Key Rules (Quick Reference)

### Naming
- Components: multi-word only (`<TodoItem />`, NOT `<Item />`)
- Single event: `handleClick`. Multiple events: `handleXXClick` (e.g. `handleSubmitClick`)
- Modals: `XXModal`. Drawers: `XXDrawer`
- No single-letter variables. No magic numbers in logic.

### Comments
- TS variables/methods: `/** xxx */` JSDoc style
- Complex logic: step-by-step `//` comments
- Standard tags: `// TODO`, `// FIXME`, `// BUG`

### Vue 3 + TS
- Prefer `ref<string>('')`. Banned: `ref: string = ref('')`
- Use `defineProps<IProps>()`, `defineModel` for two-way binding
- `provide`/`inject` with `InjectionKey`

### Vue 3 Development
- `v-for` MUST have `:key`, NEVER use `index`
- Setup order: defineOptions > props/emits > variables > computed > methods > watch > lifecycle > init
- MUST use `scoped`. No element selectors (`div { ... }`)
- Large/deep data: use `shallowRef` or `shallowReactive`

### JS Logic
- Single function cyclomatic complexity ≤ 20
- `switch` MUST have `default`. `if` MUST have `else` unless explicit `return`
- NEVER mutate state or side effects in `computed`
- Prefer functional programming (`map`, `filter`) over imperative loops

## Example Output

```markdown
# Code Review Report

## Summary
- Files reviewed: 3
- Total score: 82 / 100
- Grade: P1
- Verdict: Good overall, minor naming and comment issues to fix.

## Score Breakdown

### 1. Naming Convention (权重 10%): 75 / 100
| Rule | Status | Issues |
|------|--------|--------|
| Component naming | ✅ | All good |
| Variable / Function naming | ⚠️ | `handleClick` used when 3 click handlers exist → use `handleSubmitClick`, `handleCancelClick`, `handleResetClick` |
| Constants | ✅ | No magic numbers |

**Subtotal:** 7.5 / 10

### 5. JS Development Standards (权重 35%): 85 / 100
| Rule | Status | Issues |
|------|--------|--------|
| Complexity control | ✅ | Max complexity 12 |
| Programming paradigm | ⚠️ | `for` loop at line 45 could use `filter` |
| Logic completeness | ❌ | `switch` at line 78 missing `default` |
| Logic decomposition | ✅ | No unnecessary watch usage |
| Naming semantics | ⚠️ | `Modal` component named `Dialog` → rename to `ConfirmModal` |

**Subtotal:** 29.8 / 35

## Total Score
**82 / 100 → Grade: P1**

## Action Items
1. [P2] Rename `handleClick` to semantic names (3 handlers)
2. [P2] Add `default` to switch statement at line 78
3. [P1] Replace for loop with `filter` at line 45
4. [P1] Rename `Dialog` component to `ConfirmModal`
```
