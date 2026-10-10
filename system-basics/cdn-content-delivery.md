# CDN & Content Delivery in System Design 📌

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites & Related Topics](#prerequisites--related-topics)
- [Pattern Recognition Guide](#pattern-recognition-guide)
- [How a CDN Works](#how-a-cdn-works)
- [Caching & Invalidation](#caching--invalidation)
- [Dynamic Content & Beyond Static](#dynamic-content--beyond-static)
- [Pushing Origin Load Down](#pushing-origin-load-down)
- [Trade-offs](#trade-offs)
- [Edge Cases to Consider](#edge-cases-to-consider)
- [Common Pitfalls](#common-pitfalls)
- [FAQ](#faq)
- [Interview Tips](#interview-tips)
- [Real-World Examples](#real-world-examples)
- [Advanced Topics](#advanced-topics)
- [Further Reading](#further-reading)

## Introduction

A Content Delivery Network is a globally distributed tier of edge servers that caches content close to users. It cuts latency (shorter physical distance), absorbs origin load (a hit at the edge costs the origin nothing), and shields the origin from spikes and DDoS. For most internet-facing designs, "add a CDN" is the single highest-leverage first move — and the interviewer wants to see you know *where* it fits and *what* it can and cannot cache.

```mermaid
graph LR
    U[Users worldwide] --> E[Nearest Edge PoP]
    E -- hit --> U
    E -- miss --> M[Regional mid-tier cache]
    M -- miss --> O[Origin]
```

## Prerequisites & Related Topics

- **Builds on**: HTTP caching semantics, [Load Balancing](load-balancing.md), [Proxies](proxies.md)
- **Used in**: every internet-facing design in this handbook; pairs with [Caching](caching.md) (edge is the L3 of a tiered cache)
- **Techniques often combined**: `Cache-Control`, `stale-while-revalidate`, signed URLs, origin shields, anycast DNS routing
- **See also**: [Security Best Practices](../security/README.md) — edge WAF/DDoS scrubbing happens here

## Pattern Recognition Guide

### 🎯 When to Use a CDN

**Keywords in requirements**: "global users", "images/videos", "static assets", "reduce latency", "offload origin", "cache at the edge", "handle traffic spikes", "viral content"
**Reach for this when**:
- Users are geographically spread while the origin sits in one region
- A large share of responses are static or slow-changing (images, JS/CSS, video segments, product pages)
- Traffic is spiky or viral — the edge absorbs the storm
- You need DDoS/WAF scrubbing in front of the origin anyway

### 🔑 Approach Indicators

| Approach | Signals | Best For |
|----------|---------|----------|
| Pull-through CDN | content fetched on first miss | default choice |
| Push/preload CDN | predictable hot content, events | launches, live sports |
| Signed/private CDN URLs | per-user content behind auth | paid media, secure downloads |
| Dynamic-content acceleration | API responses, connection reuse | APIs too expensive to origin |

### ❌ When NOT to Use

- Single-region, intranet-only users — the edge adds cost, not benefit
- Highly personalized, un-cacheable responses with no prior proxy layer
- Content that must never live outside your trust boundary without signing/encryption

## How a CDN Works

**How it works — the delivery path:** the user's request resolves (via the CDN's DNS, typically anycast) to the nearest edge PoP. If the PoP has the object cached and fresh per its TTL, it serves immediately — that's the hit case, and it's 90%+ of traffic for well-tuned static sites. On a miss, the PoP fetches from a *mid-tier* regional cache; if that misses, the *origin shield* — one designated cache layer per region — fetches from your origin. The shield collapses a fan-out of thousands of simultaneous PoP misses into at most one origin request per object (request coalescing).

**Back-of-envelope:** static assets are commonly 90%+ of the bytes on a landing page; caching them at the edge removes that entire fraction from origin bandwidth and compute.

## Caching & Invalidation

### Cache Semantics at the Edge
- **TTL via `Cache-Control`** — `max-age`, `s-maxage` for shared caches, `stale-while-revalidate` to serve slightly-stale while refreshing in the background.
- **`Vary`** — the edge keys cache entries on these request headers; crucial for `Authorization`-scoped or compressed variants.
- **Versioned URLs** — `/app.9f3c.js` is the *default* invalidation strategy: ship new filenames, old cache entries age out naturally. Purging is the exception, not the rule.

### Invalidation Options
- **Purge** individual URLs or prefixes (often a paid API feature, and globally slower than versioning)
- **Short TTLs + soft invalidation** for semi-dynamic content (prices, thumbnails)
- **Event-driven**: content publish triggers a targeted purge

## Dynamic Content & Beyond Static

- **Dynamic acceleration**: the edge keeps warm connections and routes over optimized back-haul even for uncacheable API responses — fewer tail-latency spikes.
- **Edge compute** (Cloudflare Workers, Lambda@Edge): lightweight transforms, auth checks, and personalization at the PoP — a reverse proxy that can run code.
- **Video delivery**: HLS/DASH segments are naturally CDN-friendly (each segment is a small static file); live streams add edge ingesting and segment fan-out.

## Pushing Origin Load Down

1. Cache aggressively what's public; sign what's private
2. Use origin shields and request coalescing to flatten miss storms
3. Set long TTLs on immutable, versioned assets
4. Move auth checks to the edge (signed cookies/tokens) so private content is cacheable per-user *at the edge*
5. Compress at the edge (brotli/gzip) to save user bandwidth and origin egress

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| Pull caching | zero upload step, fresh on demand | cold PoPs pay first-request latency | most sites |
| Push/preload | hot from second one | pipeline to keep synced | launches, events |
| Versioned-URL invalidation | instant and global with a deploy | architecture must support it | static assets |
| Active purge | instant on arbitrary URLs | costly, race-prone under concurrency | news, price drops |
| Dynamic acceleration | tail-latency wins for APIs | pricier, no hit-rate leverage | API-heavy global products |

**Latency vs freshness:** longer TTLs mean faster edge hits but slower content updates — versioning breaks this tension for static assets, purge handles the rest.

**Edge compute vs origin compute:** moving logic to the edge shaves round trips, but every PoP now runs your code — you inherit a distributed fleet's debugging burden.

**Global reach vs trust boundary:** content living on shared edge infrastructure requires signed URLs or encryption if it's sensitive.

> **⚠️ When NOT to rely on a CDN for correctness:** treat it as a cache, never as a source of truth — a purge that fails leaves stale bytes; critical data needs origin-side cache-busting keys or versioning.

## Edge Cases to Consider

- Hot object expires under load — request coalescing at edge+shield prevents origin stampede
- Geo-blocking / compliance — certain content must not be cached in some regions
- Cookie bloat busting `Vary` — collapse cache keys by whitelisting cookie headers
- Segment-level cache misses during live events — preload next segments
- Query strings creating cache-key explosions — normalize the cache key
- Mobile clients behind CGNAT — don't key the cache on client IP

## Common Pitfalls

1. Caching personalized responses globally (data leak across users)
2. Tiny TTLs everywhere — hit rate suffers, origin load returns
3. Ignoring cache-key normalization — query variations silently kill the hit rate
4. No origin shield — every PoP miss hits the origin
5. Assuming the CDN also backs up your origin — it's a cache, not a replica

## FAQ

**Q1: CDN vs reverse proxy?**

A: A CDN is a *distributed* reverse proxy: same jobs (TLS, caching, shielding) but replicated across hundreds of PoPs near users, plus DDoS scrubbing and edge compute.

**Q2: How does the CDN handle private (logged-in) content?**

A: Signed URLs/cookies validate the user at the edge; the object itself stays cacheable because access control moved to the edge, and `Vary` scopes per-user variants when needed.

**Q3: Purge or version URLs?**

A: Version for static assets (instant, global, free with deploy); purge sparingly for semi-dynamic content where you can't rename — purge calls cost money and race with in-flight fetches.

## Interview Tips

### 1. Key Considerations

- What fraction of traffic is cacheable, and what the hit rate needs to be
- Cache key design (query normalization, cookie whitelisting)
- Where private content gets access-controlled (edge vs origin)
- Shield/topology — where misses collapse before touching origin

### 2. Common Questions

1. Design a video streaming platform's content delivery layer.
2. How would you handle a viral spike on a product launch?
3. Where does image resizing happen in a global photo-sharing app?
4. How do you serve per-user content fast without breaking cacheability?

### 3. Back-of-Envelope Line

"Landing page reads ~2 MB per visit, 90% static: caching at the edge cuts origin egress ~10× and p95 latency from ~400 ms to <50 ms for repeat views."

## Real-World Examples

- **Video platforms (Netflix/YouTube):** segment-based delivery over CDNs, per-ISP appliance caching, and regional mid-tiers.
- **News/e-commerce spikes:** flash sale pages cached at the edge with short TTLs; purge on price/stock changes.
- **Software distribution:** OS/app updates pushed to CDN, origin sees a trickle.

## Advanced Topics

1. Origin shields, tiered caching, and request coalescing in depth
2. Edge include/fragments (ESI-style) for cacheable page shells + dynamic slots
3. Anycast vs DNS-based PoP selection trade-offs
4. Media streaming: ABC playback at the edge, adaptive bitrate at the client, and per-session segment prefetching

## Further Reading

- [Cloudflare: What is a CDN?](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/)
- [MDN: HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)
- [Fastly: Cache invalidation concepts](https://www.fastly.com/documentation/guides/concepts/edge-cache/)
- [AWS CloudFront Best Practices](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/best-practices.html)
