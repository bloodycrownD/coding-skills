# 动态 DAG 派遣（通用编排纪律）

> loop 类 skill（code-dev-loop / code-review-loop / spec-check-loop）共用的编排纪律在这里统一：wave、同步等待、改图、状态落盘、震荡处置。各 skill 自己的 SKILL.md 只保留**该 skill 特有的动作表与节点类型**，引用本文件，不复制条款。

## 一、核心概念

- **wave（波次）**：一轮并行派遣。wave 内节点无冲突可并行；**同步等待**全部返回后再汇总、决策。
- **dag_version**：编排版本号。每轮 wave 结束或 not-ready 后改图，`dag_version++`。
- **not-ready**：本轮未达终点态——不是失败，是「改图再来」的信号。
- **节点状态 node_status**：每个节点的 status / 产物 sha / executor 等记账。

## 二、通用改图动作

| 动作 | 何时 |
|------|------|
| **并行化** | 无文件冲突的节点同 wave |
| **合并** | 多个同类节点针对同一模块 → 单节点 |
| **拆分** | 节点过大或反复 fail → 串行子节点 |
| **优先 P0** | 阻塞下游的条目排进下一 wave / 直改计划首部 |
| **插入审查节点** | 实现波次后、下一模块前（**须在 DAG 内显式出现**） |

各 skill 特有动作（dev 的插入 cr-func、review 的两段式、doc-fix 直改等）见各自 SKILL.md。

## 三、状态落盘

- 编排状态（`dag_version`、`wave_plan`、`node_status`、open must-fix、fix/doc 计划等）写在 **`docs/.iteration-state.yaml`** 或 Context Bundle / 对话内 YAML。
- **禁止写入记忆文件**（`docs/apm/memory/` 与 `RULE.md`）——那是 apm-record 的地盘，只放一两句人话现状。
- 会话中断后靠它恢复：done 节点不重跑，进行中节点按其状态续。

## 四、震荡与终止

- **同一 must-fix 震荡 ≥3 次** → **blocked**，停下请用户拍板——真值在用户，不在循环。
- 各 skill 轮次上限（默认 5 轮）见各自 SKILL.md；超限汇报未闭合项请用户。
- 终点态是**结论**（dev-ready / fix-spec-ready / execute-ready），不是波次节点，不单独派子代理。

## 五、禁止事项

- not-ready 时只「再派一个 fix」而不更新 `wave_plan` / `dag_version`——等于没有编排记忆。
- 宣称终点态却未满足其检查清单（各 skill 定义）。
- 未等当前 wave 返回即改图或派下一环。
- 把 DAG/YAML 状态贴进记忆文件。

## 六、与通用代理的关系

派单本身（工具/subagent_type/readonly/失败政策/反锚定）见《coding-rules》reference·通用代理；本文件只管**编排**（怎么组 wave、怎么改图、状态放哪）。派单模板的 skill 专属变体在各 skill 的 `reference/`。
