# harmsworth/agent-skills

[![English](https://img.shields.io/badge/lang-English-blue.svg)](README.md)
[![简体中文](https://img.shields.io/badge/lang-简体中文-red.svg)](README.zh-CN.md)

面向 Claude Code 的多技能仓库。包含多智能体软件开发工具和 AI 视频剪辑工具。

## 包含技能

| 技能 | 路径 | 说明 |
|------|------|------|
| **droid-skill** | [`skills/droid-skill/`](skills/droid-skill/) | Droid 任务框架：项目规划、工作执行、代码审查、用户测试、工作角色设计。兼容任意 LLM。 |
| **auto-editor** | [`skills/auto-editor/`](skills/auto-editor/) | 口播视频智能剪辑。自动识别口误/重复/静音/卡顿，生成审核页面，一键 FFmpeg 剪辑导出。跨平台支持 macOS/Linux/WSL2。 |
| **frontend-code-review** | [`skills/frontend-code-review/`](skills/frontend-code-review/) | 前端代码审查评分系统。针对 Vue 3 / TypeScript / JavaScript，从 5 个维度（命名、注释、TS 规范、Vue 规范、JS 逻辑）进行评分，支持 P0-P3 等级评定。 |
| **sjzy-code-review** | [`skills/sjzy-code-review/`](skills/sjzy-code-review/) | 前端 + NestJS 后端代码审查评分系统。单维度计分（100 - 扣分），支持 blocker/major/minor/suggestion 四级，输出严格 JSON。 |
| **kennedy-if** | [`skills/kennedy-if/`](skills/kennedy-if/) | 来自 Ardan Labs service 项目的 Go 分支逻辑规范。使用 `/kennedy-if` 调用。 |
| **kennedy-ext** | [`skills/kennedy-ext/`](skills/kennedy-ext/) | 业务层扩展/装饰器模式，用于横切关注点。使用 `/kennedy-ext` 调用。 |
| **kennedy-arch** | [`skills/kennedy-arch/`](skills/kennedy-arch/) | 分层架构类型边界规则：边缘层用原始类型，Business 层用强类型。使用 `/kennedy-arch` 调用。 |
| **kennedy-pr** | [`skills/kennedy-pr/`](skills/kennedy-pr/) | Service Diffguard PR 审查透镜：正确性、错误、文档、测试、边界和简化。使用 `/kennedy-pr` 调用。 |
| **kennedy-go** | [`skills/kennedy-go/`](skills/kennedy-go/) | 基于目标仓库 Go 版本的现代 Go 语法规范。使用 `/kennedy-go` 调用。 |

## 安装

使用 [skills CLI](https://github.com/vercel-labs/skills) 安装：

```bash
# 全局安装全部技能
npx skills add harmsworth/agent-skills -g --all

# 安装单个技能
npx skills add harmsworth/agent-skills -g --skill droid-skill
npx skills add harmsworth/agent-skills -g --skill auto-editor
npx skills add harmsworth/agent-skills -g --skill frontend-code-review
npx skills add harmsworth/agent-skills -g --skill sjzy-code-review
npx skills add harmsworth/agent-skills -g --skill kennedy-if
npx skills add harmsworth/agent-skills -g --skill kennedy-ext
npx skills add harmsworth/agent-skills -g --skill kennedy-arch
npx skills add harmsworth/agent-skills -g --skill kennedy-pr
npx skills add harmsworth/agent-skills -g --skill kennedy-go

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
cp -r skills/frontend-code-review ~/.agents/skills/
cp -r skills/sjzy-code-review ~/.agents/skills/
cp -r skills/kennedy-if ~/.agents/skills/
cp -r skills/kennedy-ext ~/.agents/skills/
cp -r skills/kennedy-arch ~/.agents/skills/
cp -r skills/kennedy-pr ~/.agents/skills/
cp -r skills/kennedy-go ~/.agents/skills/
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

## frontend-code-review — 前端代码审查评分

针对 Vue 3 / TypeScript / JavaScript 项目的 AI 代码审查评分系统。从 5 个维度对代码进行加权评分，并给出 P0-P3 等级评定。

### 5 个审查维度

| 维度 | 权重 | 核心内容 |
|------|------|---------|
| 命名规范 | 10% | 组件名、变量/函数名、常量 |
| 注释规范 | 10% | JSDoc、步骤注释、TODO/FIXME/BUG 标签 |
| Vue 3 TypeScript 规范 | 20% | 类型覆盖、ref 标注、defineProps/defineEmits/defineModel |
| Vue 3 开发规范 | 25% | v-for key、代码组织顺序、scoped、shallowRef |
| JS 开发规范 | 35% | 圈复杂度、函数式编程、逻辑完备性 |

### 快速使用示例

- "帮我审查这个 Vue 组件"
- "给这段代码打个分"
- "检查这段代码的命名规范"

### 核心规则

- **命名**：单个事件用 `handleClick`，多个事件用 `handleXXClick`（如 `handleSubmitClick`）。Modal 用 `XXModal`，Drawer 用 `XXDrawer`。
- **注释**：复杂逻辑要有步骤注释。使用 `// TODO`、`// FIXME`、`// BUG`。
- **Vue**：`v-for` 必须有 `:key`（不能用 `index`）。必须使用 `scoped`。大数据用 `shallowRef`。
- **JS**：函数圈复杂度 ≤ 20。`switch` 必须有 `default`。`computed` 中禁止副作用。

完整评分细则、等级定义和示例输出，请参阅 [`skills/frontend-code-review/README.md`](skills/frontend-code-review/README.md)。

---

## sjzy-code-review — SJZY 代码审查评分

针对 Vue 3 / TypeScript 前端和 NestJS 后端的 AI 代码审查评分系统。采用单维度计分（初始 100 分，按问题扣分），输出严格 JSON。

### 与 frontend-code-review 的核心区别

| 维度 | frontend-code-review | sjzy-code-review |
|------|---------------------|------------------|
| 评分方式 | 多维度加权（5 维度 × 权重） | 单维度（100 - 扣分合计） |
| 后端支持 | 无 | 完整的 NestJS 后端规则 |
| 扣分等级 | 按规则权重百分比 | 固定分值：blocker/major/minor |
| 输出格式 | Markdown 报告 | 严格 JSON |
| 前端 import 检查 | 是（类型覆盖检查） | **否** — 不检查缺少的 import |
| 后端安全 | 不涉及 | 仅作为 suggestion（points = 0） |

### 扣分等级

| 等级 | 分值 | 说明 |
|------|------|------|
| blocker | 20-35 | 导致线上故障、数据错误、编译失败 |
| major | 8-15 | 业务逻辑缺陷、类型安全风险 |
| minor | 2-5 | 规范、可读性、可维护性问题 |
| suggestion | 0 | 可改进点；后端安全问题 |

### 规则覆盖

- **公共规则**（所有文件）：正确性、稳定性、类型契约、数据一致性
- **前端规则**（Vue/TSX）：魔法数字、类型安全、Vue 3 结构规范、业务交互、样式
- **NestJS 后端规则**（controller/service/dto/entity 等）：代码规范、幂等保护、输入校验、事务、查询边界

### 快速使用示例

- "Review this diff for me"
- "帮我评审这个 PR 的代码"
- "检查这段 NestJS controller 的代码"

### 输出示例

```json
{
  "score": 88,
  "reason": "存在魔法数字和v-for缺少key的问题",
  "deductions": [
    {
      "file": "src/components/UserList.vue",
      "line": 42,
      "category": "frontend.magic-number",
      "severity": "minor",
      "points": 3,
      "reason": "使用魔法数字 status === 1 进行业务状态判断",
      "suggestion": "定义常量：const STATUS_ACTIVE = 1"
    }
  ]
}
```

完整规则和 JSON 格式说明，请参阅 [`skills/sjzy-code-review/README.md`](skills/sjzy-code-review/README.md)。

---

## Kennedy Service Skills — Ardan Labs Service 约定

这 5 个技能复制自 Ardan Labs `service` 项目，并重命名为 slash command 形式：

| 命令 | 技能 | 用途 |
|------|------|------|
| `/kennedy-if` | `kennedy-if` | 用 default-first 赋值和裸 `switch` 重构浅层 Go 条件逻辑。 |
| `/kennedy-ext` | `kennedy-ext` | 通过 `ExtBusiness`/`Extension` 装饰器模式添加业务层横切关注点。 |
| `/kennedy-arch` | `kennedy-arch` | 检查 App / Business / Storage 类型边界和命名转换器。 |
| `/kennedy-pr` | `kennedy-pr` | 运行 Service Diffguard PR 审查透镜。 |
| `/kennedy-go` | `kennedy-go` | 根据仓库 Go 版本应用现代 Go 语法规范。 |

单独安装示例：

```bash
npx skills add harmsworth/agent-skills -g --skill kennedy-go
```

安装后可在 Claude Code 中直接调用：

```text
/kennedy-go
/kennedy-pr review this diff
```

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
    └── frontend-code-review/
        ├── SKILL.md              # 主技能定义（5个审查维度 + 评分规则）
        ├── index.json            # 技能元数据
        ├── README.md             # 使用指南（含示例输出）
        └── prompts/
            └── review-prompt.md  # 详细审查提示词（供子代理使用）
    └── sjzy-code-review/
        ├── SKILL.md              # 主技能定义（入口 + 概述）
        ├── index.json            # 技能元数据
        ├── README.md             # 使用指南（含 JSON 示例）
        └── prompts/
            └── review-prompt.md  # 完整审查规则：公共 + 前端 + NestJS 后端
    └── kennedy-if/
        ├── SKILL.md              # Go 分支逻辑规范
        └── index.json            # 技能元数据
    └── kennedy-ext/
        ├── SKILL.md              # 业务扩展/装饰器模式
        └── index.json            # 技能元数据
    └── kennedy-arch/
        ├── SKILL.md              # 分层架构类型规则
        └── index.json            # 技能元数据
    └── kennedy-pr/
        ├── SKILL.md              # Service Diffguard 审查工作流
        ├── index.json            # 技能元数据
        └── reference/            # 审查透镜提示词
    └── kennedy-go/
        ├── SKILL.md              # 现代 Go 规范
        └── index.json            # 技能元数据
```

## 参与贡献

欢迎提交 Issue 或 PR，新增工作角色类型、示例或改进提示词。

## 许可证

MIT
