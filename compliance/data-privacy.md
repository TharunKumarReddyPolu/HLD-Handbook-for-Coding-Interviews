# Data Privacy by Design in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Privacy Patterns](#privacy-patterns)
- [Implementation Strategies](#implementation-strategies)
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

Data privacy patterns provide reusable solutions for implementing privacy requirements in system design.

### Key Benefits
1. **Regulatory Compliance**
2. **User Trust**
3. **Risk Mitigation**
4. **Data Protection**
5. **Privacy by Design**

## Prerequisites & Related Topics

- Builds on: [GDPR](gdpr-compliance.md), [Data Modeling](../data-engineering/data-modeling.md)
- Used in: [Logging](../observability/logging-practices.md), [Data Quality](../data-engineering/data-quality.md), [Security Compliance](../security/security-compliance.md)
- Techniques often combined: data classification, pseudonymization, retention jobs, DSAR pipelines
- See also: [GDPR official text](https://gdpr-info.eu/) — the primary regulatory source


## Pattern Recognition Guide

### 🎯 When to Use Data Privacy by Design

**Keywords in requirements**: "PII", "personal data", "minimization", "retention", "right to be forgotten", "consent", "data mapping"
**Reach for this when**:
- Any product storing user data — privacy is architectural, not a policy doc
- Analytics pipelines needing pseudonymized user identifiers
- Multi-jurisdiction deployments with residency requirements
- AI training data governance (consent, provenance)

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Minimization-first | collect less, keep shorter | the cheapest privacy control |
| Pseudonymization vaults | identifiers replaced, vault separate | analytics on user data |
| Purpose-based access | access scoped to declared purpose | large data platforms |
| Automated DSAR | export/delete as pipelines | GDPR-scale operations |

### ❌ When NOT to Use

- Anonymization claims on data that is pseudonymous — re-identification risk stays
- Retention "forever because analytics" — cost and risk compound
- Privacy review after launch — retrofitting is 10x the cost


## Privacy Patterns

### 1. Data Minimization
**How it works — Data minimization:** collect and retain only what a stated purpose requires — GDPR's minimization principle — which shrinks storage cost, breach blast radius, and compliance surface all at once.

### 2. Pseudonymization
**How it works — Pseudonymization:** direct identifiers are replaced by deterministic tokens held in a separate vault; analytics works on the pseudonymized data, and re-identification requires access to the vault — a middle ground between raw and anonymous.

## Implementation Strategies

### 1. Privacy by Design
**How it works — Privacy by design:** Map the requirement to a technical control (encryption, retention job, access review), generate the evidence automatically, and keep it queryable for the auditor's window.

### 2. Access Control
**How it works — Privacy access control:** Map the requirement to a technical control (encryption, retention job, access review), generate the evidence automatically, and keep it queryable for the auditor's window.

## Technical Controls

### 1. Data Encryption
**How it works — Data encryption:** encrypt at rest (KMS-managed keys, envelope encryption) and in transit (TLS everywhere); keys live in a separate trust domain from the data, and rotation is scheduled — ciphertext without key separation is compliance theater.

### 2. Audit Logging
**How it works — Privacy audit:** Write the structured record at the moment the action happens — who, what, outcome — and ship it to the central store where retention and query tooling can make it useful later.

## Common Use Cases

### 1. Personal Data Handling
**How it works — Personal data handler:** personal data is tagged as such at ingestion, flows only through approved paths, and every access is logged with purpose — accountability requires knowing where the PII is, always.

### 2. Data Subject Rights
**How it works — Data subject rights:** GDPR grants access, rectification, erasure, and portability; each becomes an automated pipeline — locate the subject's records across stores, export or delete them, record the fulfillment — so the 30-day SLA is met by machinery.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Collect minimal data | Smallest compliance surface, lowest breach impact | Feature limitations, weaker analytics | Privacy-first products |
| Collect broadly | Rich features and ML | Regulatory exposure, retention burden | Data-centric products (with governance) |
| Pseudonymization | Analytics with reduced risk | Re-identification risk remains | Internal analytics |
| Encryption everywhere | Strong protection | Key management, query complexity | Sensitive PII |
| Tokenization | Safe downstream processing | Token vault to operate | Payments, identifiers |

**Utility vs privacy:** Every anonymization step reduces data utility; match de-identification depth to actual sensitivity and regulation.

**Retention vs risk:** Long retention powers historical analysis and grows liability; automated deletion turns policy into architecture.

**Compliance by design vs retrofit:** Embedding privacy controls early costs less than bolting them on after a regulator (or breach) forces the issue.

> **⚠️ When NOT to encrypt-and-call-it-private:** encryption without key discipline is theater — for public data it adds cost without risk reduction, and for PII it must pair with access controls and minimization, not replace them.

## Edge Cases to Consider

- Deleting users from systems that were built to never forget — lineage maps first
- PII leaking into logs, caches, and backups
- Third-party processors sharing your obligations
- Derived datasets (ML features) retaining deleted identities


## Common Pitfalls

1. No data inventory — you cannot protect or delete what you cannot find
2. Consent captured but not enforced downstream
3. Hardcoded retention on one system while five copies live elsewhere
4. Privacy reviews as checkboxes instead of architecture decisions


## FAQ

**Q1: Where does privacy start in system design?**

A: With minimization and a data map: what is collected, where it flows, how long it lives. Every control downstream depends on that inventory.

**Q2: Pseudonymized vs anonymized?**

A: Pseudonymized data can be re-linked with the vault; anonymized cannot reasonably be. GDPR treats pseudonymous data as personal data — plan controls accordingly.

**Q3: How do we implement "right to erasure" practically?**

A: A DSAR pipeline: resolve the subject's identifiers across the data map, delete/anonymize in each store (including caches and derived sets), and log the fulfillment for the audit trail.

## Interview Tips

### 1. Key Considerations
- Privacy requirements
- Data protection measures
- Access control
- Audit requirements
- Incident response

### 2. Common Questions
1. How to implement data minimization?
2. How to handle sensitive data?
3. How to ensure data privacy?
4. How to implement audit trails?

### 3. Best Practices
- Implement privacy by design
- Use strong encryption
- Regular privacy impact assessments
- Clear documentation
- Employee training

## Advanced Topics

1. Automated data discovery/classification scanning stores
2. Cryptographic erasure: deleting keys renders data unusable
3. Differential privacy for analytics releases
4. Privacy-preserving record linkage across systems


## Further Reading
- [Privacy Patterns](https://privacypatterns.org/)
- [NIST Privacy Framework](https://www.nist.gov/privacy-framework)
- [Privacy by Design](https://www.ipc.on.ca/wp-content/uploads/resources/7foundationalprinciples.pdf)

