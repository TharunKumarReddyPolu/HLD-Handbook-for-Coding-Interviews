# Contract Testing in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Testing Strategies](#testing-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Contract Validation](#contract-validation)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Contract testing ensures that services maintain their agreed-upon interfaces and behaviors in a microservices architecture.

### Key Benefits
1. **Interface Stability**
2. **Early Detection**
3. **Reduced Integration Issues**
4. **Faster Development**
5. **Service Independence**

## Prerequisites & Related Topics

- Builds on: [API Design](../system-basics/api-design.md), [Integration Testing](integration-testing.md)
- Used in: [Microservices](../scalability/microservices.md), [Event-Driven Architecture](../scalability/event-driven.md) (schema contracts), [CI/CD](../cloud-native/kubernetes-orchestration.md)
- Techniques often combined: consumer-driven contracts (Pact), schema registries, canary verification
- See also: [Pact docs](https://docs.pact.io/) — the reference implementation


## Pattern Recognition Guide

### 🎯 When to Use Contract Testing

**Keywords in requirements**: "breaking change", "consumer", "provider", "schema evolution", "API compatibility", "integration test"
**Reach for this when**:
- Microservice teams deploying independently without integration freezes
- Public APIs with external consumers and version promises
- Event schema evolution with many consumer teams
- Preventing "works in staging" integration surprises

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Consumer-driven (Pact) | consumers own expectations | internal microservices |
| Provider-driven (OpenAPI checks) | published spec is truth | public APIs |
| Schema registry rules | event/message compatibility | Kafka ecosystems |
| Canary contract replay | real traffic vs new version | high-stakes rollouts |

### ❌ When NOT to Use

- Tiny teams with one deploy train — shared integration environments may suffice
- Contract tests replacing a few real end-to-end smoke tests — keep both, few
- Testing business logic through contracts — they verify shape, not behavior


## Testing Strategies

### 1. Consumer-Driven Contracts
**How it works — Consumer contract:** the consuming team publishes exactly what it depends on (fields, types, semantics); the provider's CI runs those expectations on every change, so breaking a consumer breaks the provider's build — not production.

### 2. Provider Verification
**How it works — Provider verification:** the provider's CI replays every consumer contract against the real service; a change that breaks any expectation fails the build — compatibility is enforced before release, not discovered after.

## Implementation Patterns

### 1. Contract Definition
**How it works — Contract definition:** the interface is written down as a versioned artifact (OpenAPI, protobuf, Pact) — request/response shapes, error codes, semantics — and both sides code against it; the contract, not a conversation, is the source of truth.

### 2. Test Implementation
**How it works — consumer-driven contracts:** the consumer publishes its exact expectations (endpoints, fields, types) as a contract file; the provider's CI verifies every expectation against the real service — a breaking change fails the provider build before either team ships.

## Contract Validation

### 1. Schema Validation
**How it works — Schema validator:** Define the shape from the access patterns first, apply the change incrementally with a rollback path, and verify both old and new readers work during the transition window.

### 2. Behavior Validation
**How it works — Behavior validator:** compare the request's behavior (velocity, device, history) against the account's baseline; deviations step up authentication or block — fraud defense before the transaction commits.

## Common Use Cases

### 1. Microservice Integration
**How it works — Service integration:** prefer events for decoupling, explicit APIs for queries, and anti-corruption layers at legacy boundaries — every integration point is versioned and owned, not an implicit database read.

### 2. API Evolution
**How it works — API evolution:** Keep the contract explicit — resource, method, versioning, pagination, error shape — and evolve it without breaking existing clients; additive changes only, deprecations announced with a sunset date.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Consumer-driven contracts | Consumers define needs; provider gets exact expectations | Requires broker/workflow discipline | Microservice ecosystems |
| Provider-generated contracts | Provider controls its promise | Consumers untested against real needs | Public APIs |
| Strict contract verification | Catches every breaking change | Contract churn slows independent deploys | Stable, long-lived APIs |
| Loose/spot checks | Fast, low maintenance | Subtle breaking changes slip through | Early-stage, fast-moving APIs |

**Compatibility enforcement vs deploy independence:** Strict contracts protect consumers but couple release timing; versioned contracts with a compatibility window preserve independence.

**Broker infrastructure vs ad-hoc sharing:** A contract broker automates verification flows; shared files are free but drift.

**Contract breadth vs maintenance:** Exhaustive contracts catch more but require updating for every intentional change.

> **⚠️ When NOT to adopt contract testing:** single-team services where integration tests are cheap, stable public APIs with rare changes, and early prototypes where contracts would churn daily.

## Edge Cases to Consider

- Consumers depending on unspecified behavior — contracts force it explicit
- Multiple consumer versions live simultaneously — matrix verification
- Queued messages from old producers to new consumers
- Contracts drifting from docs — generate both from one source


## Common Pitfalls

1. Contracts that mirror implementation instead of interaction needs
2. Verification ignored on red — the pipeline is the policy or nothing is
3. No ownership of shared schemas
4. Giant contracts nobody updates — start minimal, grow with usage


## FAQ

**Q1: Contract testing vs integration testing?**

A: Integration tests run real services together — slow, brittle, but end-to-end. Contract tests verify each provider against each consumer's expectations in isolation — fast and targeted. Use contracts widely, integration tests sparingly.

**Q2: Who owns the contract?**

A: The consumer writes what it needs; the provider verifies and can negotiate. Ownership is shared, but the consumer's requirements are the starting point in consumer-driven testing.

**Q3: How does this stop breaking changes?**

A: The provider's CI runs every consumer contract; a change that breaks any consumer fails the build before deploy — incompatibility becomes a compile-time-ish error, not a production call.

## Interview Tips

### 1. Key Considerations
- Contract design
- Version management
- Test coverage
- Integration strategy
- Evolution handling

### 2. Common Questions
1. How to design contracts?
2. How to handle versioning?
3. How to ensure compatibility?
4. How to manage changes?

### 3. Best Practices
- Consumer-driven contracts
- Automated testing
- Version control
- Clear documentation
- Change management

## Advanced Topics

1. Pact broker with can-i-deploy release gates
2. Async message contracts alongside HTTP pacts
3. OpenAPI-diff breaking-change detection in CI
4. Contract-first codegen with multi-language clients


## Further Reading
- [Pact Documentation](https://docs.pact.io/)
- [Consumer-Driven Contracts](https://martinfowler.com/articles/consumerDrivenContracts.html)
- [API Evolution](https://www.thoughtworks.com/insights/blog/rest-api-design-resource-modeling)

