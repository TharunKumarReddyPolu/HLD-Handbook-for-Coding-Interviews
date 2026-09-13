# Architecture Patterns

This section covers proven building blocks used inside large-scale systems. Each pattern solves a specific reliability, performance, or organizational problem — and comes with trade-offs you should be ready to defend in an interview.

## Topics in This Section

- [Message Queues](message-queues.md) - Decouple producers from consumers with async, durable delivery
- [Service Discovery](service-discovery.md) - How services find each other: registries, health checks, client vs server-side
- [API Gateway](api-gateway.md) - Single entry point for routing, auth, and cross-cutting concerns
- [Rate Limiting](rate-limiting.md) - Token bucket, sliding window, and distributed rate limiting at the edge
- [Circuit Breaker](circuit-breaker.md) - Circuit states that stop cascading failures

## Suggested Learning Path

```
Message Queues
      │
      ▼
Service Discovery ──► API Gateway ──► Rate Limiting ──► Circuit Breaker
```

## Where to Go Next

- [Scalability Patterns](../scalability/README.md) - The scale concepts these patterns build on
- [Observability](../observability/README.md) - How to see these patterns working (or failing) in production
- [Case Studies](../case-studies/README.md) - Patterns applied end to end in real systems
