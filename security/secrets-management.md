# Secrets Management

## Table of Contents
- [Introduction](#introduction)
- [Management Strategies](#management-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Security Controls](#security-controls)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Interview Tips](#interview-tips)

## Introduction

Secrets management involves secure storage, distribution, and lifecycle management of sensitive credentials and configuration.

### Key Benefits
1. **Secure Storage**
2. **Access Control**
3. **Audit Trail**
4. **Automated Rotation**
5. **Compliance**

## Management Strategies

### 1. Vault Management
```python
class VaultManager:
    def configure_vault(self):
        """Configure secrets vault"""
        return {
            'storage': {
                'type': 'hsm_backed',
                'encryption': 'aes256-gcm96',
                'seal_type': 'awskms'
            },
            'auth': {
                'methods': ['iam', 'kubernetes', 'cert'],
                'policies': {
                    'default': 'deny',
                    'rotation': 'allow'
                }
            },
            'audit': {
                'device': 'file',
                'retention': '30d',
                'format': 'json'
            }
        }
```

### 2. Key Rotation
```python
class KeyRotation:
    async def rotate_keys(self):
        """Implement key rotation"""
        try:
            # Generate new keys
            new_keys = await self.generate_keys()
            
            # Distribute keys
            await self.distribute_keys(new_keys)
            
            # Update services
            await self.update_services(new_keys)
            
            # Revoke old keys
            await self.revoke_old_keys()
            
        except Exception as e:
            await self.handle_rotation_error(e)
```

## Implementation Patterns

### 1. Secret Distribution
```python
class SecretDistributor:
    async def distribute_secrets(self, target):
        """Distribute secrets to services"""
        try:
            # Validate target
            if not self.validate_target(target):
                raise InvalidTarget()
                
            # Fetch secrets
            secrets = await self.fetch_secrets(target)
            
            # Encrypt for transit
            encrypted = self.encrypt_secrets(secrets)
            
            # Deliver secrets
            await self.deliver_secrets(encrypted, target)
            
            # Verify delivery
            await self.verify_delivery(target)
            
        except Exception as e:
            await self.handle_distribution_error(e)
```

### 2. Access Control
```python
class SecretAccess:
    def configure_access(self):
        """Configure secret access"""
        return {
            'roles': {
                'admin': {
                    'capabilities': ['create', 'read', 'update', 'delete'],
                    'paths': ['/*']
                },
                'app': {
                    'capabilities': ['read'],
                    'paths': ['/apps/${app_name}/*']
                }
            },
            'policies': {
                'rotation': {
                    'period': '30d',
                    'automatic': True
                },
                'access': {
                    'max_ttl': '1h',
                    'require_mfa': True
                }
            }
        }
```

## Security Controls

### 1. Encryption Management
```python
class EncryptionManager:
    def manage_encryption(self):
        """Manage secret encryption"""
        return {
            'keys': {
                'type': 'kms',
                'rotation': '90d',
                'algorithm': 'aes-256-gcm'
            },
            'transit': {
                'tls_version': '1.3',
                'cipher_suites': [
                    'TLS_AES_256_GCM_SHA384',
                    'TLS_CHACHA20_POLY1305_SHA256'
                ]
            },
            'storage': {
                'encryption': 'always',
                'key_derivation': 'pbkdf2'
            }
        }
```

### 2. Audit Logging
```python
class SecretAuditor:
    async def audit_access(self):
        """Audit secret access"""
        try:
            # Collect access logs
            logs = await self.collect_logs()
            
            # Analyze patterns
            patterns = self.analyze_patterns(logs)
            
            # Detect anomalies
            anomalies = await self.detect_anomalies(patterns)
            
            # Generate reports
            await self.generate_reports(logs, anomalies)
            
        except Exception as e:
            await self.handle_audit_error(e)
```

## Common Use Cases

### 1. Application Secrets
```python
class AppSecrets:
    async def manage_app_secrets(self, app):
        """Manage application secrets"""
        try:
            # Generate secrets
            secrets = await self.generate_secrets(app)
            
            # Store securely
            await self.store_secrets(secrets)
            
            # Configure access
            await self.configure_access(app)
            
            # Monitor usage
            await self.monitor_usage(app)
            
        except Exception as e:
            await self.handle_secrets_error(e)
```

### 2. Infrastructure Secrets
```python
class InfraSecrets:
    async def manage_infra_secrets(self):
        """Manage infrastructure secrets"""
        try:
            # Manage certificates
            await self.manage_certificates()
            
            # Handle credentials
            await self.handle_credentials()
            
            # Configure access
            await self.configure_access()
            
            # Setup rotation
            await self.setup_rotation()
            
        except Exception as e:
            await self.handle_infra_error(e)
```

## Trade-offs

| Choice | Pros | Cons | Best For |
|----------|------|------|----------|
| Central vault (Vault/KMS) | Audited access, rotation, lease semantics | Extra dependency, availability criticality | Production systems |
| Environment variables | Zero setup | Leak via logs, dumps, child processes | Local dev only |
| Encrypted config in repo | Versioned, reviewable | Key management still needed | Small teams, config secrets |
| Cloud-native secret stores | IAM-integrated, managed | Provider coupling | Cloud-centric stacks |

**Rotation frequency vs operational risk:** Frequent rotation shrinks exposure windows and breaks services on schedule slips; automate rotation or it will not happen.

**Availability vs security:** A vault that is down stops deployments and startups — plan cached leases and break-glass access.

**Centralization vs blast radius:** One vault is a high-value target with strong controls; scattered secrets are weaker targets with no audit trail.

> **⚠️ When NOT to use environment variables:** anything past local development — env vars leak through logs, crash dumps, child processes, and CI artifacts; a vault or platform secret store with rotation is the production floor.

## Interview Tips

### 1. Key Considerations
- Secret storage
- Access control
- Key rotation
- Audit logging
- Compliance requirements

### 2. Common Questions
1. How to manage secrets at scale?
2. How to implement rotation?
3. How to ensure security?
4. How to handle emergencies?

### 3. Best Practices
- Use vault systems
- Implement rotation
- Monitor access
- Encrypt everything
- Regular audits

## Further Reading
- [HashiCorp Vault](https://www.vaultproject.io/docs)
- [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)
- [NIST Key Management](https://csrc.nist.gov/projects/key-management)

