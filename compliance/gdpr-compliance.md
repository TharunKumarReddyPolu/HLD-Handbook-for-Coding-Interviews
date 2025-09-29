# GDPR Compliance in System Design

## Table of Contents
- [Introduction](#introduction)
- [GDPR Requirements](#gdpr-requirements)
- [Implementation Patterns](#implementation-patterns)
- [Technical Controls](#technical-controls)
- [Common Use Cases](#common-use-cases)
- [Interview Tips](#interview-tips)

## Introduction

GDPR compliance requires specific architectural considerations and technical controls in system design.

### Key Requirements
1. **Data Protection**
2. **User Rights**
3. **Consent Management**
4. **Data Minimization**
5. **Breach Notification**

## GDPR Requirements

### 1. Data Protection Principles
```python
class DataProtectionPrinciples:
    def define_principles(self):
        """Define GDPR principles"""
        return {
            'lawfulness': {
                'legal_basis': [
                    'consent',
                    'contract',
                    'legal_obligation',
                    'vital_interests',
                    'public_task',
                    'legitimate_interests'
                ]
            },
            'purpose_limitation': {
                'specified': True,
                'explicit': True,
                'legitimate': True
            },
            'data_minimization': {
                'adequate': True,
                'relevant': True,
                'limited': True
            },
            'accuracy': {
                'accurate': True,
                'up_to_date': True
            },
            'storage_limitation': {
                'time_limited': True,
                'justification_required': True
            }
        }
```

### 2. User Rights Management
```python
class UserRightsManager:
    def implement_user_rights(self):
        """Implement GDPR user rights"""
        return {
            'access': {
                'personal_data': True,
                'processing_purposes': True,
                'recipients': True
            },
            'rectification': {
                'correction': True,
                'completion': True
            },
            'erasure': {
                'deletion': True,
                'exceptions': [
                    'legal_obligation',
                    'public_interest'
                ]
            },
            'portability': {
                'export': True,
                'formats': ['JSON', 'CSV']
            },
            'object': {
                'direct_marketing': True,
                'automated_decisions': True
            }
        }
```

## Implementation Patterns

### 1. Consent Management
```python
class ConsentManager:
    async def manage_consent(self, user, purpose):
        """Manage user consent"""
        try:
            # Validate consent request
            if not self.validate_consent_purpose(purpose):
                raise InvalidConsentPurpose()
                
            # Record consent
            consent_record = await self.record_consent(
                user,
                purpose,
                timestamp=datetime.utcnow()
            )
            
            # Update processing status
            await self.update_processing_status(
                user,
                purpose,
                consent_record
            )
            
            return consent_record
        except Exception as e:
            await self.handle_consent_error(e)
```

### 2. Data Lifecycle Management
```python
class DataLifecycleManager:
    def configure_lifecycle(self):
        """Configure data lifecycle"""
        return {
            'collection': {
                'notice_required': True,
                'consent_required': True,
                'minimization_check': True
            },
            'storage': {
                'encryption': {
                    'at_rest': True,
                    'in_transit': True
                },
                'retention': {
                    'policy': 'time_based',
                    'duration': '2y'
                }
            },
            'processing': {
                'purpose_check': True,
                'logging_required': True
            },
            'deletion': {
                'method': 'secure_erase',
                'verification': True
            }
        }
```

## Technical Controls

### 1. Data Protection
```python
class DataProtection:
    def implement_controls(self):
        """Implement data protection controls"""
        return {
            'encryption': {
                'algorithms': {
                    'symmetric': 'AES-256-GCM',
                    'asymmetric': 'RSA-4096'
                },
                'key_management': {
                    'rotation': '90d',
                    'storage': 'HSM'
                }
            },
            'pseudonymization': {
                'method': 'tokenization',
                'scope': [
                    'personal_data',
                    'sensitive_data'
                ]
            },
            'access_control': {
                'authentication': 'MFA',
                'authorization': 'RBAC'
            }
        }
```

### 2. Breach Notification
```python
class BreachNotification:
    async def handle_breach(self, incident):
        """Handle data breach notification"""
        try:
            # Assess breach
            assessment = await self.assess_breach(incident)
            
            if assessment.requires_notification:
                # Notify authorities
                await self.notify_authorities(
                    incident,
                    deadline='72h'
                )
                
                # Notify affected users
                if assessment.high_risk:
                    await self.notify_users(incident)
                    
            # Document incident
            await self.document_breach(incident)
            
        except Exception as e:
            await self.handle_breach_error(e)
```

## Common Use Cases

### 1. User Data Management
```python
class UserDataManager:
    async def handle_data_request(self, request):
        """Handle user data request"""
        try:
            # Verify identity
            user = await self.verify_user(request)
            
            # Process request
            if request.type == 'access':
                return await self.provide_data_copy(user)
            elif request.type == 'delete':
                return await self.delete_user_data(user)
            elif request.type == 'export':
                return await self.export_user_data(user)
            elif request.type == 'update':
                return await self.update_user_data(user, request.data)
                
        except Exception as e:
            await self.handle_request_error(e)
```

### 2. Privacy by Design
```python
class PrivacyByDesign:
    def implement_privacy(self):
        """Implement privacy by design"""
        return {
            'data_collection': {
                'minimal': True,
                'purpose_bound': True,
                'consent_based': True
            },
            'data_access': {
                'need_to_know': True,
                'role_based': True,
                'logged': True
            },
            'data_processing': {
                'transparent': True,
                'documented': True,
                'reviewed': True
            },
            'data_storage': {
                'encrypted': True,
                'segregated': True,
                'time_limited': True
            }
        }
```

## Interview Tips

### 1. Key Considerations
- Data protection measures
- User rights implementation
- Consent management
- Breach handling
- Documentation requirements

### 2. Common Questions
1. How to implement right to be forgotten?
2. How to handle data portability?
3. How to manage consent?
4. How to ensure data minimization?

### 3. Best Practices
- Privacy by design
- Regular audits
- Clear documentation
- Staff training
- Incident response plan

## Further Reading
- [GDPR Official Text](https://gdpr-info.eu/)
- [Privacy by Design](https://www.ipc.on.ca/wp-content/uploads/resources/7foundationalprinciples.pdf)
- [GDPR Technical Implementation](https://www.enisa.europa.eu/publications/guidelines-for-smes-on-the-security-of-personal-data-processing)

