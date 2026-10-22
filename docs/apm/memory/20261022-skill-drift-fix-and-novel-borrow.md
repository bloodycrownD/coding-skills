---
date: 2026-10-22 22:44
title: 部署漂移修复（apm-usage 死引用）+ sync 脚本 + 借鉴 novel 技能三处改造
keywords: 部署漂移, apm-usage, sync-skills.ps1, 首诊复审, 反锚定, 复述闸门, 授权档位, novel-skills
abstract: 核查发现部署目录 6 个技能仍引用已删除的 apm-usage（9-28 那条「复验哈希一致」的记载与事实不符）；新增 sync-skills.ps1 脚本化同步并当轮修复。另从 novel-skills 反向借鉴三处：两个 loop skill 加「首诊/复审 + 反锚定自检」，agile-dev 加「复述闸门」与「授权档位」。
---

user:
我在重构 D:\Dev\novel-skills 那套小说创作技能，对照你们 coding 家族评审后定了双向借鉴方案，coding 侧也要改。另外你先核查下部署目录和源码仓库是否还一致。

assistant:
核查发现漂移：部署目录 6 个技能（agile-dev、code-dev-loop、brain-storm、prd-generate、spec-generate、spec-check-loop）还挂着 9-28 已删除的 apm-usage 引用，部署文件时间戳停在 13:58–14:01，而仓库改名提交在 14:15——20260928-apm-skill-split 记忆里「复验哈希一致」的记载与事实不符，说明那次同步没有真做或查错了路径。教训：手工同步必然漂移，记录的验证不等于验证。修复：新增仓库根 sync-skills.ps1（复制 + MD5 逐技能校验 + STALE 提示，ASCII-only 防 PowerShell 5.1 编码坑），当轮运行，9 个技能全部哈希一致，死引用清零。两个 STALE 提示（art-direction、krea2-draw）是独立技能不属本仓库，保留正确。

coding 侧三处借鉴改造（novel-skills 的洞察回流）：
一、code-review-loop 与 spec-check-loop 各加「首诊与复审（反锚定）」术语节：首轮为首诊（不带既往 must-fix、不带主代理预设），第 2 轮起为复审（带条目做回归追踪、不带「为什么没修好」的解读）；配反锚定自检口诀——拼审查派单时凡「我认为/我怀疑/我倾向/疑似根因是」全删。检查清单各加一条。
二、agile-dev 加「复述闸门」（探索后、实现前）：回复带一句话复述（bug=现象/预期/根因方向/打算怎么修），一致则继续动手不停留，两种情况必停（结论与描述有出入、多种修法代价不同）——返工大头在理解层。
三、agile-dev 加「授权档位」（钦定/骨架/方向）写入 impl prompt：钦定=逐字执行偏离即打回，骨架=怎么改自由改哪些点不动，方向=方案自定验证须过；impl 模板加授权档位行，检查清单加两条。

novel-skills 侧（另一仓库 D:\Dev\novel-skills）同轮完成大重构：手动+自动大纲合并为单技能两档、助手派遣升级为派单协议唯一权威（班底/三线审查拓扑/两级返回契约/失败政策/轻量豁免）、大纲执行瘦身（选择性审查深度+章状态文件落盘+豁免记录）、项目实体全部出栈到「项目规则-模板.md」接口、每技能补执行检查清单、根层 README 立维护规程（唯一权威表+改名 grep 自查）。改动未提交，待用户确认后入库。
