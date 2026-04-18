# harmsworth/agent-skills

[![English](https://img.shields.io/badge/lang-English-blue.svg)](README.md)
[![简体中文](https://img.shields.io/badge/lang-简体中文-red.svg)](README.zh-CN.md)

面向 Claude Code 的多技能仓库。包含多智能体软件开发工具和 AI 视频剪辑工具。

## 包含技能

| 技能 | 路径 | 说明 |
|------|------|------|
| **droid-skill** | [`skills/droid-skill/`](skills/droid-skill/) | Droid 任务框架：项目规划、工作执行、代码审查、用户测试、工作角色设计。兼容任意 LLM。 |
| **auto-editor** | [`skills/auto-editor/`](skills/auto-editor/) | 口播视频智能剪辑。自动识别口误/重复/静音/卡顿，生成审核页面，一键 FFmpeg 剪辑导出。跨平台支持 macOS/Linux/WSL2。 |

## 安装

使用 [skills CLI](https://github.com/vercel-labs/skills) 安装：

```bash
# 全局安装全部技能
npx skills add harmsworth/agent-skills -g --all

# 安装单个技能
npx skills add harmsworth/agent-skills -g --skill droid-skill
npx skills add harmsworth/agent-skills -g --skill auto-editor

# 仅列出可用技能，不安装
npx skills add harmsworth/agent-skills -l
```

或手动复制：

```bash
# 复制全部技能
cp -r skills/* ~/.agents/skills/

# 或复制单个技能
cp -r skills/droid-skill ~/.agents/skills/
cp -r skills/auto-editor ~/.agents/skills/
```

---

## droid-skill — Droid 任务框架

源自 Factory.ai Droid 内置的任务系统，该框架可将任意 LLM（Claude、Codex、Kimi、Cursor 等）转化为结构化的软件开发团队，内置 5 种角色：

1. **Orchestrator（编排器）** — 将项目规划为里程碑，搭建基础设施，编写任务文档。
2. **Worker（工作者）** — 严格执行 TDD，通过结构化的交接报告推进功能实现。
3. **Scrutiny Validator（审查验证器）** — 对已完成功能进行代码审查，运行测试/类型检查/代码规范检查。
4. **User Testing Validator（用户测试验证器）** — 端到端测试真实用户交互面（浏览器、CLI、API）。
5. **Worker Designer（角色设计师）** — 帮助设计新的工作角色类型并优化交接质量。

### 快速使用示例

加载技能后，直接用自然语言与 AI 对话即可：

- **规划**："使用任务框架规划这个项目。"
- **实现**："从任务计划中实现 `auth-login` 功能。"
- **审查**："对里程碑 `auth` 运行审查验证器。"
- **测试**："端到端测试登录和注册流程。"
- **设计**："为这个项目设计一个新的 DevOps 工作角色。"

完整使用指南、提示词示例和 Claude Code 集成技巧，请参阅 [`skills/droid-skill/README.zh-CN.md`](skills/droid-skill/README.zh-CN.md)。

---

## auto-editor — AI 口播视频剪辑器

基于 FFmpeg 的自动化口播视频剪辑流水线，结合云端 ASR 语音识别与 AI 语义分析。

### 快速开始

```bash
# 1. 检查/安装环境（首次使用）
bash ~/.agents/skills/auto-editor/scripts/install.sh

# 2. 配置 ASR API Key
cp ~/.agents/skills/auto-editor/config/.env.example ~/.agents/skills/auto-editor/config/.env
# 编辑 ~/.agents/skills/auto-editor/config/.env，添加你的 ASR_API_KEY

# 3. 在 Claude Code 中用自然语言调用
/auto-editor cut video.mp4
/auto-editor subtitle video.mp4
/auto-editor export-hd video.mp4
```

### 核心工作流

| 工作流 | 说明 |
|--------|------|
| **Cut（剪辑）** | 自动检测口误并剪辑 — 语音识别 → AI 分析 → 审核页面 → FFmpeg 剪辑 |
| **Subtitle（字幕）** | 生成并烧录字幕 — 带自定义词典的语音识别 → 校对 → 字幕烧录 |
| **Export-HD（高清导出）** | 2-pass 编码 + 锐化 — 检测源参数 → 编码 → 锐化 |

完整规则、检测逻辑、故障排查和参考文档，请参阅 [`skills/auto-editor/README.md`](skills/auto-editor/README.md)。

---

## 仓库结构

```
.
├── README.md
├── README.zh-CN.md
├── CLAUDE.md                 # Claude Code 项目级行为指南
├── .gitignore
├── .claude-plugin/
│   ├── plugin.json           # 技能注册：声明 "skills": "./skills"
│   └── marketplace.json      # 市场展示元数据
└── skills/
    ├── droid-skill/
    │   ├── SKILL.md              # 主系统提示词
    │   ├── index.json            # 技能元数据
    │   ├── README.md             # 详细使用指南
    │   ├── README.zh-CN.md       # 中文使用指南
    │   ├── examples/
    │   │   └── frontend-worker.md
    │   └── prompts/
    │       ├── orchestrator.md
    │       ├── worker-base.md
    │       ├── scrutiny-validator.md
    │       ├── user-testing-validator.md
    │       └── worker-design.md
    └── auto-editor/
        ├── SKILL.md              # 主技能定义
        ├── index.json            # 技能元数据
        ├── README.md             # 使用指南
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

## 参与贡献

欢迎提交 Issue 或 PR，新增工作角色类型、示例或改进提示词。

## 许可证

MIT
