# Scalability Patterns

This section covers how systems grow from serving hundreds of users to serving millions. Each topic addresses a specific dimension of scale — traffic, data, or complexity.

## Topics in This Section

- [Horizontal vs Vertical Scaling](scaling-types.md) - Scale-out vs scale-up: costs, limits, and when each wins
- [Microservices](microservices.md) - Service decomposition, communication patterns, and trade-offs
- [Event-Driven Architecture](event-driven.md) - Events, publish-subscribe, and loosely coupled producers and consumers
- [Data Partitioning](data-partitioning.md) - Range, hash, and directory partitioning of large datasets
- [Replication](replication.md) - Leader-follower, multi-leader, and quorum-based data copies
- [CAP Theorem](cap-theorem.md) - Why consistency, availability, and partition tolerance trade off

## Suggested Learning Path

```
Horizontal vs Vertical Scaling
        │
        ├──► Data Partitioning ──► Replication ──► CAP Theorem
        │
        └──► Microservices ──► Event-Driven Architecture
```

## Where to Go Next

- [Architecture Patterns](../architecture/README.md) - Building blocks used inside scalable systems
- [Case Studies](../case-studies/README.md) - See scalability patterns applied end to end
- [Medium Interview Questions](../interview-questions/medium/README.md) - Practice designs that lean on these patterns
