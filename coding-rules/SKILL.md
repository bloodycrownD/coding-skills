---
name: coding-rules
description: coding 技能族的入口与公共规则库：技能族地图、通用代理定义（探索/开发/CR agent）、动态 DAG 派遣纪律、通用 AGENTS 行为约定。当用户问「该用哪个开发 skill」、需要查通用代理怎么派、或需要 coding 侧公共规则时使用。技能专属的派单模板在各 skill 自己的 reference/。
---

# coding-rules（族入口 · 公共规则库）

coding 技能族的**目录页与公共书架**：族内 skill 管工作流（prd → spec → check → dev → cr），本 skill 管三件事——**指路**（现在该用哪个 skill）、**通用代理定义**（探索／开发／CR agent 怎么派）、**编排纪律**（动态 DAG、证据包、失败政策）。

## 一、技能族地图

```
brain-storm（答疑/摸底）
prd-generate → spec-generate → spec-check-loop → code-dev-loop → code-review-loop
                                                      ↑______________|（fix-spec 回流）
apm-recall / apm-record：记忆读写
```

| 用户在说 | 用哪个 |
|---|---|
| 「帮我看看这个功能怎么实现的」「能不能用 X 做 Y」 | brain-storm |
| 「写个 PRD」「澄清新需求」 | prd-generate |
| 「写 spec」「技术方案」「实现计划」 | spec-generate |
| 「审一下这份 PRD/SPEC」「文档能不能开工」 | spec-check-loop |
| 「按 spec 开发」「实现这个迭代」 | code-dev-loop |
| 「评审代码」「CR」「产出修复 spec」 | code-review-loop |
| 要派子代理（探索/实现/评审） | 代理定义与纪律见本技能 reference |

## 二、公共参考（reference/）

**归属原则：skill 专属的派单模板放该 skill 自己的 reference/；跨 skill 通用的代理定义与编排纪律放这里。**

| 文件 | 内容 | 谁在读 |
|---|---|---|
| `reference/通用代理.md` | 探索 agent／开发 agent／CR agent 定义：派遣规范、报告结构、prompt 基础模板；通用纪律（同步等待、失败政策、反锚定、授权档位、轻量直改、证据包）；**动态 DAG 编排纪律**（wave／改图／dag_version／落盘／震荡，loop 类共用） | 所有工作流 skill 派子代理时；三个 loop 编排时 |
| `reference/AGENTS.md` | 通用代理行为约定（原根 AGENTS.md 全文）：人格语气、中文表达、术语规范、子代理派遣原则、记忆记录 | 需要统一行为口径时；人格部分按需取用 |

## 三、层间关系

- **通用层**（本库）：与具体项目无关，换项目不改。
- **项目层**（目标项目自己的 `docs/apm/RULE.md` 与文档约定）：技能从中读取，未提供时问用户，不虚构。
- 冲突时项目层优先。
