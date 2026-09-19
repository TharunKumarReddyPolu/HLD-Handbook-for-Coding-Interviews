# API Security in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Authentication Patterns](#authentication-patterns)
- [Authorization Patterns](#authorization-patterns)
- [Data Protection](#data-protection)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

API security patterns provide standardized approaches to securing API endpoints and protecting data.

### Key Benefits
1. **Standardized Security**
2. **Attack Prevention**
3. **Data Protection**
4. **Access Control**
5. **Audit Trail**

## Prerequisites & Related Topics

- Builds on: [Authentication & Authorization](../system-basics/auth.md), [API Design](../system-basics/api-design.md)
- Used in: [OAuth & OIDC](oauth-openid.md), [DDoS Prevention](ddos-prevention.md), [Rate Limiting](../architecture/rate-limiting.md)
- Techniques often combined: token scopes, schema validation, WAF rules, mTLS for internal hops
- See also: [OWASP API Security Top 10](https://owasp.org/API-Security/) — the canonical risk list


## Pattern Recognition Guide

### 🎯 When to Use API Security

**Keywords in requirements**: "secure API", "token validation", "input validation", "authorization", "BOLA", "API abuse", "rate limit"
**Reach for this when**:
- Every public or partner-facing API from day one
- Machine-to-machine APIs needing scoped, auditable access
- Third-party integrations with per-client credentials and quotas
- Regulated endpoints requiring audit trails of every access

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Token + scope checks | per-request identity and grants | the baseline for all APIs |
| Schema validation | types, ranges, required fields | every ingestion point |
| Per-client rate limits | fairness and abuse control | public and partner APIs |
| mTLS | strong service identity | internal high-value paths |

### ❌ When NOT to Use

- Security only at the gateway — services must re-check authorization
- Obfuscation as control (secret endpoints, hidden IDs) — IDs are not secrets
- Rolling your own token format or crypto


## Authentication Patterns

### 1. JWT Authentication
**How it works — JWT authenticator:** the filter validates the token's signature, expiry, and audience before the handler sees the request, and exposes the verified claims as the request identity — one chokepoint, uniformly enforced.

### 2. API Key Authentication
**How it works — Apikey authenticator:** hash-lookup the key, check its scopes against the requested operation, apply the key's rate-limit tier, and attribute usage to the key owner — one uniform path for every programmatic client.

## Authorization Patterns

### 1. Role-Based Access Control
**How it works — RBAC authorizer:** resolve roles → permissions → decision in one lookup and cache the role→permission map (it changes rarely); the check must stay O(1) on the hot path.

### 2. Attribute-Based Access Control
**How it works — ABAC authorizer:** evaluate policy against attributes (department, resource owner, time, data sensitivity) at request time — far more expressive than roles, at the cost of policies that need testing discipline.

## Data Protection

### 1. Request Validation
**How it works — Request validator:** schema-validate at the boundary — types, ranges, required fields, sizes — and reject with specific errors before the request touches business logic; validation downstream of the edge is already too late.

### 2. Response Security
**How it works — Response security handler:** outbound hygiene: security headers (HSTS, CSP, X-Content-Type-Options), no sensitive data in response bodies or error messages, and error shapes that never leak stack traces or internal IDs.

## Common Use Cases

### 1. REST API Security
**How it works — Restsecurity middleware:** per-request token validation, scope checks per route, and strict 401-vs-403 semantics — stateless JWT checks at the edge, with a denylist consulted for the token's short lifetime.

### 2. GraphQL Security
**How it works — Graph qlsecurity:** the single endpoint needs GraphQL-specific defenses: depth and complexity limits against nested queries, cost analysis, persisted queries, and field-level authorization — introspection is not access control.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Strict input validation | Blocks injection classes early | Rigid schemas, maintenance | All public endpoints |
| Permissive validation | Flexible integrations | Injection and abuse risk | Trusted internal only |
| Aggressive rate limits | Strong abuse protection | Blocks legitimate power users | Public, unauthenticated endpoints |
| Token-based auth (JWT) | Stateless, scalable | Revocation complexity | Service APIs |
| Opaque tokens + introspection | Instant revocation | Per-request lookup cost | High-security APIs |

**Usability vs security:** Tight limits and validation reduce attack surface and frustrate legitimate clients; use tiered limits by trust level.

**Stateless vs revocable:** JWTs scale horizontally but live until expiry; introspected tokens revoke instantly at latency cost.

**Security through obscurity vs standards:** Standard schemes (OAuth2) are audited and well-tooled; custom schemes are predictable only to their authors.

> **⚠️ When NOT to rely on JWTs alone:** admin and high-value operations needing instant revocation, and zero-trust service meshes where per-request token checks pair with mTLS — a stolen long-lived JWT is a skeleton key.

## Edge Cases to Consider

- Valid token, other user's object ID — object-level checks catch BOLA
- Mass assignment — mass-assignable DTOs overwriting fields like role
- GraphQL resolvers skipping field-level auth
- Long-lived API keys leaked in repos — short-lived tokens and scanning


## Common Pitfalls

1. AuthN without per-object AuthZ — the #1 API vulnerability
2. Trusting client-supplied prices/quantities/roles
3. Verbose errors handing attackers internal details
4. No rate limits on auth and export endpoints


## FAQ

**Q1: What is the most common API vulnerability?**

A: Broken object-level authorization: the token is valid but the request targets someone else's object. Every object access needs an ownership/entitlement check.

**Q2: JWT validation — what actually must be checked?**

A: Signature against a known issuer, expiry, audience, and then your own authorization rules. A valid token is authentication, never authorization.

**Q3: Where do rate limits fit in API security?**

A: As abuse control and blast-radius reduction: per-key quotas slow credential stuffing, scraping, and runaway clients before they become incidents.

## Interview Tips

### 1. Key Considerations
- Authentication method
- Authorization model
- Input validation
- Output security
- Rate limiting

### 2. Common Questions
1. How to secure REST APIs?
2. When to use JWT vs API Keys?
3. How to implement RBAC/ABAC?
4. How to prevent common attacks?

### 3. Best Practices
- Use HTTPS always
- Validate all input
- Implement rate limiting
- Use proper authentication
- Regular security audits

## Advanced Topics

1. Field-level authorization for GraphQL/REST projections
2. Signed request bodies for high-integrity endpoints
3. API abuse detection from access-log analytics
4. Automated API inventory vs shadow APIs


## Further Reading
- [OWASP API Security](https://owasp.org/www-project-api-security/)
- [REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)
- [GraphQL Security](https://graphql.org/learn/best-practices/#security)

