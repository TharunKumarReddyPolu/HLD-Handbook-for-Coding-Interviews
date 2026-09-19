# System Design Guidelines 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [The Interview Design Framework](#the-interview-design-framework)
- [Core Design Principles](#core-design-principles)
- [Component Selection Guidelines](#component-selection-guidelines)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Design Review Checklist](#design-review-checklist)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

These guidelines distill the cross-cutting principles that apply to almost every system design interview answer. Use them as a framework for open-ended problems and as a checklist before you declare a design complete.

**Prerequisites:** [Distributed Systems Basics](../system-basics/distributed-systems.md), [Load Balancing](../system-basics/load-balancing.md), [Caching](../system-basics/caching.md), [CAP Theorem](../scalability/cap-theorem.md)

**Related topics:** [Performance Optimization](performance.md), [Security Best Practices](security.md), [Cost Optimization](cost.md), [Case Studies](../case-studies/README.md)

## Prerequisites & Related Topics

- Builds on: every [System Basics](../system-basics/README.md) and [Scalability](../scalability/README.md) topic
- Used in: [Interview Questions](../interview-questions/easy/README.md) at every level, real design reviews
- Techniques often combined: back-of-envelope math, component-selection tables, checklists
- See also: each category's README learning path for topic ordering


## Pattern Recognition Guide

### 🎯 When to Use System Design Guidelines 📌

**Keywords in requirements**: "design a system", "architecture", "how would you build", "design review", "trade-off", "45 minutes"
**Reach for this when**:
- Interview prep: the repeatable 45-minute structure
- Real design docs: requirements → components → trade-offs → risks
- Choosing components with a defensible selection process
- Reviewing others' designs with a consistent checklist

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Requirements-first | numbers before boxes | always |
| Request-path walk | deep-dive the hot path | interviews |
| Trade-off table | 2 candidates, 1 killed | component choices |
| Failure-mode pass | what breaks first | senior signal |

### ❌ When NOT to Use

- Diagram-first design — requirements before rectangles
- Listing every technology — breadth is not depth
- Choosing components without stating the rejected alternative


## The Interview Design Framework

A reliable structure for a 45-minute design interview:

```mermaid
graph TD
    A[1. Requirements - 5 min] --> B[2. Estimation - 5 min]
    B --> C[3. API + Data Model - 5 min]
    C --> D[4. High-Level Design - 10 min]
    D --> E[5. Deep Dives - 15 min]
    E --> F[6. Bottlenecks + Wrap-up - 5 min]
```

### 1. Clarify Requirements
- **Functional:** What are the core use cases? What is explicitly out of scope?
- **Non-functional:** Scale (users, QPS, data volume), latency targets, consistency vs availability needs
- State assumptions out loud — interviewers grade how you handle ambiguity

### 2. Estimate Scale (Back-of-Envelope)
- QPS: `DAU × requests/day ÷ 86,400`, then apply peak multiplier (2–3×)
- Storage: `records/day × record size × retention`
- Bandwidth, cache memory (usually ~20% of daily working set)
- These numbers drive every later decision (sharding, caching, storage choice)

### 3. Define API and Data Model
- Sketch the 3–5 core endpoints before drawing boxes
- Choose the primary data model (relational, document, key-value, graph) from access patterns

### 4. Draw the High-Level Design
- Client → [CDN] → LB → stateless services → datastore (+ cache, queue as needed)
- Keep it simple first; add components only when a requirement demands them

### 5. Deep-Dive on Interesting Components
- Pick the 1–2 hardest parts (feed ranking, id generation, delivery guarantees) — this is where senior signals come from

### 6. Address Bottlenecks and Wrap Up
- Single points of failure, hot keys, read/write scaling, monitoring
- Summarize trade-offs you accepted and what you'd change with more time

## Core Design Principles

### 1. Stateless Services, Stateful Data
Keep application servers stateless so they scale horizontally; push state to dedicated stores.

```mermaid
graph TD
    LB[Load Balancer] --> S1[App Server 1]
    LB --> S2[App Server 2]
    LB --> S3[App Server N]
    S1 --> DS[(Data Store)]
    S2 --> DS
    S3 --> DS
```

- Any server can handle any request → easy autoscaling, safe deploys, simple failover
- Session state belongs in Redis or a JWT, not server memory

### 2. Design for Failure
- Every component will fail; the design question is what happens when it does
- Prefer graceful degradation (serve stale cache) over hard failure
- Add timeouts, retries with backoff, and bulkheads at every network boundary

### 3. Loose Coupling
- Async (queues, events) between components that don't need immediate answers
- Synchronous only where the user is waiting and the call is on the critical path

### 4. Scale Reads Before Writes
Reads usually outnumber writes 10:1 to 100:1 — replicas, caches, and CDNs solve most scale problems before sharding becomes necessary.

### 5. Choose Boring Technology
- Proven components with known failure modes beat novel ones in interviews and in production
- Deferring complexity (e.g., staying on Postgres until it hurts) is a strength, not a weakness

## Component Selection Guidelines

| Problem | First Choice | Upgrade Path |
|---------|-------------|--------------|
| Read-heavy workload | Cache + read replicas | Multi-tier caching, CDN |
| Write-heavy workload | LSM-based store (Cassandra, DynamoDB) | Shard + queue buffering |
| Analytics over full scans | Columnar warehouse | Materialized views, streaming |
| Sparse/variable schema | Document store | JSONB in Postgres |
| Relationships/traversals | Relational (first) | Graph DB at scale |
| Large static files | Object storage + CDN | Tiered storage |
| Fan-out/notifications | Message queue / pub-sub | Event streaming (Kafka) |
| Global low latency | CDN + edge, geo-replication | Multi-region active-active |

### When NOT to Add a Component
- **No cache without evidence:** hit-rate math first; caches add invalidation complexity
- **No microservices without a reason:** Conway's law and team size matter; start modular-monolith
- **No multi-region until required:** it multiplies cost and consistency complexity
- **No event-driven everywhere:** debuggability drops; use it where decoupling pays

## Trade-offs

Every design decision is a trade-off — saying so explicitly is what separates strong candidates.

| Trade-off | Tension | Rule of Thumb |
|-----------|---------|---------------|
| Consistency vs Availability | CAP | Strong for payments/inventory; eventual for feeds/likes |
| Latency vs Durability | Sync vs async writes | Ack after replica for money; async for analytics |
| Normalization vs Denormalization | Write cost vs read speed | Normalize OLTP; denormalize for read paths |
| Cache freshness vs Hit rate | TTL length | Short TTL for money; long for public content |
| Provisioned vs Serverless | Cost vs control | Steady high load → provisioned; spiky → serverless |
| Build vs Buy | Differentiation vs speed | Buy commodity (auth, payments); build your edge |

**How to justify a choice:** name the requirement that forces the decision, list the two real candidates, and kill one with a concrete consequence — "we need 5-minute dashboard freshness, so ETL's batch window fails and ELT wins despite costlier queries." A choice without a rejected alternative reads as a guess in interviews.

> **⚠️ When NOT to follow the upgrade paths:** when requirements don't demand them — the "first choice" column is a floor, not a checklist; every component you add must trace back to a stated requirement.

## Edge Cases to Consider

- Ambiguous requirements — state assumptions out loud and proceed
- Interviewer pivots ("now make it global") — extend, do not restart
- Missing numbers mid-design — estimate, mark as assumption, continue
- Conflicting constraints — surface the conflict, choose with rationale


## Design Review Checklist

Run through this before presenting a finished design:

- [ ] Requirements (functional + non-functional) stated explicitly
- [ ] Back-of-envelope numbers computed and used to justify choices
- [ ] API surface and data model sketched
- [ ] Load balancing and health checks present
- [ ] Caching strategy defined (what, where, TTL, invalidation)
- [ ] Datastore chosen with reasons; read/write scaling addressed
- [ ] Single points of failure eliminated or mitigated
- [ ] Failure modes discussed (timeouts, retries, circuit breakers)
- [ ] Security basics: authN/authZ, encryption in transit and at rest
- [ ] Monitoring, alerting, and key metrics identified
- [ ] Bottlenecks and next 10× scaling step named
- [ ] Cost drivers acknowledged

## Common Pitfalls

1. **Solving scale you don't have** — over-engineering for imaginary users; interviewers probe simplicity
2. **Skipping requirements** — diving into boxes before asking what the system must do
3. **Technology name-dropping** — using Kafka/Redis/K8s without justifying them against the requirements
4. **Ignoring the data model** — access patterns should drive storage choice, not habit
5. **No failure discussion** — designs presented only on the happy path
6. **Forgetting operations** — no mention of monitoring, deploys, or on-call
7. **Silent trade-offs** — making choices without stating what you gave up

## FAQ

**Q1: What is the 45-minute structure?**

A: 5m requirements + estimates, 10m high-level design walking the request path, 15m deep-dive (database/consistency/hot component), 10m bottlenecks and failures, 5m wrap-up. Time-box each part.

**Q2: How much math is expected?**

A: Back-of-envelope fluency: QPS from DAU, storage from record size × growth, cache sizing from hit-rate targets — round numbers with stated assumptions, not precision.

**Q3: How do I show seniority in a design?**

A: State trade-offs unprompted, handle "what breaks first" without hesitation, and push back on requirements when they conflict — senior signal is judgment, not more boxes.

## Interview Tips

### 1. Communicate Framework, Not Just Answer
- Narrate your reasoning; check in: *"Does this direction make sense before I go deeper?"*
- When unsure, reason from first principles — interviewers grade the process

### 2. Drive the Conversation
- You own the whiteboard; propose the agenda, manage the clock
- Leave 5+ minutes for bottlenecks and wrap-up

### 3. Handle Pushback Gracefully
- Treat challenges as collaboration, not attack: *"Good point — under that requirement, X breaks because... so I'd..."*
- Admit unknowns, then reason approximately

### 4. Know Your Numbers
Memorize rough constants: memory is ~100× faster than SSD, SSD ~100× faster than network round-trips; a single app server handles ~1k RPS of medium requests. Estimates anchor credibility.

## Advanced Topics

1. Multi-region design patterns on demand
2. Cost-aware design with unit economics
3. Migration design: strangler figs and dual-writes
4. Designing for change: extension points over speculation


## Further Reading

- [System Design Primer](https://github.com/donnemartin/system-design-primer) - Interview framework and cheat sheets
- [Designing Data-Intensive Applications](https://www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable/dp/1449373321) - Chapters 1–9 for the fundamentals behind these guidelines
- [The Twelve-Factor App](https://12factor.net/) - Principles for stateless, deployable services
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) - Operationalized version of these principles
- [Latency Numbers Every Programmer Should Know](https://gist.github.com/jboner/2841832) - The constants behind back-of-envelope math
