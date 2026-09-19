# Data Quality in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Quality Dimensions](#quality-dimensions)
- [Validation Strategies](#validation-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Data quality and validation ensure the reliability, accuracy, and consistency of data throughout its lifecycle.

### Key Benefits
1. **Reliable Analytics**
2. **Better Decision Making**
3. **Reduced Errors**
4. **Consistent Processing**
5. **Regulatory Compliance**

## Prerequisites & Related Topics

- Builds on: Data Pipelines concepts, schema design
- Used in: [ETL vs ELT](etl-vs-elt.md), [Real-Time Analytics](real-time-analytics.md), [Data Warehousing](data-warehousing.md)
- Techniques often combined: data contracts, quarantine zones, expectation suites (dbt/Great Expectations)
- See also: [Observability](../observability/metrics.md) — pipeline metrics are data-quality signals


## Pattern Recognition Guide

### 🎯 When to Use Data Quality

**Keywords in requirements**: "data validation", "schema change", "nulls", "duplicate", "freshness", "reconciliation", "trust the dashboard"
**Reach for this when**:
- Pipelines feeding dashboards where silent corruption is costly
- Multi-team data platforms needing contracts at boundaries
- ML feature pipelines where drift silently degrades models
- Compliance regimes requiring lineage and accuracy evidence

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Schema validation | type/structure drift | every ingestion boundary |
| Freshness SLO | staleness thresholds | serving + dashboards |
| Reconciliation | counts/sums vs source | financial data |
| Distribution checks | null rates, cardinality drift | feature pipelines |

### ❌ When NOT to Use

- Validating everything everywhere — gate the boundaries that matter
- Quarantining without alerting — bad data rots in silence
- Perfect data before launch — pragmatic gates on the critical path first


## Quality Dimensions

### 1. Data Accuracy
**How it works — Accuracy validator:** compare model output against a held-out labeled set on every training run; accuracy, precision/recall, and drift metrics gate promotion — a model that regressed never ships.

### 2. Data Completeness
**How it works — Completeness checker:** every pipeline run asserts expected row counts, partition coverage, and source-vs-destination reconciliation before publishing — missing data fails loudly instead of quietly producing a wrong dashboard.

## Validation Strategies

### 1. Schema Validation
**How it works — Schema validator:** Define the shape from the access patterns first, apply the change incrementally with a rollback path, and verify both old and new readers work during the transition window.

### 2. Business Rules
**How it works — Business rule validator:** rules live in a policy layer separate from the request path; each request is evaluated against them (eligibility, limits, compliance) and rejections cite the violated rule — auditable and changeable without deploys.

## Implementation Patterns

### 1. Data Profiling
**How it works — data profiling:** before trusting a dataset, compute column stats (null rate, cardinality, min/max, value distributions) and diff them against the last run — sudden drift flags upstream schema changes or broken producers before dashboards lie.

### 2. Quality Monitoring
**How it works — Quality monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Common Use Cases

### 1. ETL Validation
**How it works — Etlvalidator:** each pipeline stage asserts its contract — row counts match source, no nulls in key columns, referential integrity holds — and failed validations quarantine the batch instead of loading it.

### 2. Data Pipeline Quality
**How it works — pipeline quality gates:** every pipeline run asserts expectations before publishing — row counts reconcile with source, key columns are non-null, freshness is within SLA — and a failed gate quarantines the batch and alerts, so bad data stops at the boundary instead of surfacing in a dashboard.

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| Validate at ingestion | Catch errors early, clean downstream | Ingest latency, pipeline coupling | Structured critical feeds |
| Validate at consumption | Flexible, per-use-case rules | Bad data spreads before detection | Exploratory/analytics data |
| Strict blocking rules | Guarantees quality | Data loss on false positives | Financial/regulated data |
| Quarantine + alerting | No data loss, human review | Delayed availability, triage cost | Most production pipelines |

**Accuracy vs completeness:** Rejecting suspicious rows raises accuracy but loses volume; quarantine preserves data but delays it.

**Detection cost vs incident cost:** Heavy validation spends compute continuously; skipping it spends incident time episodically — rare but expensive.

**Manual review vs automation:** Human-in-the-loop handles edge cases well but does not scale; automate the common, escalate the rare.

> **⚠️ When NOT to validate at ingestion:** exploratory pipelines where schema rigidity blocks new sources, and late-arriving reference data unavailable upstream — move checks downstream, but add contracts before data feeds billing.

## Edge Cases to Consider

- Late-arriving data inside watermark bounds — accept, count, reconcile
- Backfills overwriting corrected rows — idempotent, versioned writes
- Silent cardinality drop (empty partition) — completeness checks
- Encoding/locale drift breaking joins after a producer upgrade


## Common Pitfalls

1. Trust-then-validate instead of validate-then-publish
2. Checks only on row counts — values drift while counts stay right
3. No ownership of quality gates — everyone assumes someone else
4. Dashboards without freshness stamps


## FAQ

**Q1: Where should quality gates live?**

A: At every boundary where ownership changes — ingestion, transformation outputs, serving tables. The producing team publishes contracts; the platform enforces them.

**Q2: Schema changed and nothing broke — how?**

A: Additive columns with defaults, never dropped/rename-in-place; contract versioning plus quarantine for violations keeps consumers stable.

**Q3: How do you measure "quality"?**

A: A handful of SLIs: freshness lag, completeness vs source, validation pass rate, and incident count per table. Track them like service SLOs.

## Interview Tips

### 1. Key Considerations
- Data quality dimensions
- Validation strategies
- Monitoring approach
- Error handling
- Scalability

### 2. Common Questions
1. How to ensure data quality?
2. How to handle data anomalies?
3. How to scale validation?
4. How to monitor quality?

### 3. Best Practices
- Define clear metrics
- Implement automated checks
- Monitor continuously
- Document rules
- Plan for failures

## Advanced Topics

1. Expectation suites wired into CI for transformation code
2. Anomaly detection on table metrics (volume, null rate)
3. Column-level lineage automated from query logs
4. Data contracts enforced at the broker (schema registry)


## Further Reading
- [Data Quality Guide](https://www.dqglobal.com/data-quality-guide/)
- [Data Validation Patterns](https://www.oreilly.com/library/view/data-quality/9780128166682/)
- [Data Quality Best Practices](https://www.informatica.com/resources/articles/data-quality-best-practices.html)

