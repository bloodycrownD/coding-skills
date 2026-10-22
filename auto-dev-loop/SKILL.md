---
name: auto-dev-loop
description: 全自动开发流水线：编排 prd-generate → spec-generate → spec-check-loop → code-dev-loop → 测试 → code-review-loop → 复检 → 修复 → 复测 → apm-record。支持阶段豁免（现成 PRD/SPEC 直接进执行、免测试/免 CR）与自定义阶段插入（如最终发布）。当用户要求「全自动开发」「从需求一条龙跑到交付」「拿着现成的 PRD/SPEC 跑完整流程」时使用。
disable-model-invocation: true
---

# Auto Dev Loop（全自动开发流水线）

**纯编排层**：本 skill 自己不实现任何阶段——逐段调用族内 skill，每阶段的执行细节、终点态、失败政策**以该 skill 为准**；本 skill 只管顺序、豁免、闸门与状态落盘。派子代理的通用定义见《coding-rules》reference·通用代理。

## 一、默认流水线

```text
prd-generate → spec-generate → spec-check-loop → code-dev-loop
  → 测试（e2e/common） → code-review-loop → spec-check-loop（复检）
  → code-dev-loop（按 fix-spec 修复） → 测试（复测） → apm-record（收尾记忆）
```

| # | 阶段 | 执行 skill | 输入 | 终点态 | 可豁免 |
|---|------|-----------|------|--------|--------|
| 1 | PRD | prd-generate | 用户需求 | prd.md + 用户确认 | **可**（用户拿现成 PRD 进入） |
| 2 | SPEC | spec-generate | prd.md | spec.md + 用户确认 | **可**（现成 SPEC） |
| 3 | 文档核验 | spec-check-loop | prd + spec | execute-ready | 可（小改动/用户明示直进开发） |
| 4 | 开发 | code-dev-loop | spec | dev-ready | **不可**（核心阶段） |
| 5 | 测试 | 主代理跑项目 e2e/全量测试命令 | 代码 | 测试通过 | 可（用户豁免；无 e2e 时跑全量测试/build 并在汇报注明覆盖范围） |
| 6 | 评审 | code-review-loop | diff + prd + spec | fix-spec-ready | 可（用户豁免） |
| 7 | 复检文档 | spec-check-loop | 修订后文档 | execute-ready | 阶段 6 无文档修订时自动跳过（记录为 exempt） |
| 8 | 修复 | code-dev-loop | fix-spec | dev-ready | 阶段 6 豁免或无 must-fix 时自动跳过 |
| 9 | 复测 | 同阶段 5 | 代码 | 测试通过 | 同阶段 5 豁免 |
| 10 | 记忆 | apm-record | 全程结论 | memory 落盘 | **不可**（收尾必做） |

**终点 pipeline-ready**：全部阶段 `done` 或 `exempt`，向用户汇报每阶段产物路径（prd/spec/fix-spec/分支/HEAD/测试结论）。

## 二、豁免（exempt）

**豁免语法**（用户原话即豁免依据）：

- 「用现成的 prd/spec」→ 阶段 1/2 豁免；主代理先读入该文档并**一句话复述要点**（复述闸门精神：起点理解错了整条流水线白跑），无出入再开跑。
- 「跳过测试」「不要 CR」「直接从 dev 开始」→ 对应阶段豁免。
- **隐含豁免须确认**：用户拿着 PRD 进来说「跑完整流程」——起点是阶段 2 还是 4？一句话问清再开跑，不自作主张。

**豁免登记**（不落盘＝白豁免）：

```yaml
pipeline:
  exemptions: [{ stage: 3, reason: 用户豁免文档核验, quote: 「小改动直接开发」 }]
```

**不可豁免**：阶段 4（开发本体）、阶段 10（apm-record 收尾）。

## 三、自定义阶段

用户可插入/替换阶段（「最后加一个发布阶段」「测试换成真机回归」）：

- 有对应 skill → 按该 skill 执行；
- 无对应 skill → 主代理按用户指示直接执行并留痕（做了什么、结果、证据）；
- 登记 `custom_stages: [{ position: after-stage-9, name: 发布, instruction: <用户原话> }]`。

## 四、闸门策略（何时停）

| 闸门 | 默认 | 用户说「全自动/别停」后 |
|------|------|------------------------|
| PRD 确认（阶段 1 末） | **必停**，等用户确认 | 改为豁免登记后直通；但复述与用户意图有出入时**仍停** |
| SPEC 确认（阶段 2 末） | **必停** | 同上 |
| 阶段间流转 | 自动，汇报一行进度 | 自动 |
| 阶段内 blocked（震荡≥3/轮次上限） | 停下汇报请拍板 | **仍停**——blocked 永不自动绕过 |

理解层闸门（PRD/SPEC）默认必停的原因：这两个文档是后续所有阶段的输入，理解层错误传播最贵。

## 五、状态落盘与恢复

`docs/.iteration-state.yaml` 的 `pipeline` 段：

```yaml
pipeline:
  stages: [{ id: 1, name: PRD, skill: prd-generate, status: done, artifact: docs/iterations/<name>/prd.md }, ...]
  exemptions: [...]
  custom_stages: [...]
  current: 4
```

- 每阶段终点达成即更新（status: pending → running → done/exempt + artifact）。
- **会话中断恢复**：done/exempt 阶段不重跑；running 阶段按其 skill 自身状态（各 loop 的 iteration-state 段）续跑。
- 各阶段的编排细节仍在各 skill 自己的状态段里；本段只管流水线层。

## 六、失败政策

- 阶段内失败：先按该 skill 自身的失败政策（重试 → 手工标注 → blocked）。
- 阶段 blocked → **整条流水线停下**，汇报卡点与已完成阶段，请用户拍板；不静默降级、不跳过继续。
- 阶段产物缺失（如豁免了阶段 1 但没有 prd 路径）→ 停下问用户，不虚构。

## 执行检查清单

- [ ] 起点已确认（从阶段几开始；现成文档已读入并一句话复述）
- [ ] 豁免全部有登记（stage + reason + 用户原话）；未豁免不可豁免项
- [ ] 每阶段按其 skill 执行并以其终点态为准；未自行缩短阶段流程
- [ ] PRD/SPEC 闸门默认已停；「全自动」时豁免已登记且复述出入仍停
- [ ] blocked 已停下汇报；未静默绕过
- [ ] pipeline 段已随阶段推进更新；中断恢复未重跑 done 阶段
- [ ] 收尾已执行 apm-record；已汇报各阶段产物路径
