# coding-skills

开发技能库：**11 个技能平铺在仓库根**（每目录一个 skill：SKILL.md + 可选 reference/）。族地图与公共规则见 **coding-rules**。

| 技能 | 一句话定位 |
|---|---|
| coding-rules | 族入口与公共规则库：通用代理（探索/开发/CR）、动态 DAG 派遣纪律、AGENTS 行为约定（reference 三件套） |
| brain-storm | 通用答疑：多子代理并行探索，据证据回答 |
| prd-generate | PRD 生成：探索→澄清（含澄清收口复述）→落盘 |
| spec-generate | SPEC 生成：读 PRD→探索（含复述闸门）→落盘 |
| spec-check-loop | 文档审查循环：审→doc-fix 直改→再审，至 execute-ready |
| code-dev-loop | 开发 DAG：impl/verify/cr-func 波次并行，动态重编排，至 dev-ready |
| code-review-loop | 评审循环：审→spec-fix 直改 fix-spec→再审，至 fix-spec-ready |
| auto-dev-loop | 全流程自动编排：PRD→SPEC→核验→开发→测试→CR→修复→复测→记忆；阶段豁免＋自定义阶段 |
| agile-dev | 迭代内快开发：探索→实现（授权档位）→验证→补 prd/spec 留痕 |
| apm-recall / apm-record | 记忆读／写（docs/apm 约定） |

## 唯一权威表

| 关注点 | 权威文件 | 其他技能的动作 |
|---|---|---|
| 通用代理定义（探索/开发/CR：派遣规范、报告结构、基础模板、语言要求块） | coding-rules/reference·通用代理 | 引用，禁止复制条款 |
| 授权档位、轻量直改判据、证据包、失败政策、反锚定 | coding-rules/reference·通用代理 | 引用 |
| 动态 DAG 编排纪律（wave／同步等待／改图／dag_version／状态落盘／震荡） | coding-rules/reference·动态DAG派遣 | 三个 loop 引用；各自只留特有动作表 |
| 通用代理行为与人格（原根 AGENTS.md） | coding-rules/reference·AGENTS.md | 按需取用 |
| skill 专属派单模板与变体 | 各 skill `reference/代理派单.md` | 派单时随用随取 |
| 记忆读写约定 | apm-record / apm-recall | 全族引用 |
| 流水线编排、阶段豁免、自定义阶段 | auto-dev-loop | — |

## 部署与维护

- 部署：`powershell -ExecutionPolicy Bypass -File sync-skills.ps1`——整目录拷贝（含 reference/）＋逐文件哈希校验；**改完技能必跑**，信任哈希不信任记忆。
- STALE 提示＝部署目录有而仓库没有的技能，手工确认后删。
- 记忆归属：coding 库的事记本库 `docs/apm/memory/`；novel 库的事记 novel-skills 仓库。
- reference 归属原则：skill 专属派单放本技能 reference/；跨技能通用定义放 coding-rules/reference/。
