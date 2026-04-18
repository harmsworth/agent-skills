# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a multi-skill repository for Claude Code. Each skill is a self-contained directory under `skills/` that can be installed to `~/.claude/skills/` to extend Claude Code's capabilities.

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
│   └── auto-editor/        # AI-powered video editor
│       ├── SKILL.md          # Main skill definition (entry point)
│       ├── index.json        # Skill metadata
│       ├── README.md         # Usage guide
│       ├── prompts/          # AI analysis prompts
│       ├── scripts/          # Shell/Node automation scripts
│       ├── references/       # Workflow reference docs
│       └── config/           # Configuration templates
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

## Commands

### Install Skills

```bash
# Install all skills globally
npx skills add harmsworth/agent-skills -g --all

# Install a single skill
npx skills add harmsworth/agent-skills -g --skill droid-skill
npx skills add harmsworth/agent-skills -g --skill auto-editor

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
