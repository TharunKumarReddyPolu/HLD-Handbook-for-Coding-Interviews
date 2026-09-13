# Metrics Collection and Analysis

## Table of Contents
- [Introduction](#introduction)
- [Types of Metrics](#types-of-metrics)
- [Collection Strategies](#collection-strategies)
- [Analysis Patterns](#analysis-patterns)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Interview Tips](#interview-tips)

## Introduction

Metrics provide quantitative measurements of system behavior and performance over time.

### Key Benefits
1. **Performance Monitoring**
2. **Capacity Planning**
3. **Anomaly Detection**
4. **SLA Tracking**
5. **Business Insights**

## Types of Metrics

### 1. System Metrics
```python
class SystemMetricsCollector:
    def collect_metrics(self):
        """Collect system metrics"""
        metrics = {
            'cpu_usage': psutil.cpu_percent(),
            'memory_usage': psutil.virtual_memory().percent,
            'disk_usage': psutil.disk_usage('/').percent,
            'network_io': psutil.net_io_counters()
        }
        return self.format_metrics(metrics)
```

### 2. Application Metrics
```python
class ApplicationMetrics:
    def __init__(self):
        self.prometheus_client = PrometheusClient()
        
    def setup_metrics(self):
        """Setup application metrics"""
        self.request_counter = Counter(
            'http_requests_total',
            'Total HTTP requests',
            ['method', 'endpoint', 'status']
        )
        
        self.response_time = Histogram(
            'http_response_time_seconds',
            'HTTP response time',
            ['method', 'endpoint']
        )
        
        self.active_users = Gauge(
            'active_users',
            'Number of active users'
        )
```

## Collection Strategies

### 1. Push vs Pull
```python
class MetricsExporter:
    def export_metrics(self, metrics):
        """Push metrics to collector"""
        if self.mode == 'push':
            # Push to remote collector
            self.push_client.send(metrics)
        else:
            # Expose metrics endpoint
            self.metrics_registry.update(metrics)
```

### 2. Aggregation
```python
class MetricsAggregator:
    def aggregate_metrics(self, metrics_list):
        """Aggregate metrics from multiple sources"""
        aggregated = defaultdict(list)
        
        for metrics in metrics_list:
            for key, value in metrics.items():
                aggregated[key].append(value)
        
        return {
            key: self.calculate_stats(values)
            for key, values in aggregated.items()
        }
        
    def calculate_stats(self, values):
        """Calculate statistical measures"""
        return {
            'min': min(values),
            'max': max(values),
            'avg': sum(values) / len(values),
            'p95': numpy.percentile(values, 95),
            'p99': numpy.percentile(values, 99)
        }
```

## Analysis Patterns

### 1. Time Series Analysis
```python
class TimeSeriesAnalyzer:
    def analyze_trend(self, metrics, window):
        """Analyze metric trends"""
        df = pd.DataFrame(metrics)
        
        # Calculate moving average
        ma = df.rolling(window=window).mean()
        
        # Detect anomalies
        std = df.rolling(window=window).std()
        upper_bound = ma + 2 * std
        lower_bound = ma - 2 * std
        
        anomalies = df[(df > upper_bound) | (df < lower_bound)]
        
        return {
            'trend': ma.to_dict(),
            'anomalies': anomalies.to_dict()
        }
```

### 2. Alerting
```python
class AlertManager:
    def check_thresholds(self, metrics):
        """Check metrics against thresholds"""
        alerts = []
        
        for metric, value in metrics.items():
            threshold = self.thresholds.get(metric)
            if threshold and value > threshold:
                alerts.append({
                    'metric': metric,
                    'value': value,
                    'threshold': threshold,
                    'timestamp': datetime.utcnow()
                })
        
        if alerts:
            self.send_alerts(alerts)
```

## Common Use Cases

### 1. Performance Monitoring
```python
class PerformanceMonitor:
    def monitor_endpoints(self):
        """Monitor API endpoints"""
        with self.response_time.time():
            response = self.make_request()
            
        self.request_counter.labels(
            method=request.method,
            endpoint=request.path,
            status=response.status_code
        ).inc()
```

### 2. Resource Usage
```python
class ResourceMonitor:
    def monitor_resources(self):
        """Monitor resource usage"""
        metrics = {
            'cpu': self.get_cpu_metrics(),
            'memory': self.get_memory_metrics(),
            'disk': self.get_disk_metrics(),
            'network': self.get_network_metrics()
        }
        
        # Store metrics
        self.store_metrics(metrics)
        
        # Check thresholds
        self.check_thresholds(metrics)
```

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| High-resolution metrics | Sharp dashboards, tight detection | Storage and query cost | Critical service SLOs |
| Coarse aggregation | Cheap at scale | Hides spikes and percentiles | Non-critical background jobs |
| Pre-aggregated metrics | Fast dashboards | Loses per-instance drill-down | Executive/summary views |
| Raw event metrics | Full flexibility (histograms) | Highest cardinality cost | LATENCY analysis, SLO math |

**Cardinality vs insight:** Every label multiplies series count; unbounded labels (user IDs, URLs) can take down a metrics backend.

**Push vs pull:** Pull (scrape) self-regulates and health-checks; push reaches short-lived jobs and firewalled hosts but needs careful backpressure.

**Latency vs durability in collection:** In-memory agent buffers are fast and lossy; durable queues survive restarts at a cost.

## Interview Tips

### 1. Key Considerations
- Metric types selection
- Collection frequency
- Storage requirements
- Analysis methods
- Alert thresholds

### 2. Common Questions
1. How do you choose which metrics to collect?
2. How do you handle metric storage at scale?
3. What alerting strategies do you use?
4. How do you detect anomalies?

### 3. Best Practices
- Define clear objectives
- Use appropriate granularity
- Implement proper aggregation
- Set meaningful alerts
- Monitor the monitoring system

## Further Reading
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [Google SRE Book - Monitoring](https://sre.google/sre-book/monitoring-distributed-systems/)

