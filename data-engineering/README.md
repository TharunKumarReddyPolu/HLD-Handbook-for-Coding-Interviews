# Data Engineering

This section covers how data moves, is stored, and is transformed at scale — a frequent follow-up area in system design interviews once the core system is on the whiteboard.

## Topics in This Section

- [Data Warehousing](data-warehousing.md) - Architecture patterns and dimensional modeling
- [ETL vs ELT](etl-vs-elt.md) - Where transformation happens and why it changes your architecture
- [Data Modeling](data-modeling.md) - Normalization, denormalization, and choosing schemas for access patterns
- [OLAP vs OLTP](olap-vs-oltp.md) - Transactional vs analytical workloads and their storage engines
- [Data Quality & Validation](data-quality.md) - Quality dimensions, validation strategies, and monitoring
- [Real-time Analytics](real-time-analytics.md) - Ingestion, stream processing, and windowing for live data

## Suggested Learning Path

```
OLAP vs OLTP ──► Data Modeling ──► Data Warehousing
                                       │
                    ETL vs ELT ──► Real-time Analytics
                                       │
                              Data Quality & Validation
```

## Where to Go Next

- [System Basics](../system-basics/README.md) - Storage fundamentals these topics build on
- [Modern Architectures](../modern-architectures/README.md) - AI/ML and IoT systems lean heavily on data engineering
- [Compliance](../compliance/README.md) - Governance for data in motion and at rest
