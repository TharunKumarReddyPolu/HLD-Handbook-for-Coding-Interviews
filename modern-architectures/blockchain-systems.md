# Blockchain Systems in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [System Components](#system-components)
- [Implementation Patterns](#implementation-patterns)
- [Consensus Mechanisms](#consensus-mechanisms)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Blockchain systems provide distributed, immutable ledgers with smart contract capabilities for decentralized applications.

### Key Benefits
1. **Decentralization**
2. **Immutability**
3. **Transparency**
4. **Security**
5. **Smart Contracts**

## Prerequisites & Related Topics

- Builds on: [Consensus](../system-basics/distributed-systems.md), cryptography basics
- Used in: [Web3 Patterns](web3-patterns.md), [Payment systems](../case-studies/e-commerce-platform.md), [Auditing](../compliance/data-privacy.md)
- Techniques often combined: smart contracts, off-chain indexing, oracles, L2 rollups
- See also: [Ethereum developer docs](https://ethereum.org/en/developers/docs/) — reference architecture


## Pattern Recognition Guide

### 🎯 When to Use Blockchain Systems

**Keywords in requirements**: "decentralized", "trustless", "ledger", "consensus", "smart contract", "token", "immutability"
**Reach for this when**:
- Transfers of value without a trusted intermediary
- Provenance/audit trails where participants distrust each other
- Programmable money (escrow, DeFi primitives)
- Cross-organization workflows with neutral settlement

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Public L1/L2 | permissionless, token economics | value transfer, DeFi |
| Private/consortium | known validators, throughput | enterprise workflows |
| Off-chain + on-chain anchors | hash commitments for integrity | document provenance |

### ❌ When NOT to Use

- Participants trust one party or one DB admin — use a database
- Data that must be deletable (GDPR) — immutability conflicts
- High-throughput low-latency app backends — consensus latency dominates


## System Components

### 1. Node Architecture
**How it works — Blockchain node:** Write the transaction to the shared ledger, wait for consensus/quorum, and read back the deterministic result — trust comes from the protocol's economics and cryptography, not from any operator.

### 2. Smart Contracts
**How it works — Smart contract:** Write the transaction to the shared ledger, wait for consensus/quorum, and read back the deterministic result — trust comes from the protocol's economics and cryptography, not from any operator.

## Implementation Patterns

### 1. Transaction Processing
**How it works — Transaction processor:** group the read-check-write into one ACID transaction (or an idempotent saga across services); idempotency keys make client retries safe, and isolation levels decide what concurrent anomalies are possible.

### 2. State Management
**How it works — State manager:** state is classified first — ephemeral (in memory), session (Redis), durable (database) — and each lives in the cheapest layer that meets its durability and latency needs; components stay restartable at any moment.

## Consensus Mechanisms

### 1. Proof of Stake
**How it works — Proof of stake:** validators lock stake as collateral; the protocol selects proposers weighted by stake and penalizes misbehavior by slashing it — security shifts from burning electricity to the cost of attacking one's own deposit.

### 2. Consensus Engine
**How it works — Consensus engine:** a leader is elected, appends each change to its log, replicates to followers, and commits once a majority acknowledges — the committed log then applies in order everywhere, tolerating minority node failures.

## Common Use Cases

### 1. DeFi Platform
**How it works — De fi platform:** core logic lives in immutable smart contracts (AMM pools, lending markets) that anyone can call permissionlessly; oracles feed external prices, and upgradeability — if any — is itself a governed, audited contract change.

### 2. NFT Marketplace
**How it works — NFT marketplace:** Write the transaction to the shared ledger, wait for consensus/quorum, and read back the deterministic result — trust comes from the protocol's economics and cryptography, not from any operator.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Public permissionless | Trustless, censorship-resistant | Throughput limits, latency, cost | Open-value transfer |
| Private/permissioned | High throughput, known validators | Trust assumptions return | Enterprise consortia |
| On-chain data | Verifiability, permanence | Expensive storage, privacy exposure | Proofs, anchors |
| Off-chain data + hashes | Cheap, private | Requires off-chain availability | Documents, media |

**Decentralization vs performance:** Every consensus strengthening (more validators, more replication) costs throughput — the scalability trilemma in practice.

**Immutability vs correction:** Immutable ledgers guarantee history and make bug-fixing migrations painful; design upgradability carefully.

**Finality vs availability:** Probabilistic finality stays available under partitions; absolute finality stalls rather than forks.

> **⚠️ When NOT to use a blockchain:** when participants trust one party or a consortium coordinates easily (a database is faster and cheaper), data must stay private, and tamper-evidence isn't required — most proposed use cases fail this test.

## Edge Cases to Consider

- Smart contract bugs are immutable bugs — audits and upgrade patterns
- Oracle manipulation of off-chain prices
- Key loss = asset loss — custody is a UX and security problem
- MEV/reordering attacks on transaction flow


## Common Pitfalls

1. Blockchain as a marketing word for "shared database"
2. Putting PII on-chain — immutability meets privacy law
3. Ignoring fee volatility in product economics
4. Assuming finality guarantees across all chains equally


## FAQ

**Q1: Blockchain vs database?**

A: A database has an administrator and cheap reversals; a blockchain has no administrator and expensive consensus. Choose by trust model, not by trend.

**Q2: What is finality?**

A: The point where a transaction cannot be reverted — deterministic (instant in some BFT chains, PoS checkpoints) or probabilistic (deepen with confirmations). Design UX and risk around the difference.

**Q3: How do real systems combine chain and database?**

A: On-chain for settlement and integrity, off-chain indexes/databases for query speed — the chain anchors truth, the indexer serves reads.

## Interview Tips

### 1. Key Considerations
- Consensus mechanism
- Scalability solution
- Security model
- Smart contract design
- Network topology

### 2. Common Questions
1. How to ensure scalability?
2. How to handle forks?
3. How to secure contracts?
4. How to optimize gas?

### 3. Best Practices
- Security first
- Gas optimization
- Proper testing
- Upgrade planning
- Monitoring setup

## Advanced Topics

1. L2 rollups: optimistic vs ZK validity proofs
2. Account abstraction for wallet UX
3. Cross-chain bridges and their trust models
4. Zero-knowledge proofs for compliance-preserving verification


## Further Reading
- [Ethereum Documentation](https://ethereum.org/developers/)
- [Blockchain Architecture](https://www.hyperledger.org/learn/white-papers)
- [Smart Contract Security](https://consensys.github.io/smart-contract-best-practices/)

