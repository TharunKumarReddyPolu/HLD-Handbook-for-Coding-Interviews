# Real-Time Collaboration in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [System Components](#system-components)
- [Architecture Patterns](#architecture-patterns)
- [Implementation Strategies](#implementation-strategies)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

Real-time collaboration systems enable multiple users to work together simultaneously on shared resources.

### Key Components
1. **Operational Transform**
2. **CRDT (Conflict-free Replicated Data Types)**
3. **State Synchronization**
4. **Presence Management**
5. **Conflict Resolution**

## Prerequisites & Related Topics

- Builds on: [WebSocket patterns](../case-studies/real-time-chat.md), [Caching](../system-basics/caching.md)
- Used in: [Event-Driven Architecture](../scalability/event-driven.md), [Presence systems](#), [Offline-first apps](edge-computing.md)
- Techniques often combined: operation logs, vector clocks, presence heartbeats, snapshot compaction
- See also: [CRDT notes](https://crdt.tech/) — conflict-free replication resources


## Pattern Recognition Guide

### 🎯 When to Use Real-Time Collaboration

**Keywords in requirements**: "collaborative editing", "OT", "CRDT", "concurrent edits", "presence", "consistency", "offline merge"
**Reach for this when**:
- Multi-user documents, whiteboards, design tools
- Shared state across devices with offline tolerance
- Live cursors/presence with cheap heartbeats
- Low-latency co-editing across geographies

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Operational Transform (OT) | server orders and transforms ops | Google Docs lineage |
| CRDT (RGA, LWW-map) | decentralized merge, offline-first | peer/federated editing |
| Server authority + locks | simpler consistency | cell/section-locked tools |

### ❌ When NOT to Use

- Unstructured free-form conflict tolerance needed only rarely — locks suffice
- Very high edit rates without compaction — history grows unbounded
- Strong consistency across huge fan-out — pick your conflicts deliberately


## System Components

### 1. Operational Transform
**How it works — Operational transform:** each edit is an operation applied at a position; when concurrent operations arrive, later ones are transformed against earlier ones so every replica converges to the same text — Google Docs' classic approach.

### 2. CRDT Implementation
**How it works — CRDT system:** every replica applies merge operations that are commutative, associative, and idempotent — so concurrent edits converge no matter the order they arrive, without coordination. Counters, sets, and text (RGA) each have such merge rules; the cost is metadata and no global ordering.

## Architecture Patterns

### 1. State Management
**How it works — State manager:** state is classified first — ephemeral (in memory), session (Redis), durable (database) — and each lives in the cheapest layer that meets its durability and latency needs; components stay restartable at any moment.

### 2. Presence System
**How it works — Presence system:** each client sends heartbeats; a user is "online" if any device beat within the window, and disconnects expire via TTL rather than explicit goodbyes — state is small and lives in Redis with pub/sub fanout to watchers.

## Implementation Strategies

### 1. Document Collaboration
**How it works — Document collaboration:** each client applies edits locally (instant UX), broadcasts operations, and transforms concurrent ops against received ones (OT) — or converges via CRDT merge — while the server orders everything durably for late joiners.

### 2. Conflict Resolution
**How it works — Conflict resolver:** when concurrent writes diverge, the system either merges deterministically (last-writer-wins with a logical clock, CRDT merge) or surfaces the conflict to the user — silently dropping one side is the one forbidden answer.

## Common Use Cases

### 1. Collaborative Text Editor
**How it works — Text editor:** edits are operations applied to a sequence; concurrent ops are transformed (OT) or merged by CRDT rules so every replica converges to the same text — cursors and presence ride the same channel.

### 2. Shared Whiteboard
**How it works — Whiteboard:** start from requirements (numbers!), sketch the request path left-to-right, then deepen the hot component — data model, consistency choice, failure mode — narrating each decision's trade-off as you draw it.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Operational Transform (OT) | Mature (Google Docs lineage), ordered ops | Central transform server, algorithmic subtlety | Centralized text editing |
| CRDTs | Decentralized merge, offline-first | Metadata growth, harder semantics | Offline-capable, P2P-ish apps |
| Server-authoritative | Simple correctness, easy permissions | Latency for distant users, server cost | Games, collaborative canvases |
| Client-optimistic + sync | Instant local response | Conflict UX, rollback handling | Editors, whiteboards |

**Consistency vs latency:** Accepting local edits instantly feels great and creates conflicts; serializing through a server simplifies correctness and adds round trips.

**Central vs decentralized:** Centralized sync eases permissions and history; CRDTs remove the server from the correctness path at the cost of metadata and merging complexity.

**Richness of types:** Text CRDTs are mature; arbitrary rich objects (canvases, tables) push algorithm frontiers — budget research time.

> **⚠️ When NOT to use CRDTs:** when a single authoritative server is acceptable (server-serialized ops or OT are simpler), documents are small-team and short-lived, and metadata growth bloats storage for rarely-offline users.

## Edge Cases to Consider

- Concurrent edits to the same word — merge semantics must be chosen (both survive, deterministic)
- Undo across merged concurrent edits — undo stacks get subtle
- Client clock skew — use logical versions, not timestamps
- Reconnection gaps — clients replay missed ops from the log


## Common Pitfalls

1. Timestamp-based conflict resolution — logical clocks only
2. Unbounded operation history — snapshot + compact periodically
3. Server as bottleneck for presence — fan out via pub-sub with TTL
4. Ignoring offline UX until merge bugs surface


## FAQ

**Q1: OT or CRDT?**

A: OT needs a central server to order and transform — efficient, proven at Google scale. CRDTs merge without coordination — better offline/decentralized, heavier metadata. Centralized products default to OT-style; local-first prefers CRDTs.

**Q2: How do presence indicators scale?**

A: Presence is ephemeral: heartbeats with TTL expiry, fanned out through pub-sub per room — never persisted, cheap to lose.

**Q3: What breaks offline sync most often?**

A: Assuming timestamps order events. Use logical versions/CRDT merge so results are deterministic regardless of arrival order.

## Interview Tips

### 1. Key Considerations
- Consistency model
- Latency handling
- Conflict resolution
- State management
- Scalability

### 2. Common Questions
1. How to handle network delays?
2. How to ensure consistency?
3. How to scale real-time updates?
4. How to handle offline mode?

### 3. Best Practices
- Use CRDTs when possible
- Implement offline support
- Handle edge cases
- Monitor performance
- Test concurrency

## Advanced Topics

1. Rich-text CRDTs (RGA/Yjs) and their performance profiles
2. Server-side compaction and snapshot versioning
3. WebSocket fan-out scaling via room-to-server routing
4. Conflict UX: showing users what merged and why


## Further Reading
- [Operational Transform](https://operational-transformation.github.io/)
- [CRDT Explained](https://crdt.tech/)
- [Real-time Collaboration](https://www.figma.com/blog/how-figmas-multiplayer-technology-works/)

