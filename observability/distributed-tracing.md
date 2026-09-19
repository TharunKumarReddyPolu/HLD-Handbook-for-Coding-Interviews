# Distributed Tracing in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Core Concepts](#core-concepts)
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

Distributed tracing provides visibility into request flows across distributed systems.

### Key Benefits
1. **Request Flow Visibility**
2. **Performance Analysis**
3. **Bottleneck Detection**
4. **Error Tracking**
5. **Service Dependencies**

## Prerequisites & Related Topics

- Builds on: [Logging](logging-practices.md), [Metrics](metrics.md)
- Used in: [Microservices](../scalability/microservices.md), [Debug Strategies](debug-strategies.md), [Performance Monitoring](performance-monitoring.md)
- Techniques often combined: context propagation (W3C traceparent), tail-based sampling, exemplars
- See also: [OpenTelemetry](https://opentelemetry.io/) — the vendor-neutral standard


## Pattern Recognition Guide

### 🎯 When to Use Distributed Tracing

**Keywords in requirements**: "trace", "span", "latency attribution", "which service is slow", "request journey", "propagation"
**Reach for this when**:
- Latency breakdown across service hops and external calls
- Finding N+1 patterns and accidental fan-outs
- Post-deploy comparison of the same request shape
- Dependency mapping from real traffic, not diagrams

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Head sampling | decide at request start | cheap, uniform |
| Tail sampling | decide after completion | keep all errors/slow ones |
| Auto-instrumentation | framework spans for free | the 80% base |
| Manual spans | domain-meaningful children | the critical 20% |

### ❌ When NOT to Use

- 100% tracing at high volume — cost and cardinality explode; sample
- Tracing as a replacement for logs — spans are not free-text debugging
- Solo-service tracing — value comes from propagation across hops


## Core Concepts

### 1. Trace Context
**How it works — Trace context:** a standard header (W3C traceparent) carries trace ID, span ID, and sampling flags across services and queues — any component that drops it breaks the chain, which is why propagation belongs in libraries, not application code.

### 2. Span Management
**How it works — Span manager:** each operation records a span (start, duration, tags, parent) and children nest under it; the tree of spans per trace ID reconstructs the request's path and its time breakdown across services.

## Implementation Strategies

### 1. Middleware Integration
**How it works — Tracing middleware:** Build once, promote the same artifact through environments, and shift traffic gradually — canary or blue/green — so a bad release is rolled back by a routing change, not a rebuild.

### 2. Service Instrumentation
**How it works — Traced service:** each service auto-instruments its framework (server spans) and explicitly instruments expensive calls (DB, external APIs) with meaningful tags — traces are only as good as the annotations on them.

## Analysis Patterns

### 1. Trace Analysis
**How it works — Trace analyzer:** aggregate traces into service-level views — which dependency owns the p99, which call fan-out multiplies latency — and diff the top slow traces week over week to catch regressions early.

### 2. Performance Analysis
**How it works — Performance analyzer:** take the p95 request, walk its trace top-down (total → slowest span → its slowest child), and fix the deepest expensive hop first — averages lie, distributions and traces don't.

## Common Use Cases

### 1. Request Tracing
**How it works — Request tracer:** a trace ID is minted at the edge and propagated through every hop's headers; each service records a span (start, duration, tags), and the assembled trace shows the request's real path and time split.

### 2. Database Tracing
**How it works — Database tracer:** slow query logs, plan stats, and wait events attribute database time to specific queries; tracing at this layer answers "which query, which plan, which index" — the level where fixes actually happen.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| 100% tracing | Complete visibility | Cost and cardinality explosion | Tiny traffic or debugging bursts |
| Head-based sampling | Constant overhead, cheap | May drop the interesting traces | High-volume healthy paths |
| Tail-based sampling | Keeps slow/error traces | Buffering cost, complexity | User-facing request paths |
| Always trace errors | Never miss failures | Requires dynamic sampling logic | All production systems |

**Coverage vs cost:** Trace data is among the most expensive telemetry; sampling policy decides your bill more than your vendor does.

**Latency attribution vs overhead:** Span-per-hop precision finds bottlenecks but each span costs CPU and network — instrument boundaries first.

**Context propagation coupling:** Full tracing requires consistent context headers across every service; retrofitting partial coverage yields confusing partial traces.

> **⚠️ When NOT to trace every request:** high-volume healthy paths where head-based sampling captures the shape at 1% of the cost, and systems that can't propagate context consistently — partial tracing yields misleading partial pictures.

## Edge Cases to Consider

- Missing spans from un-instrumented clients (queue consumers, cron)
- Async handoffs — context must ride message headers, not threads
- Clock skew between hosts — trust durations and causality
- High-cardinality span tags blowing storage budgets


## Common Pitfalls

1. Propagation gaps that orphan subtraces
2. Spans named after HTTP paths only — no domain meaning
3. Sampling that drops the exact failing trace you need
4. Traces never queried — collecting cost without debugging value


## FAQ

**Q1: Traces or logs?**

A: Traces for structure (which hop, how long), logs for detail (what exactly happened inside). The trace ID in every log line joins them.

**Q2: What sampling rate should I pick?**

A: Head-sample base traffic at 1–10%, keep 100% of errors and slow requests (tail-based), and raise rates during incidents.

**Q3: How do traces cross queues?**

A: Context travels in message headers — producers inject, consumers extract. Break the chain and you get orphan spans that explain nothing.

## Interview Tips

### 1. Key Considerations
- Sampling strategy
- Data retention
- Performance impact
- Privacy concerns
- Integration points

### 2. Common Questions
1. How do you implement distributed tracing?
2. What sampling strategies do you use?
3. How do you analyze trace data?
4. How do you handle trace context propagation?

### 3. Best Practices
- Use consistent naming
- Add relevant attributes
- Implement proper sampling
- Consider data volume
- Monitor trace system

## Advanced Topics

1. Tail-based sampling policies (errors, latency outliers, rare routes)
2. Service diagrams derived from live traces
3. Trace-to-metric exemplars for investigating histogram tails
4. Trace-based testing in CI for critical paths


## Further Reading
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Jaeger Tracing](https://www.jaegertracing.io/docs/)
- [Distributed Tracing in Practice](https://www.oreilly.com/library/view/distributed-tracing-in/9781492056621/)

