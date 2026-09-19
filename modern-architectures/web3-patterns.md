# Web3 Architecture Patterns in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Architecture Components](#architecture-components)
- [Implementation Patterns](#implementation-patterns)
- [Integration Strategies](#integration-strategies)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Web3 architecture patterns focus on building decentralized applications (dApps) using blockchain and peer-to-peer technologies.

### Key Benefits
1. **Decentralization**
2. **User Ownership**
3. **Transparency**
4. **Trustless Operation**
5. **Token Economics**

## Prerequisites & Related Topics

- Builds on: [Blockchain Systems](blockchain-systems.md), [API Design](../system-basics/api-design.md)
- Used in: [Event-Driven Architecture](../scalability/event-driven.md), [Caching](../system-basics/caching.md), [API Security](../security/api-security.md)
- Techniques often combined: event indexers, IPFS storage, wallet-based auth (SIWE), multi-chain RPC gateways
- See also: [Ethereum org docs](https://ethereum.org/en/developers/docs/eth2/) — protocol references


## Pattern Recognition Guide

### 🎯 When to Use Web3 Architecture Patterns

**Keywords in requirements**: "web3", "wallet", "dapp", "on-chain", "indexer", "gas", "NFT", "token gating"
**Reach for this when**:
- NFT marketplaces: on-chain ownership, off-chain metadata and search
- Wallet-based login replacing passwords (Sign-In with Ethereum)
- Token-gated access control for content and communities
- DeFi dashboards reading indexed chain events

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Read-heavy indexer | chain events → queryable DB | dashboards, marketplaces |
| Write-minimal dapp | client signs, contract settles | pure DeFi frontends |
| Hybrid custody | server wallets for gas/automation | onboarding-friendly apps |

### ❌ When NOT to Use

- Everything on-chain — storage and gas costs are orders higher; keep data off-chain, hashes on
- Trust-minimal claims about off-chain components — your indexer is centralized, say so
- Real-time game loops settling on-chain — latency and cost forbid it


## Architecture Components

### 1. Smart Contract Layer
**How it works — Smart contract layer:** Write the transaction to the shared ledger, wait for consensus/quorum, and read back the deterministic result — trust comes from the protocol's economics and cryptography, not from any operator.

### 2. Decentralized Storage
**How it works — Decentralized storage:** files are split, hashed, and erasure-coded across many nodes; content is retrieved by hash from whoever stores a chunk — no central operator, availability pinned by replication incentives and payments.

## Implementation Patterns

### 1. Web3 Integration
**How it works — Web 3 integration:** the backend bridges two worlds — it indexes chain events into queryable stores and submits user-signed transactions to the chain; the blockchain is the settlement layer, the API remains the convenience layer.

### 2. Token Management
**How it works — Token manager:** issues, refreshes, and revokes: short-lived access tokens, rotating refresh tokens, and a real revocation path for logout — the manager owns lifetimes so services only ever validate.

## Integration Strategies

### 1. Frontend Integration
**How it works — Frontend integration:** the shell composes independently deployed fragments — at build time, at runtime via a loader, or server-side — with shared design tokens for consistency; each team ships its fragment without a coordinated release.

### 2. Backend Services
**How it works — Backend services:** each service owns its data store and exposes a narrow API; they communicate over the network with versioned contracts, so teams deploy independently without stepping on each other.

## Common Use Cases

### 1. DeFi Application
**How it works — De fi app:** the app is a thin client over smart contracts — the user signs transactions with their wallet, the chain executes the logic deterministically, and the UI reads state from an indexer rather than a backend it controls.

### 2. NFT Marketplace
**How it works — NFT marketplace:** Write the transaction to the shared ledger, wait for consensus/quorum, and read back the deterministic result — trust comes from the protocol's economics and cryptography, not from any operator.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Fully on-chain | Maximum verifiability, composability | Cost, latency, privacy exposure | Core value logic, small state |
| Off-chain compute + on-chain proofs (L2/rollups) | Scale with security anchors | Exit/bridge complexity, tooling maturity | High-throughput dApps |
| Centralized indexing/APIs (The Graph, Infura) | Fast queries, easy dev | Trust and availability dependencies | Read-heavy frontends |
| Self-hosted nodes | Full sovereignty | Operational burden | Infrastructure-sensitive products |

**Decentralization vs usability:** Key management and gas costs are UX taxes; custody abstractions improve onboarding and reintroduce trusted parties.

**Immutability vs iteration:** Upgradable contracts enable bug fixes and centralization concerns; immutable contracts are trustworthy and stuck with their bugs.

**Cost models:** Every on-chain operation costs users; push computation off-chain and anchor results on-chain.

> **⚠️ When NOT to put logic on-chain:** high-frequency or user-facing computations (gas and latency), private data, and anything needing frequent upgrades — anchor proofs on-chain, compute off-chain.

## Edge Cases to Consider

- Chain reorgs invalidating confirmed-looking events — indexers must rewind
- NFT metadata hosted on mutable URLs — content-addressed storage (IPFS)
- Gas price volatility breaking fee assumptions in UX
- Key management for app-controlled wallets — custody risk


## Common Pitfalls

1. Building the whole product on-chain when one hash anchor suffices
2. Trusting a single RPC provider — outage or front-running risk
3. Ignoring confirmation-depth requirements for high-value actions
4. Unbounded indexer history without snapshots


## FAQ

**Q1: What does "on-chain vs off-chain" split look like?**

A: Ownership, value, and integrity proofs on-chain; everything user-facing — search, profiles, media — off-chain, anchored by hashes. The chain is the settlement layer, not the app server.

**Q2: How do wallets authenticate users?**

A: The wallet signs a challenge (SIWE); your backend verifies the signature against the claimed address. No passwords — but session management and nonce handling stay your job.

**Q3: What is the biggest operational surprise?**

A: Reorgs and RPC reliability. Indexers must handle chain rewrites, and production dapps need multi-provider RPC failover — the chain is not your uptime story.

## Interview Tips

### 1. Key Considerations
- Decentralization level
- Smart contract security
- Storage strategy
- User experience
- Gas optimization

### 2. Common Questions
1. How to handle decentralization?
2. How to ensure security?
3. How to optimize gas?
4. How to improve UX?

### 3. Best Practices
- Security first
- Gas optimization
- User experience
- Error handling
- Testing strategy

## Advanced Topics

1. The Graph-style subgraphs and decentralized indexing
2. Account abstraction: sponsored gas and session keys
3. ZK proofs for privacy-preserving verification
4. Multi-chain event normalization layers


## Further Reading
- [Web3.js Documentation](https://web3js.readthedocs.io/)
- [IPFS Documentation](https://docs.ipfs.io/)
- [Smart Contract Security](https://consensys.github.io/smart-contract-best-practices/)

