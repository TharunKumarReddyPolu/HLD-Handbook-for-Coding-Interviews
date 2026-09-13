# Testing Strategies

This section covers testing distributed systems — where unit tests end and the hard problems begin. Expect interview questions like "how would you verify this design works before launch?"

## Topics in This Section

- [Load Testing Strategies](load-testing.md) - Load types, bottleneck hunting, and capacity validation
- [Performance Testing](performance-testing.md) - Stress and endurance testing beyond basic load testing
- [Chaos Engineering](chaos-engineering.md) - Steady-state hypotheses and real-world failure scenarios
- [Integration Testing in Microservices](integration-testing.md) - Testing services in composition without full environments
- [Contract Testing](contract-testing.md) - Consumer-driven contracts that keep APIs compatible
- [A/B Testing Architecture](ab-testing.md) - Experimentation platforms, feature flags, and assignment consistency

## Suggested Learning Path

```
Integration Testing ──► Contract Testing
        │
        ▼
Load Testing ──► Performance Testing ──► Chaos Engineering
        │
        ▼
A/B Testing Architecture
```

## Where to Go Next

- [Observability](../observability/README.md) - You can't verify what you can't see
- [Best Practices: Performance](../best-practices/performance.md) - What the tests should tell you
- [Case Studies](../case-studies/README.md) - Complete designs that assume this rigor
