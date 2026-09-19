# GDPR Compliance in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [GDPR Requirements](#gdpr-requirements)
- [Implementation Patterns](#implementation-patterns)
- [Technical Controls](#technical-controls)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

GDPR compliance requires specific architectural considerations and technical controls in system design.

### Key Requirements
1. **Data Protection**
2. **User Rights**
3. **Consent Management**
4. **Data Minimization**
5. **Breach Notification**

## Prerequisites & Related Topics

- Builds on: [Data Privacy by Design](data-privacy.md), [Security Compliance](../security/security-compliance.md)
- Used in: [Logging](../observability/logging-practices.md), Data Pipelines, [Zero Trust](../security/zero-trust.md)
- Techniques often combined: consent records, residency controls, DSAR automation, DPIAs
- See also: [EDPB guidelines](https://www.edpb.europa.eu/) — supervisory authority guidance


## Pattern Recognition Guide

### 🎯 When to Use GDPR Compliance

**Keywords in requirements**: "GDPR", "lawful basis", "consent", "DSAR", "data processing agreement", "residency", "breach notification"
**Reach for this when**:
- Products serving EU users — regardless of where the company sits
- Marketing/analytics stacks with consent-gated processing
- Vendor ecosystems needing DPAs and subprocessor management
- Cross-border data flows with transfer mechanisms

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Consent management | opt-in records per purpose | marketing, analytics |
| Contract necessity | lawful basis for operational data | order fulfilment |
| Legitimate interest assessments | documented balancing tests | fraud, security |
| Residency partitioning | EU data stays in EU | strict interpretations |

### ❌ When NOT to Use

- One privacy policy for wildly different processing purposes
- Legitimate interest for marketing without a documented LIA
- Assuming non-EU hosting escapes jurisdiction — users are the trigger


## GDPR Requirements

### 1. Data Protection Principles
**How it works — Data protection principles:** Build once, promote the same artifact through environments, and shift traffic gradually — canary or blue/green — so a bad release is rolled back by a routing change, not a rebuild.

### 2. User Rights Management
**How it works — User rights manager:** entitlements are data, not code — the subject's roles/attributes are resolved per request into allowed actions, and every grant/deny is logged — "who can see this?" is a query, not a code audit.

## Implementation Patterns

### 1. Consent Management
**How it works — Consent manager:** user consent (purpose, scope, timestamp) is stored as a first-class record; every downstream use of personal data checks it, and withdrawal propagates as a deletion/anonymization event — proof for the DPO, enforcement for engineering.

### 2. Data Lifecycle Management
**How it works — Data lifecycle manager:** every dataset has a lifecycle — hot, warm, archived, purged — driven by age and access policy; retention rules are enforced by jobs, not by anyone remembering to delete.

## Technical Controls

### 1. Data Protection
**How it works — Data protection:** layered defenses: encryption at rest and in transit, access control at the data layer, and audit logging on every read of sensitive fields — protection follows the data, not just the perimeter.

### 2. Breach Notification
**How it works — Breach notification:** an incident triggers the documented play — scope the exposure, notify the regulator within the legal window (72h for GDPR), then affected users — with evidence preserved from the audit trail.

## Common Use Cases

### 1. User Data Management
**How it works — User data manager:** profile and preference data is read-heavy and session-critical — cache aggressively, keep the authoritative store consistent, and version schema changes backward-compatibly so old clients never break.

### 2. Privacy by Design
**How it works — Privacy by design:** Map the requirement to a technical control (encryption, retention job, access review), generate the evidence automatically, and keep it queryable for the auditor's window.

## Trade-offs

| Requirement | Design Impact | Cost of Compliance |
|-------------|---------------|--------------------|
| Right to erasure | Deletion must reach backups, caches, and analytics | Impossible with naive immutable logs; needs crypto-shredding or TTL design |
| Data minimization | Fewer fields collected | Less ML fuel, weaker features |
| Consent management | Consent state per user per purpose | Complexity in every pipeline |
| Data portability | Clean export formats | Export infrastructure |
| Residency requirements | Region-pinned storage | Limits global replication and failover |

**Privacy vs functionality:** GDPR pushes designs toward minimal collection, which can constrain personalization and analytics — a product trade-off, not just a legal one.

**Immutability vs erasure:** Event-sourced and append-only architectures need crypto-shredding or targeted deletion paths designed in from day one.

**Global systems vs regional law:** Residency and transfer rules fragment otherwise-global architectures; plan data domains per jurisdiction.

> **⚠️ When NOT to rely on crypto-shredding alone:** data already copied into analytics derivatives and third-party systems — erasure design must cover every downstream copy, or the right-to-erasure flow is fiction.

## Edge Cases to Consider

- 72-hour breach clock starting before full scope is known
- Consent withdrawal propagating to analytics downstream
- Subprocessors changing without notice obligations
- International transfers after Schrems II — SCCs plus transfer assessments


## Common Pitfalls

1. Pre-ticked consent boxes (invalid) and dark patterns
2. Personal data in error logs and support screenshots
3. No records of processing (Article 30) — the audit's first ask
4. Ignoring derived data: features and models inherit obligations


## FAQ

**Q1: Who must comply with GDPR?**

A: Anyone processing EU residents' personal data for offering goods/services or monitoring behavior — location of the company does not matter.

**Q2: Consent vs legitimate interest?**

A: Consent is opt-in, revocable, and needed for marketing-ish uses; legitimate interest covers operational uses (fraud, security) backed by a documented balancing test. Pick per purpose, document the choice.

**Q3: What are the real engineering obligations?**

A: Subject-rights automation (30-day SLA), breach detection and notification workflows (72h), consent enforcement in pipelines, and records of processing kept current — all architectural commitments.

## Interview Tips

### 1. Key Considerations
- Data protection measures
- User rights implementation
- Consent management
- Breach handling
- Documentation requirements

### 2. Common Questions
1. How to implement right to be forgotten?
2. How to handle data portability?
3. How to manage consent?
4. How to ensure data minimization?

### 3. Best Practices
- Privacy by design
- Regular audits
- Clear documentation
- Staff training
- Incident response plan

## Advanced Topics

1. Consent orchestration across analytics/ML stacks
2. Automated DSAR fulfilment with lineage resolution
3. Privacy-enhancing tech: differential privacy, secure aggregation
4. Data residency architecture with regional cell deployments


## Further Reading
- [GDPR Official Text](https://gdpr-info.eu/)
- [Privacy by Design](https://www.ipc.on.ca/wp-content/uploads/resources/7foundationalprinciples.pdf)
- [GDPR Technical Implementation](https://www.enisa.europa.eu/publications/guidelines-for-smes-on-the-security-of-personal-data-processing)

