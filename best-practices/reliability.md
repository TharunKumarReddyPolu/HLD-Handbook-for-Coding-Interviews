# Reliability & High Availability in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Core Vocabulary](#core-vocabulary)
- [Building Blocks of High Availability](#building-blocks-of-high-availability)
- [Failure Isolation & Blast Radius](#failure-isolation--blast-radius)
- [Graceful Degradation](#graceful-degradation)
- [Operate for Reliability](#operate-for-reliability)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Real-World Examples](#real-world-examples)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Reliability is the property that a system does what users expect, *when* they expect it — even while parts of it are failing. **High availability** is its headline metric: the fraction of time the service actually works. Interviews probe whether you can design a system that fails *gracefully and partially*, instead of staying upright until one bad afternoon ends it. The core move is to stop thinking "it works" and start thinking "which failures can we survive, and how?"

## Prerequisites & Related Topics

- **Builds on**: [Distributed Systems](../system-basics/distributed-systems.md), [Replication](../scalability/replication.md)
- **Used in**: everything customer-facing; grounded in [Circuit Breakers](../architecture/circuit-breaker.md), [Load Balancing](../system-basics/load-balancing.md), [Replication](../scalability/replication.md)
- **Techniques often combined**: health checks, redundancy, chaos engineering, SLO-based alerting
- **See also**: [Chaos Engineering](../testing/chaos-engineering.md) — you *test* reliability by injecting failures; [Alerting](../observability/alerting.md) — reliability without detection is fiction

## Pattern Recognition Guide

### 🎯 When to Focus on High Availability

**Keywords in requirements**: "five nines", "99.9%", "SLA", "mission-critical", "redundant", "no single point of failure", "disaster recovery", "failover"
**Reach for this when**:
- Outages carry revenue, reputation, or safety costs
- The system is too big for one box or one datacenter
- You must survive a whole-zone or whole-region failure
- A single dependency can drag everything else down

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Active-active multisite | "no downtime ever", global users | payment/global services |
| Active-passive failover | "fast enough failover is fine" | most services |
| Graceful degradation | "better to be slow/partial than down" | feature-rich consumer apps |
| Cell/shard isolation | "one tenant can't take us all down" | multi-tenant platforms |

### ❌ When NOT to Over-Engineer

- Internal tools with a documented 4-hour recovery path — HA doubles cost for little gain
- Early-stage products needing iteration speed — design *for* HA, implement later
- Anything where a single dependency (a vendor API) already caps achievable uptime

## Core Vocabulary

| Term | Meaning | Interview framing |
|------|---------|-------------------|
| **Availability** | uptime fraction (e.g. 99.9% ≈ 8.8 h/yr down) | quote the number, then the dollar cost of each nine |
| **Reliability** | correctness of what's served, not just "up" | "available but wrong" still fails users |
| **MTBF / MTTR** | mean time between failures / to recover | uptime = MTBF / (MTBF + MTTR); *shrink MTTR* |
| **RTO / RPO** | recovery time objective / data loss window | DR planning starts here |
| **Nines table** | 99% = 3.65 d/yr · 99.9% = 8.76 h · 99.99% = 52.6 min · 99.999% = 5.26 min | each extra nine multiplies the engineering bill |
| **SPOF** | component whose failure takes everything down | the first thing to hunt on any diagram |
| **Blast radius** | how much breaks when a component does | shrink it with cells, bulkheads |

## Building Blocks of High Availability

### Redundancy & Failover
- **Active-passive**: standby takes over on failure — simpler, but failover is a whole-system event you must test (RTO minutes).
- **Active-active**: every site serves traffic on every request — needs replication-aware correctness ([Replication](../scalability/replication.md)) and rule out split-brain.
- **Multi-level**: N+1 within a rack, across zones, across regions. Balance desired 9s against cost (each additional zone roughly doubles infrastructure cost on the redundancy path).

### Health Checks & Detection
**How it works — detection layers:** process-level liveness (a restart loop with capped retries), service readiness ( LB stops sending traffic before users notice), and business-continuity checks (canary transactions *do* a real purchase/logout/checkout continuously). False "healthy" signals from shallow checks are a classic post-mortem headline.

### Circuit Breaking & Load Shedding
Fail fast rather than fail slow — [Circuit Breakers](../architecture/circuit-breaker.md) isolate a failing dependency before its latency infects the fleet, and load shedding prefers *some* users succeeding over *all* users timing out. A priority queue decides who gets shed (guests before paying users).

### Data Durability
- Replication with sync/semi-sync for the writes you can't lose
- Snapshots + WAL shipping for point-in-time recovery
- Backup *restoration drills* — an untested backup is Schrödinger's backup

## Failure Isolation & Blast Radius

- **Bulkheads**: partition resources (connection pools, thread pools, rate caps) so one exhaustion can't spread past the wall.
- **Cells / sharded blast radius**: split users across independent stacks; a bad deploy or an electricity event touches only one cell. Hyperscalers design around cells, not monolithic regions.
- **Idempotent, retried, budgeted**: retries with exponential backoff + jitter, capped retry budgets at every layer ([Distributed Systems](../system-basics/distributed-systems.md) — retry storms are an availability killer, not a resilience feature).

## Graceful Degradation

When full function is impossible, serve the *uncritical* subset:

- **Read-only mode** on a write-path failure (e-commerce shows a catalog, disables checkout)
- **Feature flags** flip non-critical features off to free capacity
- **Cached/stale responses** rather than nothing
- **Skip the enrichment** (skip recommendations, keep the purchase path)
- **Queue-and-reconcile**: accept work, process it later and idempotently

Interview gold: state *which* features die first and why. "Checkout stays, recommendations go" is a maturity signal more than "we add replicas."

## Operate for Reliability

- **SLOs with error budgets**: define good (p99 < 300 ms, error rate < 0.1%); when the budget's spent, feature deploys pause for stability work. Availability is managed as a *budget*, not an aspiration (see [Performance Monitoring](../observability/performance-monitoring.md)).
- **Blameless post-mortems**: every incident generates a contributing-factors analysis and tracked fixes; MTTR trends matter more than MTBF ideals.
- **Runbooks & automation**: what the on-call person does at 3 AM must be written down and, ideally, executable. Self-healing beats runbooks beats heroic humans.
- **Chaos drills**: inject the failure you fear — kill the primary with traffic flowing, black-hole a dependency mid-peak (see [Chaos Engineering](../testing/chaos-engineering.md)). Un-rehearsed failover is not failover, it's a lottery.

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| Active-passive | simpler, cheaper, clear recovery | failover gap + untested-standby risk | most services |
| Active-active | no failover event, geo-proximity serving | split-brain, conflict resolution cost | global, revenue-critical |
| Synchronous replication | zero data loss on failover | write latency bounds distance | financial writes |
| Async replication | fast writes everywhere | recovery may lose recent writes | most read paths |
| Over-provisioning | absorbs spikes, covers degradations | cost always paid | bursty profiles |
| Graceful degradation | partial service beats none | user confusion, partial states to maintain | consumer products |

**Redundancy vs complexity:** every redundant component introduces failover machinery, which becomes its own failure mode — the failover nobody tested is the outage nobody expected.

**Consistency vs availability during partition:** the [CAP theorem](../scalability/cap-theorem.md) lands here — decide *per operation*, not per system (sync writes for ledger, async for profile).

> **⚠️ When NOT to promise 99.99%:** if any single managed dependency (a payment gateway, an IdP) offers lower uptime, your number is capped by theirs; and if recovery requires undocumented human judgment, you don't have it — you have a hope.

## Edge Cases to Consider

- The failover that has never been tested (turns out the standby is long-stale)
- Gray failures — a node is "up" but slow, poisoning health-driven routing
- Cascade from retry storms after a dependency recovers
- Data corruption replicated everywhere before anyone noticed (why raw-zone immutable backups → RPO ≠ 0 story)
- Zonal dependency (DNS, auth, metadata) shared by both "independent" regions
- Deploy-induced failure — rollback faster than debugging; rollback is the highest-leverage reliability tool

## Common Pitfalls

1. Quote "five nines" without knowing the ops implications (~5 min/yr unplanned downtime budget)
2. HA components sharing a hidden SPOF (same power feed, same AZ, same cert issuer)
3. Failover never rehearsed — the DR plan is a document, not a capability
4. Auto-restart loops masking a deeper failure (crash-loop without backoff)
5. Raft/quorum misconfigured for even node counts or cross-WAN latency
6. Treating MTTR as the human's problem — automate detection + remediation

## FAQ

**Q1: How do you actually achieve "five nines"?**

A: You don't aim for 99.999 in one move. Decompose it: no SPOF within a region, multi-zone redundancy, tested regional failover, auto-remediation of common failures, SLO-based paging, and ruthless MTTR reduction. Each layer moves one 9 — and each 9 costs an order of magnitude more engineering.

**Q2: Active-passive or active-active?**

A: Start active-passive within a region (simpler, still handles most failure classes), then justify active-active only when either geographic latency (global users) or the cost of a failover gap (~minutes) is unacceptable.

**Q3: What's the first thing to fix on a new design?**

A: Walk the request path and mark every single point whose failure breaks the service — load balancer, primary DB, cache fleet, auth provider — then add redundancy or a degradation path for each. SPOF hunting is the highest-leverage first hour.

**Q4: Replication is the same as backup, right?**

A: No — replication protects against *hardware loss*; backups protect against *logical corruption* (bad delete, ransomware, bug). You need both, with independent restore testing.

## Interview Tips

### 1. Key Considerations

- Ninths required, and what each extra nine costs
- Where failover leaves data loss (RPO) and how long recovery takes (RTO)
- Dependency map: which third parties cap your uptime
- What degrades first, deliberately, under load

### 2. Common Questions

1. Design a payment system that survives a datacenter failure.
2. How would you take one AZ offline without user-visible impact?
3. How would you make a legacy single-node service more reliable?
4. Design a health-check and failover strategy for a global service.

### 3. One-Liner to Land

"No SPOFs, N+1 across zones, health-checked failover that's actually rehearsed, retry budgets everywhere, and a decision made *in advance* about which features die first under stress."

## Real-World Examples

- **Hyperscaler cells:** cloud providers partition huge fleets into independent cells with their own dependencies, so failures stay inside one cell's blast radius.
- **The Coinbase-style outage taxonomy:** most consumer outages trace to a dependency (DB connection exhaustion, a bad deploy, a DNS or auth provider incident), not a hardware crash — which is why degradation paths beat raw redundancy in cost per 9 added.
- **Terminals & payment rails (Visa-class):** dual datacenters with synchronous replication and standing rehearsal — accepted cost for around-zero data loss.

## Advanced Topics

1. Error budgets & SLO hierarchies across service dependencies
2. Cell-based architecture and bulkhead resource isolation
3. Chaos engineering program design (game days with hypotheses)
4. Meta-reliability: dependency vendors and their SLOs, contract design

## Further Reading

- [Google SRE Book — free online](https://sre.google/sre-book/table-of-contents/)
- [AWS Well-Architected: Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html)
- [Circuit Breaker pattern (Microsoft)](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)
- [Netflix Chaos Monkey origins](https://netflixtechblog.com/tags/chaos-engineering)
