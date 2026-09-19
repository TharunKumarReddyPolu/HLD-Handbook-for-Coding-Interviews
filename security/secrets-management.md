# Secrets Management in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Management Strategies](#management-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Security Controls](#security-controls)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Secrets management involves secure storage, distribution, and lifecycle management of sensitive credentials and configuration.

### Key Benefits
1. **Secure Storage**
2. **Access Control**
3. **Audit Trail**
4. **Automated Rotation**
5. **Compliance**

## Prerequisites & Related Topics

- Builds on: [Authentication & Authorization](../system-basics/auth.md), encryption basics
- Used in: [Cloud Security](../cloud-native/cloud-security.md), [CI/CD pipelines](../cloud-native/kubernetes-orchestration.md), [Zero Trust](zero-trust.md)
- Techniques often combined: dynamic credentials, envelope encryption, workload identity, secret scanning
- See also: [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)


## Pattern Recognition Guide

### 🎯 When to Use Secrets Management

**Keywords in requirements**: "credentials", "API keys", "rotation", "vault", "leaked secret", "environment variables", "dynamic secrets"
**Reach for this when**:
- Service credentials for databases, queues, and third-party APIs
- CI/CD signing and deploy credentials
- Dynamic short-lived DB credentials issued per workload
- Certificate and key lifecycle (TLS, signing, encryption)

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Vault + dynamic secrets | issued per workload, auto-expiring | the target state |
| Static secrets + rotation job | scheduled updates | legacy constraints |
| Workload identity | platform-issued tokens replace secrets | Kubernetes/mesh estates |
| KMS envelope encryption | key material never leaves HSM | data encryption keys |

### ❌ When NOT to Use

- Secrets in environment variables treated as safe — they leak via logs, dumps, and /proc
- One shared secret per environment — per-workload identity, always
- Roll-your-own crypto or homegrown vaults


## Management Strategies

### 1. Vault Management
**How it works — Vault manager:** the vault is the single issuer of secrets — applications authenticate (machine identity), lease short-lived credentials, and renew before expiry; nothing long-lived is ever written into config or code.

### 2. Key Rotation
**How it works — Key rotation:** new keys are published before old ones retire, verification accepts both during the overlap, and old keys are revoked after — rotation becomes routine because nothing assumes a key lasts forever.

## Implementation Patterns

### 1. Secret Distribution
**How it works — Secret distributor:** secrets are delivered to workloads at boot via platform integration (K8s secrets from vault, injected environment) and refreshed on rotation — the distributor never writes secrets to disk or logs.

### 2. Access Control
**How it works — Secret access:** every read of a secret is authenticated (workload identity), authorized (policy), and logged — access patterns that deviate from baseline (new service, odd hours) raise an alert.

## Security Controls

### 1. Encryption Management
**How it works — Encryption manager:** centralizes key generation, storage (KMS/HSM), rotation, and audit; services request data-key operations instead of touching master keys — envelope encryption keeps key material off the data path.

### 2. Audit Logging
**How it works — Secret auditor:** Write the structured record at the moment the action happens — who, what, outcome — and ship it to the central store where retention and query tooling can make it useful later.

## Common Use Cases

### 1. Application Secrets
**How it works — App secrets:** secrets live in a vault with short-lived leases — never in code, images, or plain config — and every issuance is logged; "who could access the DB credentials" must have a real answer.

### 2. Infrastructure Secrets
**How it works — Infra secrets:** machine credentials (cloud keys, DB passwords, API tokens) are issued by the secrets manager to authenticated workloads, rotated automatically, and revoked on schedule — long-lived static keys are the finding.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Central vault (Vault/KMS) | Audited access, rotation, lease semantics | Extra dependency, availability criticality | Production systems |
| Environment variables | Zero setup | Leak via logs, dumps, child processes | Local dev only |
| Encrypted config in repo | Versioned, reviewable | Key management still needed | Small teams, config secrets |
| Cloud-native secret stores | IAM-integrated, managed | Provider coupling | Cloud-centric stacks |

**Rotation frequency vs operational risk:** Frequent rotation shrinks exposure windows and breaks services on schedule slips; automate rotation or it will not happen.

**Availability vs security:** A vault that is down stops deployments and startups — plan cached leases and break-glass access.

**Centralization vs blast radius:** One vault is a high-value target with strong controls; scattered secrets are weaker targets with no audit trail.

> **⚠️ When NOT to use environment variables:** anything past local development — env vars leak through logs, crash dumps, child processes, and CI artifacts; a vault or platform secret store with rotation is the production floor.

## Edge Cases to Consider

- Secret leaked in git history — rotate (revocation fixes it), scrub history second
- Break-glass credentials — sealed, audited, tested quarterly
- Rotation breaking running pods — leases must renew before expiry
- Secrets in crash dumps and traces — scrub at instrumentation


## Common Pitfalls

1. Everything is "not really a secret" until it leaks
2. No inventory — you cannot rotate what you cannot list
3. Manual rotation that never happens
4. Logging request headers including Authorization


## FAQ

**Q1: Environment variables or a vault?**

A: Env vars beat hardcoded values but leak widely; vaults with leases beat both. The goal is short-lived secrets delivered by identity, not configuration.

**Q2: A secret leaked — first move?**

A: Revoke and rotate first (it stops the bleeding), then investigate scope, then scrub history and fix the injection path. Rotation is the incident response.

**Q3: How short should a secret lifetime be?**

A: Minutes-to-hours for dynamic credentials where renewal is automatic; days at most for static ones with a scheduled rotation job.

## Interview Tips

### 1. Key Considerations
- Secret storage
- Access control
- Key rotation
- Audit logging
- Compliance requirements

### 2. Common Questions
1. How to manage secrets at scale?
2. How to implement rotation?
3. How to ensure security?
4. How to handle emergencies?

### 3. Best Practices
- Use vault systems
- Implement rotation
- Monitor access
- Encrypt everything
- Regular audits

## Advanced Topics

1. SPIFFE-style workload identity eliminating static secrets
2. Vault transit for cryptographic operations without key exposure
3. Policy-as-code for secret access (OPA boundaries)
4. HSM-backed root keys with split knowledge


## Further Reading
- [HashiCorp Vault](https://www.vaultproject.io/docs)
- [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)
- [NIST Key Management](https://csrc.nist.gov/projects/key-management)

