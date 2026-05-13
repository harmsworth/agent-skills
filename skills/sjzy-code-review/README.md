# SJZY Code Review

AI 代码审查评分系统，支持 Vue 3 / TypeScript 前端和 NestJS 后端。基于单维度总分制（100 分 - 扣分），输出严格 JSON。

## 特性

- **前后端分离评分**：前端文件（Vue/TSX）用前端规则，后端文件（NestJS）用后端规则，同个 diff 自动区分
- **四级扣分体系**：blocker(20-35) / major(8-15) / minor(2-5) / suggestion(0)
- **严格 JSON 输出**：包含 score、deductions 数组（file/line/category/severity/points/reason/suggestion）
- **后端安全问题不扣分**：权限、鉴权、SQL 注入、XSS、SSRF 等仅作为 suggestion 指出（points = 0）
- **不检查前端 import**：不报告 useXXX、ref、computed 等符号的缺少 import 问题

## 安装

### 全局安装（推荐）

```bash
cp -r skills/sjzy-code-review ~/.claude/skills/
```

重启 Claude Code，skill 自动加载。

### 项目内使用

将 `sjzy-code-review/` 目录放入项目仓库，然后引用：

> "使用 `sjzy-code-review/SKILL.md` 中的规则审查这段代码。"

## 使用方法

自然语言调用即可：

- "Review this diff for me"
- "帮我评审这个 PR 的代码"
- "检查这段代码是否符合规范"
- "Review these NestJS controller changes"

## 评分体系

| 等级 | 分值 | 说明 |
|------|------|------|
| blocker | 20-35 | 导致线上故障、数据错误、编译失败 |
| major | 8-15 | 明确业务逻辑缺陷、类型安全风险 |
| minor | 2-5 | 规范、可读性、可维护性问题 |
| suggestion | 0 | 可改进但不构成缺陷；后端安全问题 |

## 规则覆盖

### 公共规则（所有文件）
- 正确性与稳定性：空值处理、错误日志、debugger、编译错误
- 类型与数据契约：接口一致性、空值检查、精度敏感计算、硬编码密钥

### 前端规则（Vue/TSX/前端模块）
- 魔法数字/字符串
- 类型安全（any/类型断言）
- Vue 3 组件结构（ Composition API、props 类型、v-for key、computed 纯计算等）
- 前端业务与交互（loading、表单校验、权限）
- 样式与可访问性（scoped、语义类名）

### NestJS 后端规则
- 代码规范与注释
- 幂等保护、输入校验
- DTO/契约一致性
- 事务与多表一致性
- 查询边界与分页
- 外部调用失败处理
- Entity 字段变更风险

## 输出示例

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
    },
    {
      "file": "src/components/UserList.vue",
      "line": 55,
      "category": "frontend.vue-structure",
      "severity": "major",
      "points": 10,
      "reason": "v-for 循环使用 index 作为 key",
      "suggestion": "使用 item.id 等唯一稳定标识作为 key"
    }
  ]
}
```
