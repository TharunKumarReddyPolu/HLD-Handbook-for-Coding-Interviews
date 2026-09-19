# Real-Time Analytics in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Architecture Components](#architecture-components)
- [Implementation Strategies](#implementation-strategies)
- [Processing Patterns](#processing-patterns)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Real-time analytics involves processing and analyzing data as it arrives, providing immediate insights and actions.

### Key Benefits
1. **Immediate Insights**
2. **Quick Decision Making**
3. **Proactive Actions**
4. **Continuous Monitoring**
5. **Business Agility**

## Prerequisites & Related Topics

- Builds on: Stream Processing concepts, [Message Queues](../architecture/message-queues.md)
- Used in: [OLAP vs OLTP](olap-vs-oltp.md), [Monitoring](../system-basics/monitoring.md), Data Pipelines
- Techniques often combined: windowing, watermarks, materialized views, lambda/kappa patterns
- See also: [Data Warehousing](data-warehousing.md) — the batch sibling


## Pattern Recognition Guide

### 🎯 When to Use Real-Time Analytics

**Keywords in requirements**: "real-time", "streaming", "live dashboard", "seconds freshness", "clickstream", "fraud detection"
**Reach for this when**:
- Ops dashboards and alerting on live system metrics
- Fraud/anomaly detection where minutes cost money
- Live product analytics (funnels, active users now)
- Personalization features consuming recent behavior

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Stream + materialized views | continuous aggregates | the standard shape |
| OLAP engine on streaming ingestion | SQL over fresh data | ClickHouse/Doris style |
| Lambda (batch + speed) | reprocessing + low latency | complex, legacy-heavy |
| Kappa (stream only) | one path, replayable log | log-centric platforms |

### ❌ When NOT to Use

- Hourly freshness suffices — batch is simpler and cheaper
- Tiny data volumes — a scheduled query beats a stream system
- Exact global transactions across the stream — redesign the question


## Architecture Components

### 1. Data Ingestion
**How it works — stream ingestion:** producers append events to a durable log (Kafka-style) as they happen; the log decouples producers from consumers, absorbs bursts, and replays history to new consumers — the foundation everything downstream reads from.

### 2. Stream Processing
**How it works — stream processor:** events flow through operators (filter → enrich → aggregate) with state keyed by event attribute and checkpoints snapshotting that state — a failed node resumes from its last checkpoint, keeping aggregates correct across restarts.

## Implementation Strategies

### 1. Window Processing
**How it works — Window processor:** events are assigned to windows (tumbling, sliding, session) by event time with watermarks bounding lateness; the aggregate per window is what downstream consumers treat as the stream's "rows".

### 2. State Management
**How it works — State manager:** state is classified first — ephemeral (in memory), session (Redis), durable (database) — and each lives in the cheapest layer that meets its durability and latency needs; components stay restartable at any moment.

## Processing Patterns

### 1. Event Time Processing
**How it works — event-time processing:** aggregates are computed by the time embedded in each event, not the time it arrives — watermarks signal when a window is complete, and late events within the allowed bound update their window; without event time, network jitter would silently scramble your per-minute metrics.

### 2. Fault Tolerance
**How it works — Fault tolerance:** design for component death as the normal case — replicas for state, timeouts and retries for calls, bulkheads so one failure can't cascade, and graceful degradation (serve cached, drop features) when dependencies are gone.

## Common Use Cases

### 1. Real-time Dashboard
**How it works — Dashboard processor:** dashboards read pre-aggregated rollups, not raw events — a scheduled/materialized layer computes per-minute/per-hour series once, so rendering is a lookup and the warehouse is shielded from every refresh.

### 2. Anomaly Detection
**How it works — Anomaly detector:** baseline the metric's normal range (seasonality included), then flag points outside it; anomalies route to humans with context, because the detector finds the *when*, not the *why*.

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| True streaming | Lowest latency, continuous insight | Highest complexity and cost | Fraud detection, alerting |
| Micro-batching | Simpler, efficient, near-real-time | Latency floor (seconds-minutes) | Dashboards, most analytics |
| Event-time processing | Correct results for late/out-of-order data | Watermark tuning, delayed results | Accurate time-based analytics |
| Processing-time | Simple, immediate | Wrong answers for late events | Rough operational counters |

**Latency vs cost/complexity:** Every reduction in latency multiplies infrastructure sophistication — pay only where the business decision is time-critical.

**Correctness vs immediacy:** Waiting for watermarks yields complete windows; skipping them gives instant but approximate results.

**State size vs query speed:** Keeping more state (windows, joins) speeds answers but increases recovery time and memory cost.

> **⚠️ When NOT to stream:** dashboards tolerating minutes of delay (micro-batching is cheaper and simpler), low-volume data where a scheduled query suffices, and metrics computable at query time — reserve true streaming for decisions that lose value in seconds.

## Edge Cases to Consider

- Late events — accept within bounds, update windows, reconcile downstream
- Out-of-order across partitions — key by entity, watermark per key
- Reprocessing history — replay from the log with the same code
- Skew on hot entities (top creator) — pre-aggregate or split


## Common Pitfalls

1. Processing time treated as event time — jitter scrambles metrics
2. Unbounded state — every windowed aggregation needs retention
3. Alerts on raw events instead of smoothed aggregates
4. No reconciliation against batch truth


## FAQ

**Q1: How real is "real-time"?**

A: Define the SLO: most dashboards need seconds-to-a-minute freshness; fraud needs sub-second paths. Engineering effort scales inversely with the latency budget.

**Q2: Lambda or kappa?**

A: Kappa (one stream path, replayable log) where the log can carry reprocessing; lambda where heavy batch logic already exists and cannot move yet.

**Q3: Where do aggregates live?**

A: In a serving layer built for point reads of precomputed results — materialized views or an OLAP store — never recomputed per dashboard refresh.

## Interview Tips

### 1. Key Considerations
- Data freshness
- Processing latency
- State management
- Fault tolerance
- Scalability

### 2. Common Questions
1. How to handle late data?
2. How to ensure exactly-once processing?
3. How to scale real-time processing?
4. How to handle state in distributed processing?

### 3. Best Practices
- Use appropriate windows
- Implement proper checkpointing
- Monitor processing latency
- Handle late data
- Plan for failures

## Advanced Topics

1. Exactly-once sinks via idempotent/transactional writes
2. Sessionization and funnel analytics on streams
3. Tiered storage: hot stream, warm OLAP, cold lake
4. Streaming feature computation for online ML


## Further Reading
- [Apache Flink Documentation](https://flink.apache.org/docs/stable/)
- [Streaming Systems](https://www.oreilly.com/library/view/streaming-systems/9781491983867/)
- [Real-time Analytics](https://www.confluent.io/blog/real-time-analytics-with-kafka/)

