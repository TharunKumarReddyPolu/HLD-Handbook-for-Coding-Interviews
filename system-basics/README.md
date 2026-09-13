# System Design Fundamentals

This section covers the core building blocks every system design answer relies on. If you're new to HLD, start here — everything else in this handbook assumes these fundamentals.

## Topics in This Section

- [Distributed Systems Basics](distributed-systems.md) - Core concepts: nodes, latency, failures, and the fallacies of distributed computing
- [Load Balancing](load-balancing.md) - Distributing traffic across servers with algorithms, layers, and health checks
- [Caching](caching.md) - Cache-aside, write-through, eviction policies, and distributed caches
- [Database Sharding](database-sharding.md) - Splitting data across nodes: shard keys, rebalancing, and hot spots
- [Indexing](indexing.md) - B-trees, LSM-trees, and how indexes shape read/write trade-offs
- [API Design](api-design.md) - REST, GraphQL, gRPC, pagination, and versioning
- [Authentication & Authorization](auth.md) - Sessions, JWT, SSO, RBAC, and OAuth basics
- [Monitoring & Logging](monitoring.md) - Metrics, logs, and alerts every production system needs

## Suggested Learning Path

```
Distributed Systems Basics
        │
        ├──► Load Balancing ──► Caching
        │
        ├──► API Design ──► Authentication & Authorization
        │
        └──► Indexing ──► Database Sharding ──► Monitoring & Logging
```

## Where to Go Next

- [Scalability Patterns](../scalability/README.md) - Apply these fundamentals at scale
- [Architecture Patterns](../architecture/README.md) - Compose fundamentals into proven building blocks
- [Easy Interview Questions](../interview-questions/easy/README.md) - Practice with foundational design problems
