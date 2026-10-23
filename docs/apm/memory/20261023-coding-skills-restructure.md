---
date: 2026-10-23 01:05
title: coding-skills 仓库重排：平铺改名、代理内容抽 reference、新增 coding-rules 与 auto-dev-loop
keywords: coding-skills, 平铺, coding-rules, auto-dev-loop, 通用代理, 动态DAG, reference 分层, 部署同步
abstract: dev-skills 九技能平铺到仓库根并更名 coding-skills（旧目录被进程占用，走本地 clone 方案）；七个工作流 skill 的代理派遣内容抽到各自 reference/代理派单.md；新建 coding-rules（族入口，收编通用代理定义/动态DAG纪律/原根AGENTS.md）与 auto-dev-loop（全流程编排＋阶段豁免＋自定义阶段）；sync-skills.ps1 升级为整目录拷贝＋逐文件哈希；11 技能部署全绿。
---

user:
新一轮大改 coding 仓库：一、把 dev-skills 下的技能全部提出来平铺到仓库根，目录名从 useful-skills 改成 coding-skills；二、新增 coding-rules skill，把之前想统一管理的 AGENTS.md 和动态 DAG 代理派遣规则都放进去；三、七个工作流 skill（agile-dev/brain-storm/code-dev-loop/code-review-loop/prd-generate/spec-check-loop/spec-generate）以前把子代理的命令和提示词混在主文件里，参考 novel skill 的思路各自建 reference/ 存代理内容，通用的（探索 agent、通用开发 agent、通用 CR agent）放 coding-rules；四、新增 auto-dev-loop 全自动开发 skill，编排 prd-gen → spec-gen → spec-loop → dev-loop → e2e/common test → cr-loop → spec-check → dev → test → apm-record，允许阶段豁免（现成 prd/spec 直接执行、免测试/免 CR）和自定义阶段（如最终发布）。

assistant:
全部落地，部署哈希全绿（11 技能）。一、目录：旧 D:\Dev\Js\useful-skills 被进程占用改不了名（八成是编辑器开着），走 git 本地 clone 到 D:\Dev\Js\coding-skills、origin 重指 GitHub 新名——旧目录成了陈旧副本，待用户关掉占用进程后手工删除。dev-skills/* 经 git mv 平铺到根（c85874b）。二、coding-rules skill＝族入口（技能地图）＋reference 三件套：通用代理.md（探索/开发/CR 三类 agent 的派遣规范、报告结构、prompt 基础模板、语言要求块；通用纪律：同步等待、失败政策、反锚定首诊/复审、授权档位、轻量直改判据、证据包——原先在 4-5 个 skill 里各有一份的重复条款收敛于此，为唯一权威）、动态DAG派遣.md（wave/dag_version/改图动作/状态落盘 iteration-state 不进记忆/震荡≥3 blocked/禁止事项，三个 loop 共用）、AGENTS.md（原根 AGENTS.md 全文收编；根 AGENTS.md 改为仓库指针）。三、七个工作流 skill 各建 reference/代理派单.md 收纳专属变体（派遣表、prompt 模板、报告变体、维度参考），主文件对应块替换为「派遣与模板」指针段，共 28 处引用《coding-rules》reference；workflow 逻辑（终点态、检查维度、严重度、文档模板）原样保留在主文件。grep 验证活动文件零「dev-skills」残留。四、auto-dev-loop：纯编排层（不自己实现阶段，逐段调用族内 skill、终点态以各 skill 为准）；10 阶段表；豁免须登记 iteration-state 的 pipeline.exemptions（stage+reason+用户原话，不落盘＝白豁免），现成 PRD/SPEC 进入先一句话复述起点，不可豁免开发本体与 apm-record 收尾；自定义阶段登记 custom_stages；闸门策略：PRD/SPEC 确认默认必停（理解层错误传播最贵），「全自动」指令可豁免闸门但复述有出入仍停、blocked 永不自动绕过；状态落 pipeline 段支持中断恢复（done 不重跑）。五、sync-skills.ps1：源从 dev-skills 子目录改为仓库根，SKILL.md 单文件拷贝升级为整目录镜像（含 reference/，目标先删再拷防残留文件）＋逐文件 MD5；STALE 仅提示不自动删（art-direction/krea2-draw 为独立技能保留）。经验：旧目录被占用时 clone 方案零损失（工作树本就干净）；Windows 下 PowerShell 5.1 无 BOM UTF-8 按 ANSI 解析的坑继续规避（脚本保持纯 ASCII）。

user:
追问三连：一、是否每个 skill 都有必要有 reference？二、coding-rules 的 reference 能否共用？三、旧 useful-skills 目录怎么删不掉、没权限？随后追加指令：删除根 AGENTS.md——上一条消息就是在下这个删除命令，被漏读了。

assistant:
三点全落地。一、7 份 reference 砍成 4 份：brain-storm/prd-generate/spec-generate 三个探索型 skill 的变体与通用探索 agent 重合约八成（只差两三个字段和一张维度表），独立成文件是形式主义——删掉各自 reference/，SKILL.md 内改为「通用探索 agent＋字段替换」写法（目的行、任务字段、报告变体、维度表内联）；agile-dev/code-dev-loop/code-review-loop/spec-check-loop 四份保留（有真专属 prompt 集）。二、动态DAG派遣.md（仅 60 行、受众同为派单者）并入通用代理.md 成「§五 动态 DAG 编排纪律」，coding-rules/reference 收敛为两件套（通用代理.md＋AGENTS.md），全家引用同步改口径，grep 零残留。三、useful-skills 删除：当时失败是编辑器占着句柄，重试一次即删掉；旧副本清零，仓库唯一真身在 coding-skills。四、根 AGENTS.md 删除（1ba825e）：原留指针是我保守，用户裁定不要——agent.md 统一管理的语义就是内容只在 coding-rules/reference/AGENTS.md 一处，根层再留指针反而名不副实；前文「根 AGENTS.md 改为仓库指针」作废。教训：用户消息可能是执行指令而非提问，「这个删除命令你没看到吗」应先理解为「我下过删除指令」，而不是去文件里找命令——语义歧义时先确认意图再行动。

user:
auto-dev-loop 这个全自动开发 skill 非常拉胯，无法使用，删掉。

assistant:
已删（仓库目录+部署副本+族地图/路由/README 引用，提交推送）。用户实测判定不可用，未给具体失败原因；「编排层 skill 调度同族其他 skill」这条路在当前运行环境跑不通，后续如再想做全流程自动化，须先弄清失败模式（子 skill 无法被 skill 内调用？上下文耗尽？）再设计，勿直接重建同构方案。
