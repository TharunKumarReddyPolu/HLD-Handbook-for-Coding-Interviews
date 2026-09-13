# Cloud Native Architecture

This section covers building and running systems on modern cloud platforms — the deployment substrate behind most real-world designs and a common interview follow-up ("how would you run this?").

## Topics in This Section

- [Container Orchestration with Kubernetes](kubernetes-orchestration.md) - Pods, deployments, services, and autoscaling
- [Cloud Design Patterns](design-patterns.md) - Proven patterns from the major cloud providers' frameworks
- [Serverless Design Patterns](serverless-patterns.md) - Functions, event sources, cold starts, and limits
- [Cloud Security Patterns](cloud-security.md) - IAM, network segmentation, and workload security
- [Cloud Cost Optimization](cost-optimization.md) - Right-sizing, autoscaling economics, and FinOps
- [Multi-Cloud Strategies](multi-cloud.md) - Portability, abstraction costs, and vendor trade-offs

## Suggested Learning Path

```
Cloud Design Patterns
        │
        ├──► Kubernetes Orchestration ──► Serverless Design Patterns
        │
        ├──► Cloud Security Patterns ──► Multi-Cloud Strategies
        │
        └──► Cloud Cost Optimization
```

## Where to Go Next

- [Scalability Patterns](../scalability/README.md) - The scale concepts cloud platforms operationalize
- [Observability](../observability/README.md) - Running cloud workloads you can actually debug
- [Best Practices](../best-practices/README.md) - Cross-cutting cost, performance, and security guidance
