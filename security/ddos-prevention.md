# DDoS Prevention in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [Prevention Strategies](#prevention-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Mitigation Techniques](#mitigation-techniques)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

DDoS prevention strategies protect systems from distributed denial of service attacks through multiple layers of defense.

### Key Benefits
1. **Service Availability**
2. **Attack Mitigation**
3. **Resource Protection**
4. **Business Continuity**
5. **Customer Trust**

## Prerequisites & Related Topics

- Builds on: [Load Balancing](../system-basics/load-balancing.md), CDN
- Used in: [Rate Limiting](../architecture/rate-limiting.md), [WAF/protection layers](../cloud-native/design-patterns.md), High Availability
- Techniques often combined: anycast scrubbing, WAF rules, bot challenges, origin shielding
- See also: [Cloudflare learning center](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/) — attack taxonomy


## Pattern Recognition Guide

### 🎯 When to Use DDoS Prevention

**Keywords in requirements**: "DDoS", "flood", "volumetric", "amplification", "bot traffic", "syn flood", "origin protection"
**Reach for this when**:
- Any public endpoint — assume attack traffic from day one
- High-visibility launches and events with attack risk
- Protecting expensive origin paths (search, checkout) from junk
- Gaming, media, and APIs routinely targeted by booter services

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Anycast + scrubbing | volumetric L3/L4 floods | absorb before they arrive |
| L4 edge filtering | protocol abuse (SYN, UDP amp) | state-exhaustion defense |
| WAF + rate rules | L7 application floods | API and web targets |
| Bot management | challenge/JS/CAPTCHA tiers | credential stuffing, scraping |

### ❌ When NOT to Use

- DIY volumetric defense — capacity is the whole game; use scrubbing networks
- Challenging known-good API clients — machine auth needs allow-listing, not CAPTCHAs
- Security through origin obscurity alone — origins get discovered


## Prevention Strategies

### 1. Traffic Analysis
**How it works — Traffic analyzer:** sample requests at the edge and build the traffic profile — methods, paths, payload sizes, error rates, source mix — capacity planning and abuse detection both read from that profile.

### 2. Protection Layers
**How it works — Protection layers:** defense in depth — edge (DDoS, WAF), transport (TLS), authn/authz, and data (encryption, masking) — each layer assumes the previous one failed; no single control is load-bearing.

## Implementation Patterns

### 1. Rate Limiting
**How it works — Rate limiter:** identify the caller (IP, user, API key), check their window/counter against the policy, and return 429 with retry-after headers when exceeded — enforce centrally (or with shared state) so the limit is global, not per-instance.

### 2. Traffic Filtering
**How it works — Traffic filter:** the edge classifies each request — bot score, geo, rate, signature — and routes it: humans to origin, suspected bots to a challenge, known-bad to a tarpit — dropping garbage before it costs compute.

## Mitigation Techniques

### 1. Network Level
**How it works — Network mitigation:** volumetric attacks are absorbed upstream (anycast scrubbing, ISP filtering), while application-layer junk is filtered at the edge — the goal is shedding attack traffic before it consumes bandwidth you pay for.

### 2. Application Level
**How it works — Application mitigation:** rate limiting, WAF rules, and request validation at the app edge absorb L7 floods; legit users are fingerprinted and prioritized while garbage is shed before it consumes app resources.

## Common Use Cases

### 1. Web Application
**How it works — Web app protection:** a managed rule set inspects each request for injection, XSS, and known exploit patterns, with custom rules for the app's specific endpoints — block obvious attacks, challenge the ambiguous, log everything for tuning.

### 2. API Protection
**How it works — Apiprotection:** Keep the contract explicit — resource, method, versioning, pagination, error shape — and evolve it without breaking existing clients; additive changes only, deprecations announced with a sunset date.

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| CDN/edge absorption | Massive scale, DDoS offload | Cost, origin exposure if misconfigured | All public services |
| Always-on scrubbing | Immediate mitigation | Continuous cost | High-value targets |
| On-demand scrubbing | Cheap when idle | Activation lag during attack | Lower-risk targets |
| Strict geo/ASN blocking | Cuts attack surface | Blocks legitimate users | Region-specific services |
| Aggressive rate limiting | Cheap and effective | False positives under legitimate spikes | Auth and expensive endpoints |

**Overprovision vs absorb:** Massive headroom rides out attacks but idles cost; edge absorption outscales headroom economically.

**Filtering aggressiveness vs false positives:** Tighter rules stop more attack traffic and more customers; tune with real traffic distributions.

**Secrecy vs resilience:** Hiding origin infrastructure reduces direct-attack surface but is not a control — expect discovery and design for it.

> **⚠️ When NOT to lean on rate limiting alone:** volumetric attacks that exhaust bandwidth before traffic reaches your limiter — edge absorption and upstream scrubbing are the first line; app-layer limits only finish the job.

## Edge Cases to Consider

- Attacks targeting the origin IP directly — firewall to CDN/scrubber ranges only
- Low-and-slow attacks below rate thresholds — heuristic and behavioral detection
- JavaScript-legit clients behind NAT — challenge tuning matters
- DNS-based failover weaponized — TTLs and registrar lock


## Common Pitfalls

1. No origin protection — the CDN is bypassed and the attack lands home
2. Rate limits keyed by IP only — IPv6 makes that free to rotate
3. Over-blocking during attack — availability is the goal, not purity
4. No playbook — attack time is the wrong time to learn the dashboard


## FAQ

**Q1: How do you stop a volumetric DDoS?**

A: You do not stop it — you absorb it: anycast distribution plus scrubbing capacity beyond the attacker's reach, and clean traffic forwarded to origin.

**Q2: L7 flood vs L3 flood?**

A: L3/L4 exhausts bandwidth or connection state — absorbed by anycast/scrubbing. L7 exhausts application logic — filtered by WAF rules, bot scores, and per-client rate limits.

**Q3: What is the single most important DDoS control?**

A: Never expose origin IPs: firewall the origin to your CDN/provider ranges and force all traffic through the protective layer.

## Interview Tips

### 1. Key Considerations
- Attack types
- Protection layers
- Mitigation strategies
- Monitoring approach
- Response plan

### 2. Common Questions
1. How to detect DDoS attacks?
2. How to mitigate different attacks?
3. How to scale protection?
4. How to minimize false positives?

### 3. Best Practices
- Multi-layer defense
- Regular testing
- Monitoring setup
- Incident response
- Capacity planning

## Advanced Topics

1. Always-on vs on-demand scrubbing trade-offs
2. Bot fingerprinting with ML scoring (managed challenges)
3. Geo/ASN-based adaptive policies during events
4. DDoS runbooks with pre-authorized escalation paths


## Further Reading
- [DDoS Protection Guide](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)
- [AWS Shield](https://aws.amazon.com/shield/)
- [NIST DDoS Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-189.pdf)

