# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a multi-skill repository for Claude Code. Each skill is a self-contained directory under `skills/` that can be installed with the `skills` CLI or copied to a local skills directory to extend Claude Code's capabilities.

## Repository Structure

```
agent-skills/
├── .claude-plugin/       # Plugin discovery metadata
│   ├── plugin.json         # Skill registry configuration
│   └── marketplace.json    # Marketplace listing metadata
├── skills/               # All skills live here
│   ├── droid-skill/        # Droid Mission Framework
│   │   ├── SKILL.md          # Main system prompt (entry point)
│   │   ├── index.json        # Skill metadata
│   │   ├── README.md         # Usage guide
│   │   ├── README.zh-CN.md   # Chinese usage guide
│   │   ├── prompts/          # Role-specific prompt files
│   │   └── examples/         # Usage examples
│   ├── auto-editor/        # AI-powered video editor
│   │   ├── SKILL.md          # Main skill definition (entry point)
│   │   ├── index.json        # Skill metadata
│   │   ├── README.md         # Usage guide
│   │   ├── prompts/          # AI analysis prompts
│   │   ├── scripts/          # Shell/Node automation scripts
│   │   ├── references/       # Workflow reference docs
│   │   └── config/           # Configuration templates
│   ├── frontend-code-review/ # Vue/TS/JS review scoring
│   ├── sjzy-code-review/     # Vue/TS + NestJS review scoring
│   ├── kennedy-if/           # Go branching logic conventions
│   ├── kennedy-ext/          # Business extension/decorator pattern
│   ├── kennedy-arch/         # Layered architecture type boundaries
│   ├── kennedy-pr/           # Service Diffguard PR review workflow
│   └── kennedy-go/           # Modern Go syntax guidelines
├── README.md             # Project-level overview and installation
├── README.zh-CN.md       # Chinese overview
└── .gitignore            # Ignore rules
```

## Skill Format

Each `SKILL.md` follows this structure:

```yaml
---
name: skill-name
description: "What this skill does. Triggers: keyword1, keyword2..."
user_invocable: true
version: "x.x.x"
---

# Skill content in markdown...
```

## Skill Inventory

| Skill | Purpose | External Dependencies |
|-------|---------|----------------------|
| `droid-skill` | Multi-agent software development framework (planning, workers, validation) | None |
| `auto-editor` | Talking-head video auto-editing pipeline (cut, subtitle, HD export) | FFmpeg, Node.js, cloud ASR API |
| `frontend-code-review` | Vue 3 / TypeScript / JavaScript code review scoring | None |
| `sjzy-code-review` | Vue 3 / TypeScript frontend and NestJS backend review scoring | None |
| `kennedy-if` | Go branching logic rules from the Ardan Labs service project; command `/kennedy-if` | None |
| `kennedy-ext` | Business-layer extension/decorator pattern; command `/kennedy-ext` | None |
| `kennedy-arch` | App / Business / Storage type-boundary rules; command `/kennedy-arch` | None |
| `kennedy-pr` | Service Diffguard PR review lenses; command `/kennedy-pr` | None |
| `kennedy-go` | Modern Go syntax guidance by project Go version; command `/kennedy-go` | None |

## Commands

### Install Skills

```bash
# Install all skills globally
npx skills add harmsworth/agent-skills -g --all

# Install a single skill
npx skills add harmsworth/agent-skills -g --skill droid-skill
npx skills add harmsworth/agent-skills -g --skill auto-editor
npx skills add harmsworth/agent-skills -g --skill frontend-code-review
npx skills add harmsworth/agent-skills -g --skill sjzy-code-review
npx skills add harmsworth/agent-skills -g --skill kennedy-if
npx skills add harmsworth/agent-skills -g --skill kennedy-ext
npx skills add harmsworth/agent-skills -g --skill kennedy-arch
npx skills add harmsworth/agent-skills -g --skill kennedy-pr
npx skills add harmsworth/agent-skills -g --skill kennedy-go

# List available skills
npx skills add harmsworth/agent-skills -l
```

### Auto-Editor Quick Start

```bash
# Check environment
bash ~/.claude/skills/auto-editor/scripts/install.sh

# Configure ASR API Key
cp ~/.claude/skills/auto-editor/config/.env.example ~/.claude/skills/auto-editor/config/.env
# Edit ~/.claude/skills/auto-editor/config/.env and add your ASR_API_KEY

# Usage
/auto-editor cut video.mp4
/auto-editor subtitle video.mp4
/auto-editor export-hd video.mp4
```

### Kennedy Skills Quick Start

```text
/kennedy-if
/kennedy-ext
/kennedy-arch
/kennedy-pr
/kennedy-go
```

## Development Guidelines

- Skills are atomic units — each skill directory is self-contained
- Version numbers are manually maintained in `SKILL.md` frontmatter and `index.json`
- `index.json` must accurately list all files the skill depends on
- Reference documents go in `references/`, reusable scripts go in `scripts/`
- When modifying skill logic, update both `SKILL.md` and any referenced files

## Testing Changes

After modifying a skill:
1. Copy to `~/.claude/skills/`
2. Restart Claude Code to reload skills
3. Test via natural language trigger or `/skill-name`
