# Alerting in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Alert Design](#alert-design)
- [Implementation Patterns](#implementation-patterns)
- [Alert Management](#alert-management)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Effective alerting strategies help teams identify and respond to system issues proactively.

### Key Benefits
1. **Early Detection**
2. **Reduced Downtime**
3. **Automated Response**
4. **Issue Prioritization**
5. **Team Efficiency**

## Prerequisites & Related Topics

- Builds on: [Metrics](metrics.md), SLO concepts
- Used in: [Monitoring](../system-basics/monitoring.md), [Debug Strategies](debug-strategies.md), [Chaos Engineering](../testing/chaos-engineering.md)
- Techniques often combined: multi-window burn alerts, routing trees, dedup/grouping, runbooks
- See also: [SLO guidance](https://sre.google/sre-book/alerting-on-slos/) — Google SRE's alerting chapters


## Pattern Recognition Guide

### 🎯 When to Use Alerting

**Keywords in requirements**: "alert", "page", "on-call", "threshold", "burn rate", "runbook", "noise"
**Reach for this when**:
- SLO burn-rate paging tied to user impact
- Infrastructure saturation warnings as tickets, not pages
- Anomaly alerts for seasonal metrics
- Synthetic checks catching silent failures on critical paths

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Static threshold | stable metrics with known bounds | disk, queue depth |
| Burn-rate (multi-window) | SLO pacing | latency/error SLOs |
| Anomaly detection | seasonal/spiky series | traffic, revenue |
| Synthetic probes | black-box path checks | login, checkout flows |

### ❌ When NOT to Use

- Alerting on every metric — pages must map to action
- CPU alerts as proxies for user pain — alert on SLIs instead
- Email-only critical alerts — paging needs acknowledgment


## Alert Design

### 1. Alert Definition
**How it works — Alert definition:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Threshold Configuration
**How it works — Threshold manager:** alert thresholds come from measured baselines (normal range, seasonality) and are set to fire on deviation that matters — static thresholds for stable metrics, burn-rate or anomaly alerts for spiky ones.

## Implementation Patterns

### 1. Alert Routing
**How it works — Alert router:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Alert Correlation
**How it works — Alert correlator:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Alert Management

### 1. Alert Lifecycle
**How it works — Alert lifecycle:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Alert Aggregation
**How it works — Alert aggregator:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Common Use Cases

### 1. Service Health Monitoring
**How it works — Service monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

### 2. Infrastructure Alerts
**How it works — Infrastructure alerts:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| More alerts | Fewer missed incidents | Fatigue, missed real signals | Narrow, high-severity gaps |
| Fewer, SLO-based alerts | Pages only on user impact | Needs error budgets and buy-in | Production services |
| Low thresholds | Early warning | Noise, false positives | Critical canaries |
| High thresholds | Quiet on-call | Late detection | Well-understood, recoverable issues |

**Precision vs recall:** Every alert policy balances catching real incidents against paging people for noise; track page-to-action ratio as the health metric.

**Symptom vs cause alerts:** Paging on user-facing symptoms (latency, errors) aligns with impact; cause-based alerts (CPU, disk) belong as tickets, not pages.

**Escalation depth vs response speed:** Deep escalation chains protect sleep but delay response; tune with real incident data, not policy defaults.

> **⚠️ When NOT to alert on causes:** CPU, memory, and disk alerts that page humans for symptoms users never feel — demote them to tickets or dashboards, and page only on user-facing SLO burn.

## Edge Cases to Consider

- Low-traffic services — burn rates too slow; absolute floors help
- Flapping alerts — hold-for-duration and multi-window confirmation
- Cascade storms — dependency-aware grouping and suppression
- Alert on deploy windows — automatic suppression windows


## Common Pitfalls

1. Alert fatigue from noisy thresholds — trust dies, pages get ignored
2. No runbook links — responders start from zero
3. Alerts owned by nobody — delete or assign
4. Symptom and cause alerts both paging — dedupe to symptoms


## FAQ

**Q1: What makes an alert good?**

A: Actionable now, tied to user impact, with a runbook and an owner. If the response to a page is "check tomorrow", it should be a ticket.

**Q2: Threshold or burn rate?**

A: Thresholds for hard resource limits; burn rates for SLOs because they account for traffic and time-to-exhaustion, paging only when the budget is genuinely at risk.

**Q3: How do I reduce noise without missing incidents?**

A: Symptom-based paging, multi-window confirmation to kill flaps, grouping for cascades, and quarterly deletion of alerts that never led to action.

## Interview Tips

### 1. Key Considerations
- Alert fatigue
- Priority levels
- Response automation
- Escalation paths
- Alert correlation

### 2. Common Questions
1. How to reduce alert noise?
2. How to set thresholds?
3. How to handle escalations?
4. How to automate responses?

### 3. Best Practices
- Define clear severity levels
- Implement correlation
- Automate responses
- Document procedures
- Regular review

## Advanced Topics

1. Multi-window multi-burn-rate alerting (fast + slow windows)
2. Alert deduplication topologies (Alertmanager, Pagerduty Event Orchestration)
3. Automated diagnostics attached to pages (traces, recent deploys)
4. Error-budget policy gates on feature releases


## Further Reading
- [Google SRE Book - Alerting](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Alerting Best Practices](https://docs.datadoghq.com/monitors/guide/monitor-best-practices/)
- [PagerDuty Incident Response](https://response.pagerduty.com/)

