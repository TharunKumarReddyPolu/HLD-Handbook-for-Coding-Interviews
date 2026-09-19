# Cloud Security in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Security Components](#security-components)
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

Cloud security patterns provide standardized approaches to securing cloud infrastructure and applications.

### Key Benefits
1. **Data Protection**
2. **Access Control**
3. **Threat Detection**
4. **Compliance**
5. **Risk Mitigation**

## Prerequisites & Related Topics

- Builds on: [Authentication & Authorization](../system-basics/auth.md), networking basics
- Used in: [Zero Trust](../security/zero-trust.md), [Secrets Management](../security/secrets-management.md), [Security Compliance](../security/security-compliance.md)
- Techniques often combined: IAM policies, KMS envelope encryption, security groups, CSPM scans
- See also: [Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/) — what the provider covers vs you


## Pattern Recognition Guide

### 🎯 When to Use Cloud Security

**Keywords in requirements**: "IAM", "least privilege", "encryption at rest", "network policy", "misconfiguration", "cloud posture"
**Reach for this when**:
- Every cloud workload — identity boundaries replace network boundaries
- Multi-account/landing-zone isolation for blast radius
- Data protection via KMS-managed keys and tiered access
- Continuous posture checks on public exposure and policy drift

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| IAM roles per service | workload identity, no static keys | the default posture |
| Security groups + NACLs | segmented trust zones | network defense in depth |
| KMS + envelope encryption | audited key usage | sensitive data stores |
| CSPM tooling | drift and exposure detection |  fleets of any size |

### ❌ When NOT to Use

- SSH-ing to instances for ops — use SSM/bastion-less access with audit
- Long-lived access keys in code or CI — short-lived federated roles
- Security group sprawl — document intent, generate rules


## Security Components

### 1. Identity and Access Management
**How it works — Iammanager:** every request resolves to principal → roles/policies → allowed action on resource, evaluated centrally; least privilege is the default and standing access is replaced by just-in-time elevation.

### 2. Network Security
**How it works — Network security:** segment into trust zones with default-deny between them, encrypt traffic in transit, and expose only what must be public — the network is a boundary, not a moat; assume breach inside it.

## Implementation Patterns

### 1. Data Protection
**How it works — Data protection:** layered defenses: encryption at rest and in transit, access control at the data layer, and audit logging on every read of sensitive fields — protection follows the data, not just the perimeter.

### 2. Security Monitoring
**How it works — Security monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Security Controls

### 1. Compliance Controls
**How it works — Compliance controls:** Map the requirement to a technical control (encryption, retention job, access review), generate the evidence automatically, and keep it queryable for the auditor's window.

### 2. Technical Controls
**How it works — Technical controls:** each policy maps to an enforced mechanism — retention jobs for retention policy, IAM least-privilege for access policy, encryption for data protection — and each control produces its own audit evidence.

## Common Use Cases

### 1. Cloud Workload Protection
**How it works — Workload protection:** protect running workloads, not just the perimeter — image scanning, runtime policies, least-privilege service identity — so a running process can only do what its policy allows.

### 2. Data Security
**How it works — Data security:** classify data first (public/internal/confidential/PII), then apply controls per class — encryption, access rules, retention, masking — and verify with audits; controls without classification are guesswork.

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| Tight IAM policies | Minimal blast radius | Policy sprawl, operational friction | Production, regulated data |
| Broad IAM policies | Easy onboarding, fewer blocks | Large blast radius, audit pain | Sandboxes, experiments |
| Private networking | Reduced exposure | Access complexity (bastions, peering) | Data stores, internal services |
| Public endpoints with auth | Simple access, CDN-friendly | Larger attack surface | Public APIs behind WAF |

**Security vs operability:** Every hardening step (least privilege, private subnets, encryption keys) adds friction; automate policy to keep both.

**Shared responsibility:** Cloud providers secure the infrastructure; you secure identity, configuration, and data — misconfiguration, not the provider, is the usual breach cause.

**Key management depth:** Customer-managed keys add control and auditability at the cost of rotation, recovery, and availability responsibilities.

> **⚠️ When NOT to over-restrict IAM:** sandbox and experiment accounts where velocity matters more than blast radius — apply least privilege in production, and automate guardrails instead of routing everything through manual tickets.

## Edge Cases to Consider

- Public S3 bucket via one flag — posture scans + deny-by-default org policies
- Cross-account access done by copying keys — assume-role instead
- Egress to arbitrary internet — allow-list destinations
- Metadata endpoint abuse (SSRF) — IMDSv2-style protections


## Common Pitfalls

1. Wildcard IAM actions/resources because scoped policies are tedious
2. Encryption without key governance — theater if keys sit next to data
3. No audit trail review — CloudTrail is evidence, not a control
4. Treating compliance certification as security


## FAQ

**Q1: What is the first cloud security control to get right?**

A: IAM — service roles with exact permissions. Most cloud breaches are over-privileged identity plus one misconfiguration, not exotic attacks.

**Q2: Who is responsible for what?**

A: Provider secures the infrastructure; you secure identity, configuration, data, and access. "Managed" never means "secure by default".

**Q3: How do I prevent the public-bucket class of incident?**

A: Org-level guardrails: block public access at account level, deny policies, and CSPM alerts — prevention plus detection, not either.

## Interview Tips

### 1. Key Considerations
- Security architecture
- Compliance requirements
- Threat model
- Incident response
- Automation

### 2. Common Questions
1. How to secure cloud workloads?
2. How to implement zero trust?
3. How to handle data security?
4. How to ensure compliance?

### 3. Best Practices
- Defense in depth
- Least privilege
- Regular audits
- Automated security
- Incident response plan

## Advanced Topics

1. GuardDuty/Anomaly detection on identity and network signals
2. Infrastructure-as-code security gates (tfsec, Checkov)
3. Identity federation with short-lived tokens everywhere
4. Chaos-style validation of security controls


## Further Reading
- [Cloud Security Alliance](https://cloudsecurityalliance.org/)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)
- [GCP Security Blueprint](https://cloud.google.com/architecture/security-foundations)

