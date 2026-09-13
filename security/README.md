# Security Architecture

This section covers security as a design concern, not an afterthought — senior interviewers consistently probe how a design protects data, identity, and availability.

## Topics in This Section

- [Zero Trust Architecture](zero-trust.md) - Never trust, always verify
- [OAuth 2.0 and OpenID Connect](oauth-openid.md) - Delegated authorization and federated identity
- [API Security Patterns](api-security.md) - Authentication, authorization, and input validation for APIs
- [Secrets Management](secrets-management.md) - Credential management strategies and rotation
- [DDoS Prevention Strategies](ddos-prevention.md) - Absorption, filtering, and mitigation techniques
- [Security Compliance in Design](security-compliance.md) - SOC 2, ISO 27001, and PCI DSS as architecture inputs

## Suggested Learning Path

```
OAuth 2.0 & OIDC ──► API Security Patterns
        │
        ├──► Zero Trust Architecture ──► Secrets Management
        │
        └──► DDoS Prevention ──► Security Compliance in Design
```

## Where to Go Next

- [System Basics: Authentication & Authorization](../system-basics/auth.md) - The fundamentals this section deepens
- [Compliance](../compliance/README.md) - Regulatory drivers behind security requirements
- [Best Practices: Security](../best-practices/security.md) - A distilled checklist for interview answers
