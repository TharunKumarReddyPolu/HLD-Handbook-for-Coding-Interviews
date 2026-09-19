# AI/ML Systems in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [System Components](#system-components)
- [Architecture Patterns](#architecture-patterns)
- [Implementation Strategies](#implementation-strategies)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

AI/ML system design focuses on building scalable and efficient architectures for machine learning applications.

### Key Components
1. **Data Pipeline**
2. **Model Training**
3. **Model Serving**
4. **Monitoring**
5. **Feedback Loop**

## Prerequisites & Related Topics

- Builds on: Data Pipelines, [Caching](../system-basics/caching.md), [Real-Time Analytics](../data-engineering/real-time-analytics.md)
- Used in: [Recommendation systems](#), [Feature stores](../data-engineering/data-quality.md), [A/B Testing](../testing/ab-testing.md)
- Techniques often combined: feature stores, model registries, canary model rollout, drift monitoring
- See also: [ML Test Score](https://research.google/pubs/pub46555/) — Google's ML production readiness rubric


## Pattern Recognition Guide

### 🎯 When to Use AI/ML Systems

**Keywords in requirements**: "model serving", "training pipeline", "feature store", "inference latency", "drift", "GPU", "batch vs real-time"
**Reach for this when**:
- Recommendations/ranking served with p99 latency budgets
- Fraud/anomaly scoring inline on transaction paths
- Batch scoring for offline intelligence (churn, forecasts)
- RAG/LLM features with retrieval, guardrails, and cost controls

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Online inference | low-latency scoring per request | fraud, ranking |
| Batch inference | precomputed scores | lists, digests |
| Streaming features | fresh signals within seconds | dynamic personalization |
| LLM serving | token streaming, retrieval, cost caps | assistant-style features |

### ❌ When NOT to Use

- Model before data quality — garbage features guarantee garbage predictions
- Real-time serving when daily batch suffices — latency tiers cost differently
- GPU fleets for models that fit CPUs — measure before scaling hardware


## System Components

### 1. Data Pipeline
**How it works — ML data pipeline:** raw data → validation (schema + drift checks) → feature engineering (shared offline/online definitions) → versioned dataset snapshots — every training run pins an immutable dataset version, so a model can always be traced back to exactly the data that taught it.

### 2. Training Infrastructure
**How it works — Training infrastructure:** experiments run on managed GPU pools with queues and priorities, datasets and artifacts are versioned (data lineage!), and results are reproducible because the run records code, data, and hyperparameters together.

## Architecture Patterns

### 1. Model Serving
**How it works — Model serving:** Define the shape from the access patterns first, apply the change incrementally with a rollback path, and verify both old and new readers work during the transition window.

### 2. Feature Store
**How it works — Feature store:** features are computed once and served twice — offline (batch, for training) and online (low-latency lookup, at inference) — with identical definitions, so the model never meets training/serving skew.

## Implementation Strategies

### 1. Model Lifecycle Management
**How it works — Model lifecycle:** Define the shape from the access patterns first, apply the change incrementally with a rollback path, and verify both old and new readers work during the transition window.

### 2. Online Prediction Service
**How it works — Prediction service:** features are fetched from the online store, the model scores the request in milliseconds, and the response carries the prediction plus confidence and feature versions — every call is logged for later drift analysis.

## Common Use Cases

### 1. Recommendation System
**How it works — Recommendation system:** candidate generation narrows millions of items to hundreds (embedding retrieval), a ranker scores them with the trained model, and business rules filter the top — the index serves retrieval; the model serves ordering.

### 2. Computer Vision Pipeline
**How it works — Vision pipeline:** frames flow through stages — decode → resize/normalize → batch → model — with GPU utilization as the design constraint; batch size is the dial that trades latency for throughput.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Online inference | Fresh predictions, interactivity | Serving cost, latency budget | Personalization, search |
| Batch inference | Cheap at scale, simple | Stale predictions | Recommendations, scoring |
| Frequent retraining | Captures drift quickly | Compute cost, version churn | Fast-changing patterns |
| Long training cycles | Stable, cheaper | Model staleness | Slow-moving domains |
| Complex models | Higher accuracy | Latency, cost, explainability loss | Offline ranking |
| Simple models | Fast, interpretable, cheap | Accuracy ceiling | Real-time, regulated decisions |

**Freshness vs cost:** Model and feature staleness degrades accuracy silently; pipelines to refresh them cost real money — measure decay to set cadence.

**Accuracy vs latency:** Bigger models win offline benchmarks and lose serving budgets; distill or cascade (cheap gate, expensive model on demand).

**Training/serving skew:** Divergent pipelines cause silent quality drops; share feature logic where possible.

> **⚠️ When NOT to serve online:** predictions consumed in bulk (batch scoring is 10-100x cheaper), features that change slowly (precompute them), and traffic too low to amortize GPU serving.

## Edge Cases to Consider

- Feature freshness mismatch between training and serving
- Cold-start users/items — fallbacks and exploration strategies
- Model rollback incompatible with current feature payloads
- LLM cost spikes from unbounded context or retries


## Common Pitfalls

1. No monitoring on prediction quality — drift found by users
2. Deploying models without canaries or shadow traffic
3. Training data leakage inflating offline metrics
4. Ignoring inference cost per request in unit economics


## FAQ

**Q1: Why does a feature store matter?**

A: It makes training and serving compute features identically from one definition — eliminating skew, the most common reason offline metrics fail in production.

**Q2: Batch or real-time inference?**

A: Real-time when the score changes decisions per request (fraud, ranking); batch when lists can be precomputed (digests, catalog scores). Real-time costs 10x — verify the need.

**Q3: How is ML system design different?**

A: Same primitives (queues, caches, sharding) plus three loops: data pipelines feeding training, model versioning, and drift monitoring feeding retraining. Design the loops, not just the model.

## Interview Tips

### 1. Key Considerations
- Data quality
- Model performance
- Serving latency
- System scalability
- Monitoring strategy

### 2. Common Questions
1. How to handle model drift?
2. How to scale feature engineering?
3. How to deploy models efficiently?
4. How to monitor model performance?

### 3. Best Practices
- Version everything
- Monitor data quality
- Implement CI/CD
- Use feature store
- Automate retraining

## Advanced Topics

1. Shadow deployments and champion/challenger serving
2. Drift detection on feature distributions (PSI/KL)
3. GPU autoscaling with batching queues (Triton-style)
4. LLM ops: caching, semantic dedup, guardrail chains


## Further Reading
- [ML System Design](https://github.com/chiphuyen/machine-learning-systems-design)
- [Feature Store Design](https://www.featurestore.org/)
- [ML in Production](https://www.oreilly.com/library/view/building-machine-learning/9781492045106/)

