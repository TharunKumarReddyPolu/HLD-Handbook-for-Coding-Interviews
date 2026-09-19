# A/B Testing in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Testing Framework](#testing-framework)
- [Implementation Strategies](#implementation-strategies)
- [Analysis Patterns](#analysis-patterns)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

A/B testing architecture enables controlled experiments to make data-driven decisions about features and changes.

### Key Benefits
1. **Data-Driven Decisions**
2. **Risk Mitigation**
3. **User Experience Optimization**
4. **Feature Validation**
5. **Continuous Improvement**

## Prerequisites & Related Topics

- Builds on: [Feature flags](../cloud-native/design-patterns.md), event analytics
- Used in: [Real-World Case Studies](../case-studies/e-commerce-platform.md), [Metrics](../observability/metrics.md), [Personalization](../modern-architectures/ai-ml-systems.md)
- Techniques often combined: deterministic bucketing, guardrail metrics, sequential testing, CUPED
- See also: [Trustworthy Online Controlled Experiments](https://experimentguide.com/) — the standard reference


## Pattern Recognition Guide

### 🎯 When to Use A/B Testing

**Keywords in requirements**: "A/B test", "experiment", "variant", "conversion lift", "bucketing", "statistical significance", "ramp"
**Reach for this when**:
- Validating feature impact on conversion, retention, latency
- Ramping risky changes gradually with kill switches
- Choosing between algorithm variants (ranking, pricing)
- Measuring infrastructure changes on user-facing metrics

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Standard A/B | two variants, one metric family | most decisions |
| Multi-armed bandit | adaptive allocation | high-cost traffic (pricing) |
| Interleaving | within-user comparison | ranking quality |
| Holdback | long-term control group | measuring permanent effects |

### ❌ When NOT to Use

- No pre-registered metric — post-hoc wins are noise
- Underpowered tests "running until significant" — peeking invalidates p-values
- Testing during extreme events (outages, holidays) without correction


## Testing Framework

### 1. Experiment Design
**How it works — Experiment designer:** Resolve the flag/config for this request from the central store (with a local cache for latency and a safe default if the store is down), then act on the resolved value — changes take effect without deploys.

### 2. Traffic Allocation
**How it works — Traffic allocator:** the flag layer assigns users to variants by deterministic hashing — stable across sessions and devices — while ramping percentages shift traffic gradually and an instant kill switch reverts everything.

## Implementation Strategies

### 1. Feature Flagging
**How it works — Feature flags:** Resolve the flag/config for this request from the central store (with a local cache for latency and a safe default if the store is down), then act on the resolved value — changes take effect without deploys.

### 2. Data Collection
**How it works — Data collector:** events are gathered at the boundary (SDK, agent, or pipeline tap), batched and shipped durably to the central store — collection is fire-and-forget so telemetry never blocks the hot path.

## Analysis Patterns

### 1. Statistical Analysis
**How it works — Statistical analyzer:** the pipeline computes distributions (not just means), percentiles for latency, and confidence intervals for rates — an average response time of 100 ms can hide a p99 of 3 s; distributions don't.

### 2. Results Interpretation
**How it works — Results interpreter:** statistical significance answers "is the difference real", not "is it useful" — report effect size in product terms, check guardrail metrics for regressions, and pre-registered metrics beat post-hoc storytelling.

## Common Use Cases

### 1. UI Optimization
**How it works — UI experiment:** Resolve the flag/config for this request from the central store (with a local cache for latency and a safe default if the store is down), then act on the resolved value — changes take effect without deploys.

### 2. Feature Rollout
**How it works — Feature rollout:** Build once, promote the same artifact through environments, and shift traffic gradually — canary or blue/green — so a bad release is rolled back by a routing change, not a rebuild.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| More experiments | Faster learning | Statistical power dilution, metric conflicts | High-traffic surfaces |
| Fewer experiments | Clean attribution | Slower iteration | Low-traffic products |
| Longer runtimes | Reliable significance | Slower decisions, cookie churn | Subtle metric changes |
| Short runtimes | Quick iteration | Peek-ahead bias, false positives | Obvious, large effects |

**Statistical rigor vs speed:** Stopping at significance early (peeking) inflates false positives; sequential testing fixes the math at the cost of complexity.

**Consistency vs freshness of assignment:** Sticky user assignment gives coherent experiences but complicates ramp-downs and logging out.

**Guardrail metrics vs velocity:** Extra guardrail checks catch collateral damage but add analysis overhead — pick a few globally, add locally.

> **⚠️ When NOT to A/B test:** traffic too small to reach significance (tests that run for months rot), obviously reversible fixes (crashes, typos), and safety-critical releases — use holdbacks or staged rollouts instead.

## Edge Cases to Consider

- Assignment leakage via shared accounts/devices
- Network effects (marketplace) contaminating control
- Multiple comparisons across many metrics — corrections required
- Sample ratio mismatch — bucketing bugs announce themselves here


## Common Pitfalls

1. Calling winners on day two — novelty and noise
2. Ignoring guardrails: conversion up, latency destroyed
3. Testing UI tweaks that cannot move the primary metric
4. No archive of results — the same experiments repeat yearly


## FAQ

**Q1: How long should an A/B test run?**

A: Full business cycles (usually 1–2 weeks minimum) sized by power analysis for the minimum detectable effect — not "until significance", which peeks and inflates false positives.

**Q2: What is sample ratio mismatch?**

A: When 50/50 assignment yields 51/49 at large n — a bucketing or logging bug. Always check SRM before reading any metric.

**Q3: Significant but tiny — do we ship?**

A: Compare effect size against guardrails, rollout risk, and maintenance cost. Statistical significance is the floor, not the decision.

## Interview Tips

### 1. Key Considerations
- Experiment design
- Statistical validity
- Data collection
- Analysis methods
- Implementation strategy

### 2. Common Questions
1. How to design A/B tests?
2. How to ensure validity?
3. How to analyze results?
4. How to handle edge cases?

### 3. Best Practices
- Clear hypothesis
- Proper randomization
- Adequate sample size
- Monitoring setup
- Documentation

## Advanced Topics

1. CUPED variance reduction for faster experiments
2. Sequential testing frameworks (always-valid p-values)
3. Switchback experiments for marketplaces
4. Heterogeneous effect analysis (per-segment lift)


## Further Reading
- [A/B Testing Guide](https://www.optimizely.com/optimization-glossary/ab-testing/)
- [Statistical Analysis](https://www.evanmiller.org/ab-testing/)
- [Experimentation at Scale](https://engineering.linkedin.com/blog/2020/experimentation-platform)

