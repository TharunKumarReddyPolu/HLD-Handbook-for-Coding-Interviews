# Chaos Engineering in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Chaos Principles](#chaos-principles)
- [Implementation Strategies](#implementation-strategies)
- [Experiment Types](#experiment-types)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Chaos Engineering is the discipline of experimenting on a system to build confidence in its capability to withstand turbulent conditions in production.

### Key Benefits
1. **System Resilience**
2. **Failure Detection**
3. **Recovery Validation**
4. **Team Readiness**
5. **Risk Mitigation**

## Prerequisites & Related Topics

- Builds on: [Circuit Breaker](../architecture/circuit-breaker.md), [Monitoring](../system-basics/monitoring.md)
- Used in: High Availability, [Load Testing](load-testing.md), [Multi-Cloud](../cloud-native/multi-cloud.md)
- Techniques often combined: steady-state hypotheses, blast-radius caps, auto-rollback, game days
- See also: [Principles of Chaos](https://principlesofchaos.org/) — the founding definition


## Pattern Recognition Guide

### 🎯 When to Use Chaos Engineering

**Keywords in requirements**: "chaos", "fault injection", "game day", "steady state", "resilience drill", "failure testing"
**Reach for this when**:
- Verifying failover actually fails over (zones, primaries, caches)
- Validating breaker/fallback paths trigger correctly
- Testing autoscaling and self-healing under pod/instance loss
- Game days training on-call for real incidents

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Infrastructure chaos | instance, disk, network faults | platform validation |
| Application chaos | exceptions, latency, wrong responses | dependency resilience |
| Game days | supervised realistic scenarios | team readiness |
| Continuous chaos | scheduled small experiments | mature, observable systems |

### ❌ When NOT to Use

- Unobservable systems — injecting failure without metrics is an outage with extra steps
- No rollback path — every experiment needs an abort switch
- Peak business hours for first experiments — start in staging or low traffic


## Chaos Principles

### 1. Steady State Hypothesis
**How it works — Steady state monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Real-world Events
**How it works — chaos experiments:** define the steady state (p99 latency, error rate), inject one fault (kill a pod, add 100 ms latency, blackhole a dependency), and verify the steady state holds. If it doesn't, you found a resilience gap before production did.

## Implementation Strategies

### 1. Experiment Design
**How it works — Chaos experiment:** Resolve the flag/config for this request from the central store (with a local cache for latency and a safe default if the store is down), then act on the resolved value — changes take effect without deploys.

### 2. Safety Mechanisms
**How it works — Safety controller:** chaos experiments run with a safety layer — a scoped target list, an automatic abort when business metrics breach, and a hard runtime cap — the blast radius is designed, never assumed.

## Experiment Types

### 1. Infrastructure Chaos
**How it works — Infrastructure chaos:** terminate instances, fill disks, and degrade networks on schedule in staging — verify that orchestrators reschedule, data survives, and alerts fire before any of it happens in production.

### 2. Application Chaos
**How it works — Application chaos:** inject failures at the application layer — unhandled exceptions, dependency timeouts, malformed responses — and verify the app degrades per design instead of crashing.

## Common Use Cases

### 1. Network Failure Testing
**How it works — Network chaos:** inject latency, packet loss, and partitions between services and watch the timeouts, retries, and breakers do their job — if a 200 ms delay causes an outage, the dependency budget was fiction.

### 2. Resource Exhaustion
**How it works — Resource chaos:** starve the system on purpose — CPU limits, memory pressure, disk exhaustion — and verify requests fail gracefully (shed load, degrade features) instead of OOM-killing or livelocking.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Production experiments | Real traffic, real findings | Blast radius if runcarelessly | Mature systems with rollback |
| Staging chaos | Safer, freer to explore | Environment drift weakens conclusions | Early adoption of chaos practice |
| Broad blast radius | Finds systemic weaknesses | Bigger user impact on surprise | GameDays with war rooms |
| Small blast radius | Minimal user risk | May miss compound failure modes | Routine automated experiments |

**Realism vs risk:** Chaos in production finds truth that staging cannot, but demands abort switches, steady-state metrics, and clear ownership.

**Automation vs control:** Scheduled automated experiments build resilience muscle; manual GameDays build human muscle — both matter.

**Frequency vs fatigue:** Regular small experiments normalize failure handling; excessive chaos breeds alarm fatigue.

> **⚠️ When NOT to run production chaos:** systems without steady-state metrics, automated rollback, and clear abort ownership — injecting failure into an unobservable system is just an outage with extra steps. Start in staging.

## Edge Cases to Consider

- Experiment coinciding with a real incident — runbooks must pause chaos
- Cascading effects beyond the injected scope — blast-radius design failed
- Non-idempotent systems reacting oddly to replays
- Observability gaps discovered mid-experiment — that IS a finding


## Common Pitfalls

1. Chaos theater — injections without hypotheses or measurements
2. Running experiments without stakeholder awareness
3. Skipping staging even for first production experiments
4. No findings loop — the same resilience gap re-tested forever


## FAQ

**Q1: Chaos engineering vs testing?**

A: Functional tests verify correct behavior on good inputs; chaos verifies survival under bad conditions. It complements tests by probing the operational properties tests cannot.

**Q2: What is a steady-state hypothesis?**

A: A measurable definition of "still fine" — e.g., checkout p99 under 400 ms and error rate under 0.1%. If the hypothesis breaks during injection, you found a resilience gap.

**Q3: How do we start safely?**

A: Start in staging with one hypothesis, an abort metric, and a small blast radius; graduate to production low-traffic windows only after observability and rollback are proven.

## Interview Tips

### 1. Key Considerations
- Experiment scope
- Safety measures
- Monitoring setup
- Rollback procedures
- Team communication

### 2. Common Questions
1. How to design chaos experiments?
2. How to ensure safety?
3. What metrics to monitor?
4. How to handle failures?

### 3. Best Practices
- Start small
- Define clear hypotheses
- Monitor everything
- Have rollback plans
- Document learnings

## Advanced Topics

1. Automated canary + chaos in deploy pipelines
2. Chaos meshes coordinating network/IO/pod faults together
3. Formal game-day formats with observers and timelines
4. Quantified resilience: experiment results as tracked metrics


## Further Reading
- [Principles of Chaos Engineering](https://principlesofchaos.org/)
- [Netflix Chaos Engineering](https://netflixtechblog.com/tagged/chaos-engineering)
- [Chaos Engineering Handbook](https://www.oreilly.com/library/view/chaos-engineering/9781492043850/)

