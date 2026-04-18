# harmsworth/agent-skills

[![English](https://img.shields.io/badge/lang-English-blue.svg)](README.md)
[![简体中文](https://img.shields.io/badge/lang-简体中文-red.svg)](README.zh-CN.md)

A multi-skill repository for Claude Code. Contains tools for multi-agent software development and AI-powered video editing.

## What's inside?

| Skill | Path | Description |
|-------|------|-------------|
| **droid-skill** | [`skills/droid-skill/`](skills/droid-skill/) | The Droid Mission Framework: planning, worker execution, code review, user testing, and worker design. Works with any LLM. |
| **auto-editor** | [`skills/auto-editor/`](skills/auto-editor/) | Talking-head video auto-editor. Detects mistakes, repetitions, silence, and filler words; generates review UI; one-click FFmpeg export. Cross-platform: macOS/Linux/WSL2. |

## Installation

Using the [skills CLI](https://github.com/vercel-labs/skills):

```bash
# Install all skills globally
npx skills add harmsworth/agent-skills -g --all

# Install a single skill
npx skills add harmsworth/agent-skills -g --skill droid-skill
npx skills add harmsworth/agent-skills -g --skill auto-editor

# List available skills without installing
npx skills add harmsworth/agent-skills -l
```

Or manually copy:

```bash
# Copy all skills
cp -r skills/* ~/.agents/skills/

# Or copy a single skill
cp -r skills/droid-skill ~/.agents/skills/
cp -r skills/auto-editor ~/.agents/skills/
```

---

## droid-skill — Droid Mission Framework

Derived from Factory.ai Droid's built-in Mission System, this framework turns any LLM (Claude, Codex, Kimi, Cursor, etc.) into a structured software engineering team with 5 built-in roles:

1. **Orchestrator** — Plans projects into milestones, sets up infrastructure, and writes mission artifacts.
2. **Worker** — Implements features with strict TDD and structured handoffs.
3. **Scrutiny Validator** — Code-reviews completed features and runs tests/lint/typecheck.
4. **User Testing Validator** — Tests real user surfaces (browser, CLI, API) end-to-end.
5. **Worker Designer** — Helps you design new worker types and improve handoff quality.

### Quick usage examples

After the skill is loaded, just talk to the AI naturally:

- **Plan**: "Plan this project using the mission framework."
- **Implement**: "Implement feature `auth-login` from the mission plan."
- **Review**: "Run the scrutiny validator on milestone `auth`."
- **Test**: "Test the login and signup flows end-to-end."
- **Design**: "Design a new DevOps worker type for this project."

See [`skills/droid-skill/README.md`](skills/droid-skill/README.md) for the full usage guide, prompt examples, and Claude Code integration tips.

---

## auto-editor — AI-Powered Talking-Head Video Editor

An FFmpeg-based automated editing pipeline for talking-head videos, combining cloud ASR transcription with AI semantic analysis.

### Quick Start

```bash
# 1. Check/install environment (first time)
bash ~/.agents/skills/auto-editor/scripts/install.sh

# 2. Configure ASR API Key
cp ~/.agents/skills/auto-editor/config/.env.example ~/.agents/skills/auto-editor/config/.env
# Edit ~/.agents/skills/auto-editor/config/.env and add your ASR_API_KEY

# 3. Use via natural language in Claude Code
/auto-editor cut video.mp4
/auto-editor subtitle video.mp4
/auto-editor export-hd video.mp4
```

### Core Workflows

| Workflow | Description |
|----------|-------------|
| **Cut** | Auto-detect mistakes and cut — ASR → AI analysis → review page → FFmpeg cut |
| **Subtitle** | Generate and burn subtitles — ASR with dictionary → proofreading → subtitle burn |
| **Export-HD** | 2-pass encoding with sharpening — detect source params → encode → sharpen |

See [`skills/auto-editor/README.md`](skills/auto-editor/README.md) for full rules, detection logic, troubleshooting, and reference docs.

---

## Repository structure

```
.
├── README.md
├── README.zh-CN.md
├── CLAUDE.md                 # Project-level guidelines for Claude Code
├── .gitignore
├── .claude-plugin/
│   ├── plugin.json           # Skill registry: declares "skills": "./skills"
│   └── marketplace.json      # Marketplace listing metadata
└── skills/
    ├── droid-skill/
    │   ├── SKILL.md              # Main system prompt
    │   ├── index.json            # Skill metadata
    │   ├── README.md             # Detailed usage guide
    │   ├── README.zh-CN.md       # Chinese usage guide
    │   ├── examples/
    │   │   └── frontend-worker.md
    │   └── prompts/
    │       ├── orchestrator.md
    │       ├── worker-base.md
    │       ├── scrutiny-validator.md
    │       ├── user-testing-validator.md
    │       └── worker-design.md
    └── auto-editor/
        ├── SKILL.md              # Main skill definition
        ├── index.json            # Skill metadata
        ├── README.md             # Usage guide
        ├── prompts/
        │   └── analyze_mistakes.md
        ├── references/
        │   ├── cut-workflow.md
        │   ├── hd-export.md
        │   ├── install-guide.md
        │   ├── subtitle-workflow.md
        │   └── user-habits.md
        ├── scripts/
        │   ├── cut_video.sh
        │   ├── generate_review.js
        │   ├── generate_subtitles.js
        │   ├── hd_export.sh
        │   ├── install.sh
        │   ├── review_server.js
        │   ├── subtitle_server.js
        │   └── transcribe.sh
        └── config/
            ├── .env.example
            └── dictionary.txt
```

## Contributing

Feel free to open issues or PRs if you want to add new worker types, new examples, or improve the prompts.

## License

MIT
