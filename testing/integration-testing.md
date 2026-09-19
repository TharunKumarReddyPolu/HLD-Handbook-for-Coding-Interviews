# Integration Testing in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Testing Strategies](#testing-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Test Infrastructure](#test-infrastructure)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Integration testing in microservices verifies the interaction between different services and components.

### Key Benefits
1. **Service Compatibility**
2. **Contract Validation**
3. **End-to-End Flows**
4. **Dependency Verification**
5. **System Reliability**

## Prerequisites & Related Topics

- Builds on: [Contract Testing](contract-testing.md), unit testing discipline
- Used in: [Microservices](../scalability/microservices.md), [CI/CD](../cloud-native/kubernetes-orchestration.md), Data Pipelines
- Techniques often combined: testcontainers, ephemeral environments, seeded fixtures, parallel isolation
- See also: [Testcontainers](https://testcontainers.com/) — real dependencies in CI


## Pattern Recognition Guide

### 🎯 When to Use Integration Testing

**Keywords in requirements**: "integration test", "testcontainers", "real database", "wiring", "repository test", "end-to-end"
**Reach for this when**:
- Verifying persistence: migrations, queries, transactions against real DB
- Message flows: publish, consume, DLQ behavior on a real broker
- Cache and lock semantics with real Redis
- Pre-merge confidence for services whose bugs live in wiring

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Component test | one service + real deps | the workhorse level |
| Contract-backed integration | consumer expectations verified | service boundaries |
| End-to-end smoke | journey through the system | few, critical paths only |
| Data-pipeline test | input → transformation → output | ETL correctness |

### ❌ When NOT to Use

- Mocking everything and calling it integration — that is a unit test with extra steps
- Exhaustive coverage at this level — reserve for wiring and high-risk paths
- Shared mutable environments across CI runs — isolation or flakiness, pick one


## Testing Strategies

### 1. Consumer-Driven Contracts
**How it works — Consumer contract test:** Exercise the "Consumer contract test" scenario against a realistic environment and assert on the observable outcome — pass/fail criteria are defined before the run, not after.

### 2. Service Virtualization
**How it works — Service mock:** contract-based mocks stand in for dependencies in tests — same interface, canned but realistic responses, latency and failure injection included — so tests exercise our logic, not the dependency's uptime.

## Implementation Patterns

### 1. Test Environment
**How it works — Test environment:** Exercise the "Test environment" scenario against a realistic environment and assert on the observable outcome — pass/fail criteria are defined before the run, not after.

### 2. Test Data Management
**How it works — Test data manager:** Exercise the "Test data manager" scenario against a realistic environment and assert on the observable outcome — pass/fail criteria are defined before the run, not after.

## Test Infrastructure

### 1. Service Dependencies
**How it works — Dependency manager:** every service pins exact versions of its dependencies, updates are automated PRs with test gates, and known-CVE versions are blocked from deploy — upgrades become routine, not incidents.

### 2. Test Orchestration
**How it works — Test orchestrator:** Exercise the "Test orchestrator" scenario against a realistic environment and assert on the observable outcome — pass/fail criteria are defined before the run, not after.

## Common Use Cases

### 1. Order Processing Flow
**How it works — Order flow test:** Exercise the "Order flow test" scenario against a realistic environment and assert on the observable outcome — pass/fail criteria are defined before the run, not after.

### 2. Service Communication
**How it works — Service communication test:** Exercise the "Service communication test" scenario against a realistic environment and assert on the observable outcome — pass/fail criteria are defined before the run, not after.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Real dependencies | Highest fidelity | Slow, flaky, environment cost | Critical paths, release gates |
| Test doubles (stubs/mocks) | Fast, deterministic | Drift from real behavior | Unit-adjacent and edge-case tests |
| Shared long-lived environment | Cheap per-run | Cross-test interference, 'who broke it' | Small teams |
| Ephemeral per-run environments | Isolation, reproducibility | Provisioning cost/time | CI at scale |

**Fidelity vs speed:** Every real dependency raises confidence and runtime; the pyramid exists because that cost compounds.

**Isolation vs resource cost:** Fresh environments per pipeline kill flakiness at provisioning price; optimize with containers and reuse where safe.

**Mock maintenance:** Doubles are code that rots — generate from contracts/schemas rather than hand-writing.

> **⚠️ When NOT to mock:** auth, payment, and persistence flows where mock drift hides real breakage — run those against real dependencies in a scheduled, gated suite.

## Edge Cases to Consider

- Flaky timing on async consumption — awaitable assertions, not sleeps
- Migration drift between test and prod schemas
- Test data volume skewing planner behavior
- Parallel CI runs sharing seeded IDs — namespace per run


## Common Pitfalls

1. Sleep-based synchronization — flakiness factory
2. Testing only the happy path through real deps
3. Slow suites nobody runs locally — keep under minutes, parallelize
4. Skipping cleanup — cross-test contamination follows


## FAQ

**Q1: Mocks or real dependencies?**

A: Mocks in unit tests for speed; real dependencies in integration tests because wiring, SQL, and serialization bugs only appear for real. The pyramid wants few integration tests — but they must be real.

**Q2: How do I stop flaky integration tests?**

A: Eliminate sleeps with awaitable conditions, isolate state per test, seed deterministically, and quarantine-repeat offenders while fixing root causes. Flakiness is a bug in the test.

**Q3: How many integration tests per service?**

A: Enough to cover each real dependency interaction and each critical write path — usually dozens, not hundreds. Unit tests cover logic; integration covers wiring.

## Interview Tips

### 1. Key Considerations
- Test isolation
- Data management
- Service dependencies
- Error handling
- Performance impact

### 2. Common Questions
1. How to design integration tests?
2. How to handle test data?
3. How to manage service dependencies?
4. How to ensure test reliability?

### 3. Best Practices
- Use contract testing
- Maintain test data
- Automate environment setup
- Monitor test execution
- Document test cases

## Advanced Topics

1. Testcontainers-style ephemeral stacks per CI job
2. Snapshot/verify patterns for complex outputs
3. Deterministic clocks and injected randomness
4. Environment parity checks: schema and config drift detection


## Further Reading
- [Integration Testing Guide](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Contract Testing](https://pact.io/documentation/implementation_guides.html)
- [Testing Microservices](https://microservices.io/testing)

