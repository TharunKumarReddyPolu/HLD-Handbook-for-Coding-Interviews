# Edge Computing in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Architecture Components](#architecture-components)
- [Implementation Patterns](#implementation-patterns)
- [Data Management](#data-management)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Edge computing brings computation and data storage closer to the location where it is needed, improving response times and saving bandwidth.

### Key Benefits
1. **Low Latency**
2. **Bandwidth Efficiency**
3. **Data Privacy**
4. **Reliability**
5. **Autonomous Operation**

## Prerequisites & Related Topics

- Builds on: CDN & Content Delivery, [Caching](../system-basics/caching.md)
- Used in: [IoT Architecture](iot-architecture.md), [Jamstack](#), [Real-Time Analytics](../data-engineering/real-time-analytics.md)
- Techniques often combined: edge KV stores, geo-routing, stale-while-revalidate, regional failover
- See also: [Cloudflare Workers docs](https://developers.cloudflare.com/workers/) — a representative edge runtime


## Pattern Recognition Guide

### 🎯 When to Use Edge Computing

**Keywords in requirements**: "edge", "latency", "compute at the edge", "regional", "near the user", "PoP", "edge functions"
**Reach for this when**:
- Personalization/AB assignment at the edge without origin hops
- API gateways and auth checks close to the user
- IoT/local processing where connectivity is unreliable
- Content transformation, image optimization, bot filtering

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Edge functions | stateless JS/WASM at PoPs | personalization, routing |
| Regional caches + KV | low-latency state near users | sessions, config |
| Local gateways (IoT) | processing at the site | industrial, retail |
| Hybrid origin+edge | edge filters, origin computes | the common architecture |

### ❌ When NOT to Use

- Strongly consistent transactional workloads — state at the edge is eventually consistent
- Heavy compute not latency-bound — central regions with cheap capacity win
- Everything to the edge — each edge run costs more per CPU than a dense region


## Architecture Components

### 1. Edge Node
**How it works — edge node:** compute deployed at CDN PoPs runs your code within ~50 ms of users; requests terminate at the nearest node, reading from regional caches/KV stores — origin is hit only for cache misses and writes, which is what moves latency from hundreds of ms to tens.

### 2. Edge Processing
**How it works — Edge processor:** Move the compute or content to the location nearest the user; the origin is hit only for misses and writes, and each region's data stays within its regulatory boundary.

## Implementation Patterns

### 1. Data Flow
**How it works — Data flow:** data moves through defined stages (ingest → process → store → serve) with each hop's contract explicit; the flow diagram is the shared language between producers and consumers.

### 2. Edge Orchestration
**How it works — Edge orchestrator:** Move the compute or content to the location nearest the user; the origin is hit only for misses and writes, and each region's data stays within its regulatory boundary.

## Data Management

### 1. Edge Storage
**How it works — Edge storage:** Move the compute or content to the location nearest the user; the origin is hit only for misses and writes, and each region's data stays within its regulatory boundary.

### 2. Data Synchronization
**How it works — Data synchronizer:** the synchronizer diffs source and target, applies changes in dependency order, and verifies counts after each batch — idempotent by design so an interrupted run resumes safely.

## Common Use Cases

### 1. Video Analytics
**How it works — Video analytics:** frames are sampled at the edge, lightweight models pre-filter (motion, objects), and only events — not raw video — stream upstream; the cloud runs the heavy re-analysis and long-term pattern mining.

### 2. Industrial IoT
**How it works — Industrial edge:** Move the compute or content to the location nearest the user; the origin is hit only for misses and writes, and each region's data stays within its regulatory boundary.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Processing at edge | Millisecond latency, bandwidth savings | Constrained compute, device management fleet | Real-time control, filtering |
| Central cloud processing | Full compute, single source of truth | Latency, egress bandwidth cost | Heavy analytics, training |
| Edge caching/data | Local speed, offline capability | Consistency and sync complexity | Content, read-heavy data |
| Hybrid (edge filter + cloud) | Bandwidth cut, cloud depth | Two-tier complexity | IoT at scale |

**Latency vs capability:** Edge devices trade compute power for proximity; partition work so latency-critical logic runs local and heavy jobs ship upward.

**Autonomy vs consistency:** Edge nodes operating during disconnection stay responsive and diverge; reconciliation adds sync complexity.

**Fleet management:** Thousands of edge nodes turn deployment, security patching, and monitoring into a first-class design problem.

> **⚠️ When NOT to compute at the edge:** latency-insensitive workloads (centralize for operability), stateful logic needing strong consistency with the core, and fleets too small to justify management overhead.

## Edge Cases to Consider

- Eventual consistency surprising session logic — design reads around it
- Per-region deployments drifting in version
- Observability at hundreds of PoPs — sampling and aggregation strategy
- Cross-region state writes costing more than origin round-trips


## Common Pitfalls

1. Moving the whole database to the edge — only hot, tolerant reads belong there
2. Ignoring regional cold starts for bursty traffic
3. Edge vendor lock-in on proprietary APIs
4. Testing only from the region where the team sits


## FAQ

**Q1: What belongs at the edge?**

A: Latency-sensitive, cacheable, or filterable work: routing, auth checks, personalization, content transforms. Consistent transactional writes stay central.

**Q2: Edge compute or CDN caching?**

A: Caching serves the same bytes cheaper; edge compute runs logic (revalidation, personalization) per request. Most platforms layer both under one config surface.

**Q3: How does edge state work?**

A: Eventually-consistent KV stores replicated globally: great for sessions/config at read latency, wrong for strong-consistency writes — route those to origin.

## Interview Tips

### 1. Key Considerations
- Processing location
- Data management
- Network reliability
- Resource constraints
- Security implementation

### 2. Common Questions
1. How to handle offline operation?
2. How to manage updates?
3. How to ensure security?
4. How to optimize resources?

### 3. Best Practices
- Local processing
- Data filtering
- Secure communication
- Resource monitoring
- Failure handling

## Advanced Topics

1. Edge-side A/B assignment with deterministic hashing
2. Streaming log shipping from PoPs with tail sampling
3. Tiered caching: edge → regional shield → origin
4. WASM runtimes for portable edge compute


## Further Reading
- [Edge Computing Guide](https://www.linux.com/news/state-edge-computing/)
- [Edge Architecture](https://docs.microsoft.com/azure/architecture/patterns/edge-computing)
- [Edge Security](https://www.nist.gov/publications/security-guidance-edge-computing)

