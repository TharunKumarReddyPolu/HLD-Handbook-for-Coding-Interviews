# API Gateway in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Gateway Patterns](#gateway-patterns)
- [Core Features](#core-features)
- [Implementation Strategies](#implementation-strategies)
- [Security Aspects](#security-aspects)
- [Best Practices](#best-practices)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

An API Gateway serves as a single entry point for client applications to access services in a microservices architecture. It handles cross-cutting concerns like authentication, routing, and request aggregation.

### Key Functions
1. **Request Routing**
2. **Authentication**
3. **Rate Limiting**
4. **Request/Response Transformation**
5. **Monitoring**

## Prerequisites & Related Topics

- Builds on: [Load Balancing](../system-basics/load-balancing.md), [API Design](../system-basics/api-design.md)
- Used in: [Microservices](../scalability/microservices.md), [Rate Limiting](rate-limiting.md), [Service Discovery](service-discovery.md)
- Techniques often combined: JWT validation, rate limits, canary routing, request transformation
- See also: [Service Mesh](../cloud-native/service-mesh.md) — mesh handles east-west, gateway handles north-south


## Pattern Recognition Guide

### 🎯 When to Use API Gateway

**Keywords in requirements**: "single entry point", "cross-cutting concerns", "client-facing API", "auth at the edge", "backend aggregation"
**Reach for this when**:
- Microservices exposing one coherent API to external clients
- Centralizing auth, rate limiting, and telemetry at the edge
- Mobile/BFF aggregation over chatty backend endpoints
- Canary and blue/green traffic shifting per route

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Managed (Kong, Apigee) | policy plugins, fast start | most teams |
| Cloud-native (APIGW, ALB) | pay-per-use, no fleet | serverless, AWS-centric |
| Custom (Envoy-based) | full control, bespoke routing | very large platforms |

### ❌ When NOT to Use

- One or two internal services — a load balancer plus app-level auth suffices
- Ultra-low-latency internal paths — route around the gateway
- Complex business logic in gateway plugins — keep policies declarative


## Gateway Patterns

### 1. Backend for Frontend (BFF)
```mermaid
graph TD
    A[Mobile Client] --> B[Mobile BFF]
    C[Web Client] --> D[Web BFF]
    E[Desktop Client] --> F[Desktop BFF]
    B --> G[Microservices]
    D --> G
    F --> G
```

**How it works — BFF gateway:** one thin gateway per client type (web, mobile, TV) — each composes and reshapes backend calls into exactly the payload its client needs and owns that client's auth and rate-limit posture. With a new client you stand up a new BFF instead of etching the old one.

### 2. Aggregation Gateway
**How it works — Aggregation gateway:** a client asks for one "dashboard" resource; the gateway fans out parallel calls to services, composes (and de-duplicates) the results into a single response. Failure policy per downstream: partial results with flags beat a full 500.

### 3. Protocol Translation Gateway
**How it works — Protocol translation gateway:** REST in, gRPC or WebSocket out — the gateway carries one public protocol while teams build services in whatever suits them. Also where legacy XML/SOAP callers get converted rather than rewritten.

## Core Features

### 1. Request Routing
**How it works — Request routing:** the gateway matches on host + path + method (sometimes headers) against a route table, then load-balances into the right service pool. It authenticates *before* routing so identity, not IP, drives decisions.

### 2. Authentication & Authorization
**How it works — Authentication middleware:** extract credentials (bearer token or session cookie), validate signature and expiry, and attach the resolved identity to the request context — reject with 401 before any route logic runs.

### 3. Request Transformation
**How it works — Request transformer:** the gateway rewrites requests in flight — path mapping, header injection, payload reshaping — so backends see a canonical shape while clients keep their own contract.

## Implementation Strategies

### 1. Kong Gateway Implementation
**How it works — Kong:** declarative config defines services (upstreams) and routes; plugins attach cross-cutting behavior per route — auth (JWT/OAuth), rate limiting, caching, logging — without touching backend code. In interviews, frame it as "policy at the edge, configured not coded", with the caveat that very custom routing logic may justify a purpose-built gateway.

### 2. Custom Gateway Implementation
**How it works — Custom gateway:** Envoy/NGINX-based gateways give you per-route config files (matches, retries, limits, headers) — code only appears as WASM plugins when declarative policy can't express the behavior. The trade: full control in exchange for owning the upgrade treadmill.

### 3. Circuit Breaker Integration
**How it works — Circuit breaker gateway:** route-level breaker policy lives in the gateway config: failure thresholds per route, open-state timeouts, and fallback responses — configured once per route in declarative policy, not coded into each service.

## Security Aspects

### 1. API Key Authentication
**How it works — Apikey auth:** static keys identify machines, not humans — hashed at rest, scoped to minimal permissions, rotated on schedule, always over TLS; prefer short-lived tokens wherever the integration allows.

### 2. JWT Authentication
**How it works — Gateway JWT validation:** the gateway verifies signature, issuer, audience, and expiry *once at the edge* and forwards a canonical identity header — every backend trusts verified context and never re-parses tokens, eliminating N services × M token libraries.

### 3. OAuth Integration
**How it works — OAuth handler:** implements the provider side of the flow — authorize endpoint, code exchange, refresh — validating redirect URIs exactly and issuing narrowly scoped, short-lived tokens; the handler is the trust boundary for every integration.

## Best Practices

### 1. Error Handling
**How it works — Error handler:** unknown/invalid requests fail fast with structured errors and correct status codes at the edge; timeouts, retries, and rate-limit rejections are caught in policy, so backend failures never crash a route handler.

### 2. Monitoring & Logging
**How it works — Gateway monitor:** the gateway sees every request: export per-route RED metrics and structured access logs carrying trace IDs — the single best vantage point for cross-service latency and error attribution.

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| Centralized gateway | One place for auth, rate limiting, routing | Potential bottleneck and SPOF, team contention | Consistent cross-cutting policy |
| Per-domain gateways (BFF) | Team autonomy, client-optimized APIs | Duplicated infrastructure and policy | Multiple client types, large orgs |
| Thick gateway (aggregation) | Fewer client round trips | Business logic creeps into gateway | Read-heavy client views |

**Centralization vs flexibility:** A shared gateway enforces consistency but every team's change funnels through it; decentralized gateways trade duplication for autonomy.

**Gateway depth vs latency:** More processing in the gateway (auth, transformation) means more latency and coupling; push work to services when policy allows.

**Availability:** The gateway is on every request path — it must scale horizontally, health-check backends, and degrade gracefully.

> **⚠️ When NOT to add a gateway:** a single service behind one client (a reverse proxy suffices), latency-critical paths that never cross the boundary, and teams that would turn it into a custom-logic dump — gateways hold policy, not business logic.

## Edge Cases to Consider

- Gateway as single point of failure — run HA pairs, health-check it
- Latency budget at scale — every hop through the gateway costs p99
- WebSocket/streaming — ensure pass-through without buffering
- Large uploads — streaming config to avoid buffering blowups


## Common Pitfalls

1. Business logic creeping into the gateway — deployment coupling returns
2. No per-route rate limits — one noisy client starves the rest
3. Skipping observability at the edge — gateways see everything, log it
4. One gateway shape for every client instead of BFFs where needed


## FAQ

**Q1: Gateway vs load balancer?**

A: A balancer spreads traffic; a gateway adds per-route policy — auth, transforms, quotas, aggregation. Most gateways include balancing; few balancers include policy.

**Q2: Gateway or service mesh?**

A: Gateways manage north-south (client in/out); meshes manage east-west (service-to-service). Large platforms run both with identity passed between them.

**Q3: Where does authentication live?**

A: Token verification at the gateway (cheap, centralized), fine-grained authorization in each service — never rely on the edge alone.

## Interview Tips

### 1. Key Considerations
- Gateway responsibilities
- Security requirements
- Performance impact
- Scalability needs
- Monitoring approach

### 2. Common Questions
1. How would you implement an API gateway?
2. How do you handle gateway security?
3. How do you ensure gateway performance?
4. How do you monitor gateway health?

### 3. Architecture Diagram
```mermaid
graph TD
    A[Clients] --> B[API Gateway]
    B --> C[Authentication]
    B --> D[Rate Limiting]
    B --> E[Request Routing]
    E --> F[Service 1]
    E --> G[Service 2]
    E --> H[Service 3]
```

## Advanced Topics

1. Canary/percentage routing with header-based overrides
2. Request coalescing and response caching per route
3. OIDC-aware edge auth with token exchange
4. Gateway aggregation for GraphQL-style batched queries


## Further Reading
- [Kong Documentation](https://docs.konghq.com/)
- [API Gateway Pattern](https://microservices.io/patterns/apigateway.html)
- [AWS API Gateway](https://aws.amazon.com/api-gateway/)
- [Netflix Zuul](https://github.com/Netflix/zuul/wiki) 