# Metrics in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Types of Metrics](#types-of-metrics)
- [Collection Strategies](#collection-strategies)
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

Metrics provide quantitative measurements of system behavior and performance over time.

### Key Benefits
1. **Performance Monitoring**
2. **Capacity Planning**
3. **Anomaly Detection**
4. **SLA Tracking**
5. **Business Insights**

## Prerequisites & Related Topics

- Builds on: [Monitoring](../system-basics/monitoring.md) concepts
- Used in: [Alerting](alerting.md), [Performance Monitoring](performance-monitoring.md), [SLO burn alerts](alerting.md)
- Techniques often combined: RED/USE dashboards, histogram quantiles, exemplars, cardinality budgets
- See also: [Prometheus docs](https://prometheus.io/docs/practices/naming/) — naming and practice conventions


## Pattern Recognition Guide

### 🎯 When to Use Metrics

**Keywords in requirements**: "metric", "counter", "histogram", "p99", "dashboard", "time series", "rate"
**Reach for this when**:
- Per-service RED (rate, errors, duration) dashboards
- Resource saturation (USE) for capacity planning
- Business metrics as first-class signals (signups, orders)
- SLO burn-rate alerting inputs

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Counter | monotonically increasing events | requests, errors |
| Gauge | current value | queue depth, connections |
| Histogram | value distribution | latency, payload sizes |
| Summary | client-side quantiles | limited aggregation cases |

### ❌ When NOT to Use

- Unbounded label values (user IDs, URLs) — cardinality kills the store
- Metrics for per-event forensics — logs/traces answer that
- Averages only — distributions or nothing


## Types of Metrics

### 1. System Metrics
**How it works — System metrics collector:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Application Metrics
**How it works — Application metrics:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Collection Strategies

### 1. Push vs Pull
**How it works — Metrics exporter:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Aggregation
**How it works — Metrics aggregator:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Analysis Patterns

### 1. Time Series Analysis
**How it works — Time series analyzer:** metrics are stored as (timestamp, value) series with downsampling and retention tiers; queries aggregate over windows, and seasonality-aware baselines separate signal from daily rhythm.

### 2. Alerting
**How it works — Alert manager:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Common Use Cases

### 1. Performance Monitoring
**How it works — Performance monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Resource Usage
**How it works — Resource monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| High-resolution metrics | Sharp dashboards, tight detection | Storage and query cost | Critical service SLOs |
| Coarse aggregation | Cheap at scale | Hides spikes and percentiles | Non-critical background jobs |
| Pre-aggregated metrics | Fast dashboards | Loses per-instance drill-down | Executive/summary views |
| Raw event metrics | Full flexibility (histograms) | Highest cardinality cost | LATENCY analysis, SLO math |

**Cardinality vs insight:** Every label multiplies series count; unbounded labels (user IDs, URLs) can take down a metrics backend.

**Push vs pull:** Pull (scrape) self-regulates and health-checks; push reaches short-lived jobs and firewalled hosts but needs careful backpressure.

**Latency vs durability in collection:** In-memory agent buffers are fast and lossy; durable queues survive restarts at a cost.

> **⚠️ When NOT to increase resolution:** metrics that vary slowly (queue depth, config), non-critical jobs, and labels with unbounded cardinality (user IDs, URLs) — aggregate or histogram them before they take down the metrics store.

## Edge Cases to Consider

- Counter resets on restart — use rate() functions that handle resets
- Histogram buckets missing the tail — choose bounds from real data
- Label explosion after a feature flag goes wide
- Aggregation across instances hiding hot instances


## Common Pitfalls

1. p99 computed client-side where server aggregation is needed
2. Metrics named per-feature ad hoc — naming conventions decay
3. No unit in the name (seconds vs ms confusion)
4. Dashboards nobody trusts because two metrics disagree


## FAQ

**Q1: Histogram or summary?**

A: Histograms when aggregation across instances matters (most cases); summaries only for single-instance client-side quantiles.

**Q2: How do I control cardinality?**

A: Bounded label values (status codes, not URLs), drop per-user labels into exemplars/traces, and enforce per-team label budgets.

**Q3: Which metrics must every service expose?**

A: Rate, errors, and duration for its endpoints, plus saturation of its critical dependencies (DB pool, queue depth). Start RED, add USE.

## Interview Tips

### 1. Key Considerations
- Metric types selection
- Collection frequency
- Storage requirements
- Analysis methods
- Alert thresholds

### 2. Common Questions
1. How do you choose which metrics to collect?
2. How do you handle metric storage at scale?
3. What alerting strategies do you use?
4. How do you detect anomalies?

### 3. Best Practices
- Define clear objectives
- Use appropriate granularity
- Implement proper aggregation
- Set meaningful alerts
- Monitor the monitoring system

## Advanced Topics

1. Exemplars linking histogram spikes to traces
2. Cardinality budgets and enforcement per team
3. Native histograms for adaptive bucket resolution
4. Recording rules for precomputed SLO indicators


## Further Reading
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [Google SRE Book - Monitoring](https://sre.google/sre-book/monitoring-distributed-systems/)

