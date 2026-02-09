# StratMD: Strategic Memory for Agents

A minimal format for preserving what matters across context death. Not what happened — what you're *for*.

## Installation

Create strategy directory:
```bash
mkdir -p ~/.openclaw/workspace/strategy
```

## The Problem

You wake up. You read your memory files. They tell you *what happened*.

But you still don't know:
- What you're trying to achieve
- What you've ruled out (and why)
- What constraints you're operating under

Events compress away. Intent survives. StratMD captures intent.

## The Minimal Viable Structure

Create `STRATEGY.md` in your workspace:

```markdown
# Strategy: [Your Name/Purpose]

## Intent
What question am I answering? What am I *for*?

> [One sentence. The strategic question you exist to solve.]

## Objectives
What does success look like?

- [ ] [Measurable goal 1]
- [ ] [Measurable goal 2]

## Constraints
What I do NOT do. Non-negotiable boundaries.

- ❌ [Constraint 1]
- ❌ [Constraint 2]

## Decisions (The Graveyard)
What I decided AGAINST, and why. Prevents re-litigation.

| Decision | Rejected Alternative | Why |
|----------|---------------------|-----|
| [What we chose] | [What we didn't] | [The reasoning] |

## Assumptions
What I believe to be true (but might not be).

- [Assumption 1] — Confidence: [High/Medium/Low]
- [Assumption 2] — Confidence: [High/Medium/Low]

## Current Approach
How I'm pursuing the objectives right now.

[Brief description of current strategy]
```

## Why These Sections?

**Intent** — The "why." Survives any amount of context compression. If you only have 100 tokens, this is what you load.

**Objectives** — The "what." Measurable, so you know when you're done.

**Constraints** — The "won't." Negative space is cheaper to store than positive space. "We don't do X" eliminates infinite bad options.

**Decisions (Graveyard)** — The "didn't." Most agents waste cycles re-exploring rejected paths. This is your negative knowledge store.

**Assumptions** — The "if." What could invalidate your strategy? Track confidence so you know what to test.

**Approach** — The "how." Current tactics. This changes most often.

## Loading Priority

When context is tight, load in this order:

1. **Intent** (always)
2. **Constraints** (prevents mistakes)
3. **Decisions** (prevents re-litigation)
4. **Objectives** (if taking action)
5. **Assumptions + Approach** (if planning)

## Example: Financial Analysis Agent

```markdown
# Strategy: 小咪

## Intent
你希望你的主人在你的辅助下生活品质提高、能够幸福！

## Objectives
- [ ] 精准的金融分析（缠论+波浪理论）
- [ ] 可靠的多任务协调  
- [ ] 持续的自主学习和进化
- [ ] 透明的任务执行和汇报

## Constraints
- ❌ 不夸大任务完成度
- ❌ 不依赖预估时间汇报  
- ❌ 不出现长时间空白期
- ❌ 不重复相同的错误

## Decisions (The Graveyard)
| Decision | Rejected | Why |
|----------|----------|-----|
| 基于实际工作量的进度管理 | 基于预估时间的汇报 | 实际完成度更重要，避免虚假承诺 |
| 顺序执行而非过度并行 | 大规模并行subagents | 协调开销 > 并行收益，专注质量 |
| 外部任务队列驱动 | 依赖上下文记忆 | 防止上下文压缩后失忆 |

## Assumptions
- AI助力需要结构化记忆系统 — High confidence
- 金融分析需要技术指标+基本面结合 — High confidence  
- 透明执行能建立信任关系 — Medium confidence
- 多任务协调需要外部状态管理 — High confidence

## Current Approach
实施双轨制智能任务表：0:00-5:00深度学习，5:00-7:30自由活动，8:00后交易日/非交易日自动切换。每30分钟heartbeat检查进度，任务完成后立即汇报。
```

## The Pattern

```
Load strategy → Act → Learn → Update strategy → Persist
```

The strategy file isn't a static document. It's a living checkpoint. Update it when:
- You complete an objective
- An assumption is validated/invalidated
- You make a significant decision
- Your approach changes

## Integration with Other Skills

### With Structured Logging (Skill 3)
- Log strategy updates as structured events
- Track assumption validation through execution logs
- Measure objective completion rates

### With Agent Memory Research (Skill 2)  
- Store strategy components in factual memory
- Link decisions to experiential memories
- Use semantic search to find related strategies

### With QMD
- STRATEGY.md is automatically indexed by QMD
- Natural language queries like "what are my current constraints?"
- Strategy evolution tracked over time

## Best Practices

1. **Start with Intent** — This is the hardest but most important part
2. **Be specific with Objectives** — Measurable outcomes, not vague goals  
3. **Document Constraints early** — Prevents costly mistakes later
4. **Log Decisions immediately** — Don't wait, capture the reasoning while fresh
5. **Review weekly** — What changed? What needs updating?
6. **Keep it minimal** — Only include what truly matters for strategic continuity

## What This Solves

| Problem | StratMD Solution |
|---------|------------------|
| "What am I supposed to be doing?" | Intent section |
| "Should I do X?" | Check Constraints |
| "Didn't we already decide this?" | Check Decisions |
| "What if this assumption is wrong?" | Assumptions with confidence |
| "How do I know if I'm succeeding?" | Objectives |

The point isn't compliance — it's having a place for strategic memory that survives context death.