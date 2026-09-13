# Distributed Tracing

## Table of Contents
- [Introduction](#introduction)
- [Core Concepts](#core-concepts)
- [Implementation Strategies](#implementation-strategies)
- [Analysis Patterns](#analysis-patterns)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Interview Tips](#interview-tips)

## Introduction

Distributed tracing provides visibility into request flows across distributed systems.

### Key Benefits
1. **Request Flow Visibility**
2. **Performance Analysis**
3. **Bottleneck Detection**
4. **Error Tracking**
5. **Service Dependencies**

## Core Concepts

### 1. Trace Context
```python
class TraceContext:
    def __init__(self):
        self.trace_id = str(uuid.uuid4())
        self.span_id = str(uuid.uuid4())
        self.parent_id = None
        
    def create_child_span(self):
        """Create child span context"""
        child = TraceContext()
        child.trace_id = self.trace_id
        child.parent_id = self.span_id
        return child
```

### 2. Span Management
```python
class SpanManager:
    def __init__(self):
        self.tracer = opentelemetry.trace.get_tracer(__name__)
        
    def create_span(self, name, context=None):
        """Create new span"""
        with self.tracer.start_as_current_span(
            name,
            context=context,
            kind=trace.SpanKind.SERVER
        ) as span:
            span.set_attribute("service.name", "order-service")
            return span
            
    def end_span(self, span, status=None):
        """End span with status"""
        if status:
            span.set_status(status)
        span.end()
```

## Implementation Strategies

### 1. Middleware Integration
```python
class TracingMiddleware:
    def __init__(self, app):
        self.app = app
        self.tracer = init_tracer()
        
    async def __call__(self, scope, receive, send):
        """ASGI middleware for tracing"""
        if scope["type"] != "http":
            return await self.app(scope, receive, send)
            
        with self.tracer.start_span(
            scope["path"],
            kind=trace.SpanKind.SERVER
        ) as span:
            # Add request details
            span.set_attribute("http.method", scope["method"])
            span.set_attribute("http.route", scope["path"])
            
            # Handle request
            try:
                response = await self.app(scope, receive, send)
                span.set_attribute("http.status_code", response.status_code)
                return response
            except Exception as e:
                span.set_status(Status(StatusCode.ERROR, str(e)))
                raise
```

### 2. Service Instrumentation
```python
class TracedService:
    def __init__(self):
        self.tracer = init_tracer()
        
    async def process_order(self, order):
        """Process order with tracing"""
        with self.tracer.start_span("process_order") as span:
            try:
                # Validate order
                with self.tracer.start_span(
                    "validate_order",
                    parent=span
                ) as validate_span:
                    self.validate_order(order)
                
                # Process payment
                with self.tracer.start_span(
                    "process_payment",
                    parent=span
                ) as payment_span:
                    payment = await self.payment_service.charge(order)
                    
                # Update inventory
                with self.tracer.start_span(
                    "update_inventory",
                    parent=span
                ) as inventory_span:
                    await self.inventory_service.update(order)
                    
                return "Order processed"
            except Exception as e:
                span.set_status(Status(StatusCode.ERROR, str(e)))
                raise
```

## Analysis Patterns

### 1. Trace Analysis
```python
class TraceAnalyzer:
    def analyze_trace(self, trace_id):
        """Analyze complete trace"""
        # Get all spans for trace
        spans = self.trace_store.get_spans(trace_id)
        
        # Build trace tree
        trace_tree = self.build_trace_tree(spans)
        
        # Calculate metrics
        metrics = self.calculate_trace_metrics(trace_tree)
        
        return {
            'trace_id': trace_id,
            'duration': metrics['duration'],
            'span_count': len(spans),
            'error_count': metrics['error_count'],
            'services': metrics['services']
        }
        
    def build_trace_tree(self, spans):
        """Build hierarchical trace structure"""
        span_map = {span.span_id: span for span in spans}
        root = None
        
        for span in spans:
            if not span.parent_id:
                root = span
                continue
                
            parent = span_map.get(span.parent_id)
            if parent:
                parent.children.append(span)
                
        return root
```

### 2. Performance Analysis
```python
class PerformanceAnalyzer:
    def analyze_service_performance(self, traces, service_name):
        """Analyze service performance"""
        service_spans = []
        
        for trace in traces:
            service_spans.extend([
                span for span in trace.spans
                if span.service_name == service_name
            ])
            
        return {
            'avg_duration': statistics.mean(
                span.duration for span in service_spans
            ),
            'p95_duration': numpy.percentile(
                [span.duration for span in service_spans],
                95
            ),
            'error_rate': len([
                span for span in service_spans
                if span.status.code == StatusCode.ERROR
            ]) / len(service_spans)
        }
```

## Common Use Cases

### 1. Request Tracing
```python
class RequestTracer:
    async def trace_request(self, request):
        """Trace HTTP request"""
        with self.tracer.start_span("http_request") as span:
            # Add request context
            span.set_attribute("http.method", request.method)
            span.set_attribute("http.url", str(request.url))
            
            try:
                response = await self.handle_request(request)
                span.set_attribute(
                    "http.status_code",
                    response.status_code
                )
                return response
            except Exception as e:
                span.set_status(Status(StatusCode.ERROR, str(e)))
                raise
```

### 2. Database Tracing
```python
class DatabaseTracer:
    async def trace_query(self, query, params=None):
        """Trace database query"""
        with self.tracer.start_span("db_query") as span:
            span.set_attribute("db.type", "postgresql")
            span.set_attribute("db.statement", query)
            
            try:
                result = await self.execute_query(query, params)
                span.set_attribute("db.rows_affected", len(result))
                return result
            except Exception as e:
                span.set_status(Status(StatusCode.ERROR, str(e)))
                raise
```

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| 100% tracing | Complete visibility | Cost and cardinality explosion | Tiny traffic or debugging bursts |
| Head-based sampling | Constant overhead, cheap | May drop the interesting traces | High-volume healthy paths |
| Tail-based sampling | Keeps slow/error traces | Buffering cost, complexity | User-facing request paths |
| Always trace errors | Never miss failures | Requires dynamic sampling logic | All production systems |

**Coverage vs cost:** Trace data is among the most expensive telemetry; sampling policy decides your bill more than your vendor does.

**Latency attribution vs overhead:** Span-per-hop precision finds bottlenecks but each span costs CPU and network — instrument boundaries first.

**Context propagation coupling:** Full tracing requires consistent context headers across every service; retrofitting partial coverage yields confusing partial traces.

> **⚠️ When NOT to trace every request:** high-volume healthy paths where head-based sampling captures the shape at 1% of the cost, and systems that can't propagate context consistently — partial tracing yields misleading partial pictures.

## Interview Tips

### 1. Key Considerations
- Sampling strategy
- Data retention
- Performance impact
- Privacy concerns
- Integration points

### 2. Common Questions
1. How do you implement distributed tracing?
2. What sampling strategies do you use?
3. How do you analyze trace data?
4. How do you handle trace context propagation?

### 3. Best Practices
- Use consistent naming
- Add relevant attributes
- Implement proper sampling
- Consider data volume
- Monitor trace system

## Further Reading
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Jaeger Tracing](https://www.jaegertracing.io/docs/)
- [Distributed Tracing in Practice](https://www.oreilly.com/library/view/distributed-tracing-in/9781492056621/)

