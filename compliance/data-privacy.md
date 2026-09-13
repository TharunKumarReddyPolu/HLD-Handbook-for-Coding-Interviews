# Data Privacy Patterns

## Table of Contents
- [Introduction](#introduction)
- [Privacy Patterns](#privacy-patterns)
- [Implementation Strategies](#implementation-strategies)
- [Technical Controls](#technical-controls)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Interview Tips](#interview-tips)

## Introduction

Data privacy patterns provide reusable solutions for implementing privacy requirements in system design.

### Key Benefits
1. **Regulatory Compliance**
2. **User Trust**
3. **Risk Mitigation**
4. **Data Protection**
5. **Privacy by Design**

## Privacy Patterns

### 1. Data Minimization
```python
class DataMinimization:
    def implement_minimization(self):
        """Implement data minimization"""
        return {
            'collection': {
                'required_fields': {
                    'validate': True,
                    'justify': True
                },
                'optional_fields': {
                    'marked': True,
                    'purpose_stated': True
                }
            },
            'retention': {
                'policy': {
                    'time_based': True,
                    'purpose_based': True
                },
                'cleanup': {
                    'automated': True,
                    'logged': True
                }
            }
        }
```

### 2. Pseudonymization
```python
class Pseudonymization:
    def configure_pseudonymization(self):
        """Configure pseudonymization strategy"""
        return {
            'methods': {
                'tokenization': {
                    'type': 'reversible',
                    'algorithm': 'HMAC-SHA256'
                },
                'hashing': {
                    'type': 'one-way',
                    'algorithm': 'Argon2id'
                }
            },
            'scope': {
                'identifiers': [
                    'email',
                    'phone',
                    'address'
                ],
                'attributes': [
                    'preferences',
                    'behavior'
                ]
            }
        }
```

## Implementation Strategies

### 1. Privacy by Design
```python
class PrivacyByDesign:
    async def implement_privacy_controls(self):
        """Implement privacy controls"""
        try:
            # Data collection
            await self.implement_collection_controls()
            
            # Data processing
            await self.implement_processing_controls()
            
            # Data storage
            await self.implement_storage_controls()
            
            # Data sharing
            await self.implement_sharing_controls()
            
            # Data deletion
            await self.implement_deletion_controls()
            
        except Exception as e:
            await self.handle_implementation_error(e)
```

### 2. Access Control
```python
class PrivacyAccessControl:
    def configure_access_control(self):
        """Configure privacy-focused access control"""
        return {
            'authentication': {
                'mfa_required': True,
                'session_management': {
                    'timeout': '15m',
                    'renewal': 'sliding'
                }
            },
            'authorization': {
                'rbac': {
                    'roles': [
                        'data_viewer',
                        'data_processor',
                        'data_admin'
                    ],
                    'permissions': {
                        'view': ['masked_data'],
                        'process': ['anonymized_data'],
                        'manage': ['raw_data']
                    }
                }
            }
        }
```

## Technical Controls

### 1. Data Encryption
```python
class DataEncryption:
    def implement_encryption(self):
        """Implement data encryption"""
        return {
            'at_rest': {
                'algorithm': 'AES-256-GCM',
                'key_management': {
                    'rotation': '30d',
                    'storage': 'vault'
                }
            },
            'in_transit': {
                'protocol': 'TLS 1.3',
                'cipher_suites': [
                    'TLS_AES_256_GCM_SHA384',
                    'TLS_CHACHA20_POLY1305_SHA256'
                ]
            },
            'in_use': {
                'memory_protection': True,
                'secure_enclave': True
            }
        }
```

### 2. Audit Logging
```python
class PrivacyAudit:
    async def log_privacy_event(self, event):
        """Log privacy-related event"""
        try:
            # Create audit record
            audit_record = {
                'timestamp': datetime.utcnow(),
                'event_type': event.type,
                'user_id': self.pseudonymize(event.user_id),
                'action': event.action,
                'data_category': event.category,
                'purpose': event.purpose,
                'legal_basis': event.legal_basis
            }
            
            # Store audit log
            await self.store_audit_log(audit_record)
            
            # Check for violations
            await self.check_privacy_violations(audit_record)
            
        except Exception as e:
            await self.handle_audit_error(e)
```

## Common Use Cases

### 1. Personal Data Handling
```python
class PersonalDataHandler:
    async def process_personal_data(self, data, purpose):
        """Process personal data"""
        try:
            # Validate purpose
            if not await self.validate_purpose(purpose):
                raise InvalidPurpose()
                
            # Check consent
            if not await self.check_consent(data.user_id, purpose):
                raise ConsentNotFound()
                
            # Pseudonymize data
            safe_data = self.pseudonymize_data(data)
            
            # Process data
            result = await self.process_data(safe_data)
            
            # Log processing
            await self.log_processing(data.user_id, purpose)
            
            return result
        except Exception as e:
            await self.handle_processing_error(e)
```

### 2. Data Subject Rights
```python
class DataSubjectRights:
    async def handle_rights_request(self, request):
        """Handle data subject rights request"""
        try:
            # Verify identity
            if not await self.verify_identity(request):
                raise IdentityVerificationFailed()
                
            # Process request
            if request.type == 'access':
                return await self.provide_data_access(request)
            elif request.type == 'rectification':
                return await self.rectify_data(request)
            elif request.type == 'erasure':
                return await self.erase_data(request)
            elif request.type == 'portability':
                return await self.export_data(request)
                
        except Exception as e:
            await self.handle_request_error(e)
```

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Collect minimal data | Smallest compliance surface, lowest breach impact | Feature limitations, weaker analytics | Privacy-first products |
| Collect broadly | Rich features and ML | Regulatory exposure, retention burden | Data-centric products (with governance) |
| Pseudonymization | Analytics with reduced risk | Re-identification risk remains | Internal analytics |
| Encryption everywhere | Strong protection | Key management, query complexity | Sensitive PII |
| Tokenization | Safe downstream processing | Token vault to operate | Payments, identifiers |

**Utility vs privacy:** Every anonymization step reduces data utility; match de-identification depth to actual sensitivity and regulation.

**Retention vs risk:** Long retention powers historical analysis and grows liability; automated deletion turns policy into architecture.

**Compliance by design vs retrofit:** Embedding privacy controls early costs less than bolting them on after a regulator (or breach) forces the issue.

> **⚠️ When NOT to encrypt-and-call-it-private:** encryption without key discipline is theater — for public data it adds cost without risk reduction, and for PII it must pair with access controls and minimization, not replace them.

## Interview Tips

### 1. Key Considerations
- Privacy requirements
- Data protection measures
- Access control
- Audit requirements
- Incident response

### 2. Common Questions
1. How to implement data minimization?
2. How to handle sensitive data?
3. How to ensure data privacy?
4. How to implement audit trails?

### 3. Best Practices
- Implement privacy by design
- Use strong encryption
- Regular privacy impact assessments
- Clear documentation
- Employee training

## Further Reading
- [Privacy Patterns](https://privacypatterns.org/)
- [NIST Privacy Framework](https://www.nist.gov/privacy-framework)
- [Privacy by Design](https://www.ipc.on.ca/wp-content/uploads/resources/7foundationalprinciples.pdf)

