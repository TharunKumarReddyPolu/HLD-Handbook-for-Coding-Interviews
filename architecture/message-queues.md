# Message Queues

<div align="center">
  <img src="https://raw.githubusercontent.com/donnemartin/system-design-primer/master/images/5KeocQs.jpg" alt="Message Queues Diagram" width="600"/>
</div>

## Table of Contents
- [Introduction](#introduction)
- [Queue Types](#queue-types)
- [Message Patterns](#message-patterns)
- [Implementation Strategies](#implementation-strategies)
- [Reliability & Durability](#reliability--durability)
- [Best Practices](#best-practices)
- [Interview Tips](#interview-tips)

## Introduction

Message queues enable asynchronous communication between services, improving scalability and reliability. They decouple producers from consumers and handle message delivery.

### Key Benefits
1. **Decoupling**
2. **Scalability**
3. **Reliability**
4. **Asynchronous Processing**

## Queue Types

### 1. Point-to-Point Queue
```mermaid
graph LR
    A[Producer] --> B[Queue]
    B --> C[Consumer 1]
    B --> D[Consumer 2]
    B --> E[Consumer 3]
```

```python
class PointToPointQueue:
    def __init__(self):
        self.queue = Queue()
        self.consumers = []
    
    async def produce(self, message):
        """Produce message to queue."""
        await self.queue.put({
            'id': str(uuid.uuid4()),
            'data': message,
            'timestamp': datetime.utcnow().isoformat()
        })
    
    async def consume(self, consumer_id):
        """Consume message from queue."""
        while True:
            message = await self.queue.get()
            try:
                await self.process_message(consumer_id, message)
                self.queue.task_done()
            except Exception as e:
                # Handle failure
                await self.handle_failure(message, e)
```

### 2. Publish-Subscribe Queue
```mermaid
graph TD
    A[Publisher] --> B[Topic]
    B --> C[Subscriber 1]
    B --> D[Subscriber 2]
    B --> E[Subscriber 3]
```

```python
class PubSubQueue:
    def __init__(self):
        self.topics = {}
        self.subscribers = defaultdict(list)
    
    async def publish(self, topic, message):
        """Publish message to topic."""
        if topic not in self.topics:
            self.topics[topic] = []
        
        message_data = {
            'id': str(uuid.uuid4()),
            'topic': topic,
            'data': message,
            'timestamp': datetime.utcnow().isoformat()
        }
        
        # Notify all subscribers
        for subscriber in self.subscribers[topic]:
            await subscriber.notify(message_data)
    
    def subscribe(self, topic, subscriber):
        """Subscribe to topic."""
        self.subscribers[topic].append(subscriber)
```

### 3. Dead Letter Queue
```python
class DeadLetterQueue:
    def __init__(self):
        self.main_queue = Queue()
        self.dlq = Queue()
        self.max_retries = 3
    
    async def process_message(self, message):
        """Process message with DLQ support."""
        retries = 0
        while retries < self.max_retries:
            try:
                await self.handle_message(message)
                return True
            except Exception as e:
                retries += 1
                await self.handle_retry(message, retries, e)
        
        # Move to DLQ after max retries
        await self.move_to_dlq(message)
        return False
    
    async def move_to_dlq(self, message):
        """Move failed message to DLQ."""
        dlq_message = {
            'original_message': message,
            'error_count': self.max_retries,
            'moved_at': datetime.utcnow().isoformat()
        }
        await self.dlq.put(dlq_message)
```

## Message Patterns

### 1. Request-Reply Pattern
```python
class RequestReplyQueue:
    def __init__(self):
        self.request_queue = Queue()
        self.reply_queues = {}
    
    async def send_request(self, request_data):
        """Send request and wait for reply."""
        correlation_id = str(uuid.uuid4())
        reply_queue = Queue()
        
        # Store reply queue
        self.reply_queues[correlation_id] = reply_queue
        
        # Send request
        await self.request_queue.put({
            'correlation_id': correlation_id,
            'data': request_data
        })
        
        # Wait for reply
        try:
            reply = await asyncio.wait_for(
                reply_queue.get(),
                timeout=30
            )
            return reply
        finally:
            del self.reply_queues[correlation_id]
```

### 2. Competing Consumers Pattern
```python
class CompetingConsumers:
    def __init__(self):
        self.queue = Queue()
        self.consumers = []
        self.lock = asyncio.Lock()
    
    async def start_consumer(self, consumer_id):
        """Start consumer processing."""
        while True:
            message = await self.queue.get()
            async with self.lock:
                if message['processed']:
                    continue
                message['processed'] = True
            
            try:
                await self.process_message(consumer_id, message)
                self.queue.task_done()
            except Exception as e:
                await self.handle_failure(message, e)
```

### 3. Priority Queue Pattern
```python
class PriorityMessageQueue:
    def __init__(self):
        self.queues = {
            'high': Queue(),
            'medium': Queue(),
            'low': Queue()
        }
    
    async def enqueue(self, message, priority='medium'):
        """Enqueue message with priority."""
        await self.queues[priority].put({
            'data': message,
            'priority': priority,
            'timestamp': datetime.utcnow().isoformat()
        })
    
    async def dequeue(self):
        """Dequeue message respecting priority."""
        # Check queues in priority order
        for priority in ['high', 'medium', 'low']:
            if not self.queues[priority].empty():
                return await self.queues[priority].get()
        
        # Wait for any message
        done, pending = await asyncio.wait(
            [q.get() for q in self.queues.values()],
            return_when=asyncio.FIRST_COMPLETED
        )
        
        # Cancel pending gets
        for task in pending:
            task.cancel()
        
        return done.pop().result()
```

## Implementation Strategies

### 1. RabbitMQ Implementation
```python
class RabbitMQHandler:
    def __init__(self):
        self.connection = None
        self.channel = None
    
    async def connect(self):
        """Connect to RabbitMQ."""
        self.connection = await aio_pika.connect_robust(
            "amqp://guest:guest@localhost/"
        )
        self.channel = await self.connection.channel()
    
    async def publish(self, exchange_name, routing_key, message):
        """Publish message to RabbitMQ."""
        exchange = await self.channel.declare_exchange(
            exchange_name,
            aio_pika.ExchangeType.TOPIC
        )
        
        await exchange.publish(
            aio_pika.Message(
                body=json.dumps(message).encode(),
                delivery_mode=aio_pika.DeliveryMode.PERSISTENT
            ),
            routing_key=routing_key
        )
    
    async def consume(self, queue_name, callback):
        """Consume messages from RabbitMQ."""
        queue = await self.channel.declare_queue(
            queue_name,
            durable=True
        )
        
        async with queue.iterator() as queue_iter:
            async for message in queue_iter:
                async with message.process():
                    await callback(message.body.decode())
```

### 2. Kafka Implementation
```python
class KafkaHandler:
    def __init__(self):
        self.producer = None
        self.consumer = None
    
    async def setup_producer(self):
        """Setup Kafka producer."""
        self.producer = AIOKafkaProducer(
            bootstrap_servers='localhost:9092',
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )
        await self.producer.start()
    
    async def setup_consumer(self, group_id):
        """Setup Kafka consumer."""
        self.consumer = AIOKafkaConsumer(
            bootstrap_servers='localhost:9092',
            group_id=group_id,
            value_deserializer=lambda v: json.loads(v.decode('utf-8'))
        )
        await self.consumer.start()
    
    async def produce(self, topic, message):
        """Produce message to Kafka."""
        try:
            await self.producer.send_and_wait(
                topic,
                message
            )
        except Exception as e:
            logger.error(f"Failed to produce message: {e}")
            raise
    
    async def consume(self, topics):
        """Consume messages from Kafka."""
        await self.consumer.subscribe(topics)
        try:
            async for msg in self.consumer:
                await self.process_message(msg)
        finally:
            await self.consumer.stop()
```

## Reliability & Durability

### 1. Message Persistence
```python
class PersistentQueue:
    def __init__(self):
        self.queue = Queue()
        self.storage = Storage()
    
    async def enqueue(self, message):
        """Enqueue message with persistence."""
        # Store message
        message_id = await self.storage.store_message(message)
        
        # Add to queue
        await self.queue.put({
            'id': message_id,
            'data': message
        })
    
    async def dequeue(self):
        """Dequeue message with persistence."""
        message = await self.queue.get()
        try:
            # Process message
            result = await self.process_message(message)
            
            # Remove from storage
            await self.storage.delete_message(message['id'])
            
            return result
        except Exception as e:
            # Return to queue on failure
            await self.queue.put(message)
            raise
```

### 2. Error Handling
```python
class ErrorHandler:
    def __init__(self):
        self.dlq = DeadLetterQueue()
        self.retry_policy = RetryPolicy()
    
    async def handle_error(self, message, error):
        """Handle message processing error."""
        retry_count = message.get('retry_count', 0)
        
        if retry_count < self.retry_policy.max_retries:
            # Retry with backoff
            await self.retry_with_backoff(message, retry_count)
        else:
            # Move to DLQ
            await self.dlq.enqueue(message, error)
    
    async def retry_with_backoff(self, message, retry_count):
        """Retry message with exponential backoff."""
        delay = self.retry_policy.calculate_delay(retry_count)
        await asyncio.sleep(delay)
        
        message['retry_count'] = retry_count + 1
        await self.queue.put(message)
```

## Best Practices

### 1. Message Design
```python
class MessageSchema:
    def validate_message(self, message):
        """Validate message schema."""
        required_fields = {
            'id': str,
            'type': str,
            'data': dict,
            'timestamp': str
        }
        
        for field, field_type in required_fields.items():
            if field not in message:
                raise ValidationError(f"Missing field: {field}")
            if not isinstance(message[field], field_type):
                raise ValidationError(
                    f"Invalid type for {field}: "
                    f"expected {field_type}, "
                    f"got {type(message[field])}"
                )
```

### 2. Performance Optimization
```python
class QueueOptimizer:
    def __init__(self):
        self.batch_size = 100
        self.flush_interval = 5  # seconds
    
    async def batch_produce(self, messages):
        """Produce messages in batches."""
        batches = [
            messages[i:i + self.batch_size]
            for i in range(0, len(messages), self.batch_size)
        ]
        
        for batch in batches:
            try:
                await self.producer.send_batch(batch)
            except Exception as e:
                logger.error(f"Batch production failed: {e}")
                await self.handle_batch_failure(batch)
```

## Interview Tips

### 1. Key Considerations
- Message reliability
- Ordering requirements
- Scalability needs
- Error handling
- Performance requirements

### 2. Common Questions
1. How would you handle message ordering?
2. How do you ensure message delivery?
3. How do you handle failed messages?
4. How do you scale message processing?

### 3. Architecture Diagram
```mermaid
graph TD
    A[Producer] --> B[Message Queue]
    B --> C[Consumer Group 1]
    B --> D[Consumer Group 2]
    B --> E[Dead Letter Queue]
    E --> F[Error Handler]
```

## Further Reading
- [RabbitMQ Documentation](https://www.rabbitmq.com/documentation.html)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/)
- [Message Queue Design Patterns](https://docs.microsoft.com/en-us/azure/architecture/patterns/) 