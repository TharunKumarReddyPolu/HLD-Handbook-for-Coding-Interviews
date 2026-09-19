# Security Compliance in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Compliance Framework](#compliance-framework)
- [Implementation Strategies](#implementation-strategies)
- [Control Implementation](#control-implementation)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Security compliance in design ensures systems meet regulatory requirements and security standards from the ground up.

### Key Benefits
1. **Regulatory Compliance**
2. **Risk Management**
3. **Security Assurance**
4. **Audit Readiness**
5. **Trust Building**

## Prerequisites & Related Topics

- Builds on: [Cloud Security](../cloud-native/cloud-security.md), [Data Privacy](../compliance/data-privacy.md)
- Used in: [GDPR](../compliance/gdpr-compliance.md), [Logging & audit](../observability/logging-practices.md), [Secrets Management](secrets-management.md)
- Techniques often combined: control matrices, evidence automation, access reviews, policy-as-code
- See also: [SOC 2](https://www.aicpa-cima.com/topic/audit-assurance/audit-and-assurance-greater-than-soc-2) and [ISO 27001](https://www.iso.org/standard/27001) — the common frameworks


## Pattern Recognition Guide

### 🎯 When to Use Security Compliance

**Keywords in requirements**: "SOC 2", "ISO 27001", "PCI", "HIPAA", "audit", "controls", "evidence", "access review"
**Reach for this when**:
- B2B sales requiring SOC 2 before contracts sign
- PCI scope reduction isolating cardholder data environments
- Continuous compliance monitoring replacing annual panic
- Customer security questionnaires answered from living documentation

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| SOC 2 Type II | operational effectiveness over time | SaaS vendors |
| ISO 27001 | ISMS certification | international enterprise |
| PCI DSS | cardholder data protection | payments |
| HIPAA | health data safeguards | health tech |

### ❌ When NOT to Use

- Certification as security — controls map to risk, not to passing audits
- Evidence collection by hand every audit cycle
- Compliance work owned by nobody until the auditor books travel


## Compliance Framework

### 1. Framework Selection
**How it works — Compliance framework:** Map the requirement to a technical control (encryption, retention job, access review), generate the evidence automatically, and keep it queryable for the auditor's window.

### 2. Control Matrix
**How it works — Control matrix:** a table mapping every requirement (GDPR article, SOC 2 criterion) to controls, systems, and owners — it turns "are we compliant?" into a checklist review instead of an archaeology project.

## Implementation Strategies

### 1. Control Implementation
**How it works — Control implementation:** each compliance requirement maps to a technical control (encryption at rest, access reviews, retention jobs) with an owner and evidence generation — the auditor reads the evidence, engineering produces it once, automatically.

### 2. Compliance Monitoring
**How it works — Compliance monitor:** Collect the signal on a schedule, evaluate it against the defined threshold or SLO, and route any breach to the right channel with enough context to act without digging.

## Control Implementation

### 1. Technical Controls
**How it works — Technical controls:** each policy maps to an enforced mechanism — retention jobs for retention policy, IAM least-privilege for access policy, encryption for data protection — and each control produces its own audit evidence.

### 2. Administrative Controls
**How it works — Admin controls:** privileged actions live behind separate authorization (admin role + step-up auth + audit log), so a compromised user session still cannot grant itself admin or exfiltrate the user list.

## Common Use Cases

### 1. Financial Services
**How it works — Financial compliance:** Build once, promote the same artifact through environments, and shift traffic gradually — canary or blue/green — so a bad release is rolled back by a routing change, not a rebuild.

### 2. Healthcare Systems
**How it works — Healthcare compliance:** Map the requirement to a technical control (encryption, retention job, access review), generate the evidence automatically, and keep it queryable for the auditor's window.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Early compliance-by-design | Cheaper than retrofit, audit-ready | Slower initial development | Regulated products |
| Compliance as afterthought | Fast start | Expensive rework, launch blockers | Rarely defensible |
| Broad framework certification (SOC 2, ISO) | Unlocks enterprise sales | Continuous audit cost | B2B platforms |
| Narrow, targeted compliance | Cheaper, focused | Re-scoping as product grows | Single regulated feature |

**Controls vs velocity:** Every mandatory control (approvals, segregation of duties, encryption gates) adds latency to delivery — automate evidence collection to reduce friction.

**Documentation depth vs usefulness:** Auditors want exhaustive evidence; engineers want lean docs — automated, code-generated evidence serves both.

**Data minimization vs feature richness:** Collecting less data simplifies compliance more than any tool; product decisions are compliance decisions.

> **⚠️ When NOT to chase certification:** pre-product-market-fit startups selling to consumers, and teams that would bolt controls on instead of building them in — target the specific commitments your customers actually ask for first.

## Edge Cases to Consider

- Scope creep pulling the whole company into audit
- Subprocessors and vendors sharing your compliance burden
- Access reviews that rubber-stamp — automate detection of stale grants
- Cross-border data flows inside an otherwise clean control set


## Common Pitfalls

1. Buying tooling without fixing the underlying process
2. Policies nobody follows — auditors test practice, not documents
3. No single owner — compliance by committee is compliance by nobody
4. Treating audit findings as one-time fixes without re-testing


## FAQ

**Q1: Compliance vs security?**

A: Compliance is the floor and the evidence layer; security is the practice. You can pass audits while insecure and be secure while failing audits — aim for controls that are both real and provable.

**Q2: How do I reduce audit cost?**

A: Narrow the scope, automate evidence (access reviews, change tickets, monitoring exports), and cross-map one control set to multiple frameworks.

**Q3: What should engineers actually do for compliance?**

A: Follow change management, keep access least-privilege, ship audit logs on sensitive actions, and respond to access reviews — the controls live in engineering routines.

## Interview Tips

### 1. Key Considerations
- Regulatory requirements
- Control implementation
- Monitoring strategy
- Documentation
- Audit preparation

### 2. Common Questions
1. How to ensure compliance?
2. How to implement controls?
3. How to prepare for audits?
4. How to maintain compliance?

### 3. Best Practices
- Regular assessments
- Continuous monitoring
- Clear documentation
- Staff training
- Incident response

## Advanced Topics

1. Continuous controls monitoring with real evidence pipelines
2. Compliance-as-code in IaC (deny policies, pre-approval)
3. Zero-downtime re-certification strategies
4. Framework cross-mapping to satisfy many audits from one control set


## Further Reading
- [ISO 27001 Standard](https://www.iso.org/isoiec-27001-information-security.html)
- [PCI DSS Requirements](https://www.pcisecuritystandards.org/)
- [HIPAA Security Rule](https://www.hhs.gov/hipaa/for-professionals/security/)

