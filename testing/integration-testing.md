# Integration Testing in Microservices

## Table of Contents
- [Introduction](#introduction)
- [Testing Strategies](#testing-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Test Infrastructure](#test-infrastructure)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Interview Tips](#interview-tips)

## Introduction

Integration testing in microservices verifies the interaction between different services and components.

### Key Benefits
1. **Service Compatibility**
2. **Contract Validation**
3. **End-to-End Flows**
4. **Dependency Verification**
5. **System Reliability**

## Testing Strategies

### 1. Consumer-Driven Contracts
```python
class ConsumerContractTest:
    def define_contract(self):
        """Define service contract"""
        return {
            'service': 'order-service',
            'endpoint': '/api/orders',
            'method': 'POST',
            'request': {
                'required_fields': [
                    'user_id',
                    'product_id',
                    'quantity'
                ],
                'optional_fields': [
                    'notes',
                    'shipping_preference'
                ]
            },
            'response': {
                'success': {
                    'status': 201,
                    'fields': ['order_id', 'status']
                },
                'error': {
                    'status': 400,
                    'fields': ['error_code', 'message']
                }
            }
        }
```

### 2. Service Virtualization
```python
class ServiceMock:
    def create_mock_service(self):
        """Create mock service"""
        return {
            'endpoints': [
                {
                    'path': '/api/products',
                    'method': 'GET',
                    'response': {
                        'status': 200,
                        'body': self.generate_product_data()
                    }
                },
                {
                    'path': '/api/inventory',
                    'method': 'POST',
                    'response': {
                        'status': 200,
                        'body': {'status': 'updated'}
                    }
                }
            ]
        }
```

## Implementation Patterns

### 1. Test Environment
```python
class TestEnvironment:
    async def setup_environment(self):
        """Setup test environment"""
        try:
            # Start required services
            services = await self.start_services([
                'order-service',
                'payment-service',
                'inventory-service'
            ])
            
            # Setup test data
            await self.setup_test_data()
            
            # Configure service communication
            await self.configure_service_routes()
            
            return services
        except Exception as e:
            await self.cleanup()
            raise EnvironmentSetupError(str(e))
```

### 2. Test Data Management
```python
class TestDataManager:
    async def manage_test_data(self):
        """Manage test data"""
        try:
            # Clean existing data
            await self.clean_test_data()
            
            # Generate new data
            test_data = self.generate_test_data()
            
            # Load data into services
            for service, data in test_data.items():
                await self.load_service_data(service, data)
                
            return test_data
        finally:
            # Register cleanup
            self.register_cleanup(self.clean_test_data)
```

## Test Infrastructure

### 1. Service Dependencies
```python
class DependencyManager:
    def manage_dependencies(self):
        """Manage service dependencies"""
        return {
            'services': {
                'order-service': {
                    'depends_on': [
                        'payment-service',
                        'inventory-service'
                    ],
                    'healthcheck': {
                        'endpoint': '/health',
                        'interval': '5s',
                        'retries': 3
                    }
                }
            },
            'databases': {
                'order-db': {
                    'type': 'postgresql',
                    'version': '13',
                    'schema': 'order_schema.sql'
                }
            },
            'queues': {
                'order-events': {
                    'type': 'rabbitmq',
                    'exchanges': ['orders', 'notifications']
                }
            }
        }
```

### 2. Test Orchestration
```python
class TestOrchestrator:
    async def run_integration_tests(self):
        """Run integration test suite"""
        try:
            # Setup environment
            env = await self.setup_environment()
            
            # Run tests
            results = []
            for test_case in self.test_cases:
                result = await self.run_test_case(
                    test_case,
                    env
                )
                results.append(result)
                
            # Analyze results
            return self.analyze_results(results)
        finally:
            # Cleanup
            await self.cleanup_environment()
```

## Common Use Cases

### 1. Order Processing Flow
```python
class OrderFlowTest:
    async def test_order_flow(self):
        """Test complete order flow"""
        # Create order
        order = await self.create_order({
            'user_id': 'test_user',
            'product_id': 'test_product',
            'quantity': 1
        })
        
        # Verify payment
        payment = await self.verify_payment(order['id'])
        assert payment['status'] == 'completed'
        
        # Check inventory
        inventory = await self.check_inventory(
            order['product_id']
        )
        assert inventory['quantity'] == 0
        
        # Verify notification
        notification = await self.get_notification(
            order['id']
        )
        assert notification['type'] == 'order_confirmed'
```

### 2. Service Communication
```python
class ServiceCommunicationTest:
    async def test_service_communication(self):
        """Test service communication patterns"""
        # Test synchronous communication
        response = await self.test_http_communication()
        assert response.status_code == 200
        
        # Test asynchronous communication
        message = await self.test_message_queue()
        assert message['status'] == 'processed'
        
        # Test event broadcasting
        events = await self.test_event_broadcast()
        assert len(events) == 3  # All services received
```

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Real dependencies | Highest fidelity | Slow, flaky, environment cost | Critical paths, release gates |
| Test doubles (stubs/mocks) | Fast, deterministic | Drift from real behavior | Unit-adjacent and edge-case tests |
| Shared long-lived environment | Cheap per-run | Cross-test interference, 'who broke it' | Small teams |
| Ephemeral per-run environments | Isolation, reproducibility | Provisioning cost/time | CI at scale |

**Fidelity vs speed:** Every real dependency raises confidence and runtime; the pyramid exists because that cost compounds.

**Isolation vs resource cost:** Fresh environments per pipeline kill flakiness at provisioning price; optimize with containers and reuse where safe.

**Mock maintenance:** Doubles are code that rots — generate from contracts/schemas rather than hand-writing.

> **⚠️ When NOT to mock:** auth, payment, and persistence flows where mock drift hides real breakage — run those against real dependencies in a scheduled, gated suite.

## Interview Tips

### 1. Key Considerations
- Test isolation
- Data management
- Service dependencies
- Error handling
- Performance impact

### 2. Common Questions
1. How to design integration tests?
2. How to handle test data?
3. How to manage service dependencies?
4. How to ensure test reliability?

### 3. Best Practices
- Use contract testing
- Maintain test data
- Automate environment setup
- Monitor test execution
- Document test cases

## Further Reading
- [Integration Testing Guide](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Contract Testing](https://pact.io/documentation/implementation_guides.html)
- [Testing Microservices](https://microservices.io/testing)

