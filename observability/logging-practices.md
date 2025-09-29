# Logging Best Practices

## Table of Contents
- [Introduction](#introduction)
- [Logging Patterns](#logging-patterns)
- [Implementation Strategies](#implementation-strategies)
- [Log Management](#log-management)
- [Common Use Cases](#common-use-cases)
- [Interview Tips](#interview-tips)

## Introduction

Effective logging is crucial for understanding system behavior, debugging issues, and maintaining application health.

### Key Benefits
1. **Debugging Support**
2. **System Visibility**
3. **Audit Trail**
4. **Performance Analysis**
5. **Security Monitoring**

## Logging Patterns

### 1. Structured Logging
```python
class StructuredLogger:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        
    def log_event(self, event_type, **kwargs):
        """Log structured event"""
        log_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'event_type': event_type,
            'service': self.service_name,
            'trace_id': get_trace_id(),
            'data': kwargs
        }
        self.logger.info(json.dumps(log_entry))
```

### 2. Correlation Pattern
```python
class RequestTracker:
    def __init__(self):
        self.context = contextvars.ContextVar('request_context')
        
    def track_request(self):
        """Track request through system"""
        context = {
            'request_id': str(uuid.uuid4()),
            'start_time': time.time(),
            'user_id': get_current_user_id()
        }
        self.context.set(context)
        
    def log_with_context(self, message, **kwargs):
        """Log with request context"""
        context = self.context.get()
        log_entry = {**context, **kwargs, 'message': message}
        logger.info(json.dumps(log_entry))
```

## Implementation Strategies

### 1. Log Levels
```python
class ApplicationLogger:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.configure_logging()
        
    def configure_logging(self):
        """Configure log levels and handlers"""
        # Production configuration
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s [%(levelname)s] %(message)s',
            handlers=[
                logging.StreamHandler(),
                logging.FileHandler('app.log')
            ]
        )
        
    def log_operation(self, operation, data):
        """Log operation with appropriate level"""
        try:
            # Operation details
            self.logger.info(f"Starting {operation}", extra={'data': data})
            
            result = perform_operation(data)
            
            # Success
            self.logger.info(
                f"Completed {operation}",
                extra={'result': result}
            )
            return result
            
        except Exception as e:
            # Error with stack trace
            self.logger.error(
                f"Failed {operation}",
                exc_info=True,
                extra={'error': str(e)}
            )
            raise
```

### 2. Distributed Logging
```python
class DistributedLogger:
    def __init__(self):
        self.elk_client = ElasticsearchClient()
        
    async def log_distributed_event(self, event):
        """Log event in distributed system"""
        log_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'service': self.service_name,
            'trace_id': event.trace_id,
            'span_id': event.span_id,
            'parent_id': event.parent_id,
            'event_type': event.type,
            'data': event.data
        }
        
        # Send to Elasticsearch
        await self.elk_client.index(
            index='service-logs',
            document=log_entry
        )
```

## Log Management

### 1. Log Aggregation
```python
class LogAggregator:
    def __init__(self):
        self.kafka_producer = KafkaProducer()
        
    async def send_logs(self, logs):
        """Send logs to centralized system"""
        try:
            # Batch logs
            batch = self.prepare_batch(logs)
            
            # Send to Kafka
            await self.kafka_producer.send(
                topic='logs',
                value=batch
            )
        except Exception as e:
            # Fallback logging
            logger.error(f"Failed to send logs: {e}")
```

### 2. Log Rotation
```python
def configure_log_rotation():
    """Configure log rotation"""
    return {
        'filename': 'app.log',
        'maxBytes': 10485760,  # 10MB
        'backupCount': 5,
        'encoding': 'utf8',
        'formatter': logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    }
```

## Common Use Cases

### 1. Application Monitoring
```python
class ApplicationMonitor:
    def log_request(self, request, response, duration):
        """Log HTTP request details"""
        log_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'method': request.method,
            'path': request.path,
            'status_code': response.status_code,
            'duration_ms': duration,
            'user_agent': request.headers.get('User-Agent'),
            'ip_address': request.remote_addr
        }
        logger.info('Request processed', extra=log_entry)
```

### 2. Error Tracking
```python
class ErrorTracker:
    def log_error(self, error, context=None):
        """Log error with context"""
        error_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'error_type': type(error).__name__,
            'error_message': str(error),
            'stack_trace': traceback.format_exc(),
            'context': context or {}
        }
        
        # Log locally
        logger.error('Error occurred', extra=error_entry)
        
        # Send to error tracking service
        self.error_service.capture_exception(
            error,
            extra=error_entry
        )
```

## Interview Tips

### 1. Key Considerations
- Log levels and verbosity
- Performance impact
- Storage requirements
- Security and privacy
- Retention policies

### 2. Common Questions
1. How do you handle logging in distributed systems?
2. What information should be logged?
3. How do you manage log storage and retention?
4. How do you handle sensitive data in logs?

### 3. Best Practices
- Use structured logging
- Include context
- Handle sensitive data
- Implement rotation
- Monitor log volume

## Further Reading
- [Logging Best Practices](https://www.scalyr.com/blog/logging-best-practices/)
- [ELK Stack Guide](https://www.elastic.co/guide/index.html)
- [Cloud Logging Patterns](https://cloud.google.com/architecture/logging-pattern)

