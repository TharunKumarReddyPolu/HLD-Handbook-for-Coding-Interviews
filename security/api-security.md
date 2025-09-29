# API Security Patterns

## Table of Contents
- [Introduction](#introduction)
- [Authentication Patterns](#authentication-patterns)
- [Authorization Patterns](#authorization-patterns)
- [Data Protection](#data-protection)
- [Common Use Cases](#common-use-cases)
- [Interview Tips](#interview-tips)

## Introduction

API security patterns provide standardized approaches to securing API endpoints and protecting data.

### Key Benefits
1. **Standardized Security**
2. **Attack Prevention**
3. **Data Protection**
4. **Access Control**
5. **Audit Trail**

## Authentication Patterns

### 1. JWT Authentication
```python
class JWTAuthenticator:
    def __init__(self):
        self.secret_key = os.getenv('JWT_SECRET')
        self.algorithm = 'HS256'
        
    def generate_token(self, user_data):
        """Generate JWT token"""
        payload = {
            'sub': user_data['id'],
            'name': user_data['name'],
            'roles': user_data['roles'],
            'exp': datetime.utcnow() + timedelta(hours=1)
        }
        
        return jwt.encode(
            payload,
            self.secret_key,
            algorithm=self.algorithm
        )
        
    def validate_token(self, token):
        """Validate JWT token"""
        try:
            payload = jwt.decode(
                token,
                self.secret_key,
                algorithms=[self.algorithm]
            )
            return payload
        except jwt.ExpiredSignatureError:
            raise TokenExpired()
        except jwt.InvalidTokenError:
            raise InvalidToken()
```

### 2. API Key Authentication
```python
class APIKeyAuthenticator:
    def validate_api_key(self, api_key, request):
        """Validate API key"""
        # Get stored key
        stored_key = await self.key_store.get_key(api_key)
        if not stored_key:
            return False
            
        # Check if key is active
        if not stored_key.is_active:
            return False
            
        # Validate scope
        if not self.validate_scope(stored_key, request):
            return False
            
        # Update usage metrics
        await self.update_metrics(stored_key, request)
        
        return True
```

## Authorization Patterns

### 1. Role-Based Access Control
```python
class RBACAuthorizer:
    def check_permission(self, user, resource, action):
        """Check RBAC permissions"""
        # Get user roles
        roles = self.get_user_roles(user)
        
        # Get required permissions
        required = self.get_required_permissions(
            resource,
            action
        )
        
        # Check permissions
        for role in roles:
            permissions = self.get_role_permissions(role)
            if required.issubset(permissions):
                return True
                
        return False
```

### 2. Attribute-Based Access Control
```python
class ABACAuthorizer:
    def evaluate_policy(self, request, resource):
        """Evaluate ABAC policy"""
        # Get attributes
        user_attrs = self.get_user_attributes(request.user)
        resource_attrs = self.get_resource_attributes(resource)
        env_attrs = self.get_environmental_attributes()
        
        # Evaluate policy
        policy = self.get_applicable_policy(
            resource_attrs['type']
        )
        
        return policy.evaluate(
            user_attrs,
            resource_attrs,
            env_attrs
        )
```

## Data Protection

### 1. Request Validation
```python
class RequestValidator:
    def validate_request(self, request):
        """Validate API request"""
        # Validate headers
        if not self.validate_headers(request.headers):
            raise InvalidHeaders()
            
        # Validate content type
        if not self.validate_content_type(request):
            raise InvalidContentType()
            
        # Validate body
        if not self.validate_body(request.body):
            raise InvalidBody()
            
        # Validate parameters
        if not self.validate_parameters(request.params):
            raise InvalidParameters()
```

### 2. Response Security
```python
class ResponseSecurityHandler:
    def secure_response(self, response):
        """Apply security headers"""
        headers = {
            'X-Content-Type-Options': 'nosniff',
            'X-Frame-Options': 'DENY',
            'X-XSS-Protection': '1; mode=block',
            'Content-Security-Policy': self.get_csp_policy(),
            'Strict-Transport-Security': 'max-age=31536000'
        }
        
        response.headers.update(headers)
        return response
```

## Common Use Cases

### 1. REST API Security
```python
class RESTSecurityMiddleware:
    async def process_request(self, request):
        """Secure REST API request"""
        try:
            # Authenticate request
            user = await self.authenticate(request)
            
            # Authorize request
            if not await self.authorize(user, request):
                raise Unauthorized()
                
            # Validate request
            self.validate_request(request)
            
            # Process request
            response = await self.handle_request(request)
            
            # Secure response
            return self.secure_response(response)
        except Exception as e:
            return self.handle_error(e)
```

### 2. GraphQL Security
```python
class GraphQLSecurity:
    def secure_schema(self, schema):
        """Apply GraphQL security"""
        return {
            'query_depth_limit': 10,
            'query_cost_limit': 1000,
            'rate_limit': {
                'window': 60,
                'max_requests': 100
            },
            'introspection': False
        }
        
    def validate_query(self, query):
        """Validate GraphQL query"""
        # Check depth
        if self.get_query_depth(query) > self.depth_limit:
            raise QueryTooDeep()
            
        # Check cost
        if self.calculate_cost(query) > self.cost_limit:
            raise QueryTooExpensive()
            
        # Validate operations
        self.validate_operations(query)
```

## Interview Tips

### 1. Key Considerations
- Authentication method
- Authorization model
- Input validation
- Output security
- Rate limiting

### 2. Common Questions
1. How to secure REST APIs?
2. When to use JWT vs API Keys?
3. How to implement RBAC/ABAC?
4. How to prevent common attacks?

### 3. Best Practices
- Use HTTPS always
- Validate all input
- Implement rate limiting
- Use proper authentication
- Regular security audits

## Further Reading
- [OWASP API Security](https://owasp.org/www-project-api-security/)
- [REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)
- [GraphQL Security](https://graphql.org/learn/best-practices/#security)

