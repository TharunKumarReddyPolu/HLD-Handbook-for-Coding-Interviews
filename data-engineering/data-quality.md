# Data Quality and Validation

## Table of Contents
- [Introduction](#introduction)
- [Quality Dimensions](#quality-dimensions)
- [Validation Strategies](#validation-strategies)
- [Implementation Patterns](#implementation-patterns)
- [Common Use Cases](#common-use-cases)
- [Trade-offs](#trade-offs)
- [Interview Tips](#interview-tips)

## Introduction

Data quality and validation ensure the reliability, accuracy, and consistency of data throughout its lifecycle.

### Key Benefits
1. **Reliable Analytics**
2. **Better Decision Making**
3. **Reduced Errors**
4. **Consistent Processing**
5. **Regulatory Compliance**

## Quality Dimensions

### 1. Data Accuracy
```python
class AccuracyValidator:
    def validate_accuracy(self, data):
        """Validate data accuracy"""
        return {
            'checks': {
                'range_check': {
                    'numeric_fields': {
                        'min': 0,
                        'max': 1000
                    },
                    'date_fields': {
                        'start': '2020-01-01',
                        'end': 'now'
                    }
                },
                'format_check': {
                    'email': r'^[\w\.-]+@[\w\.-]+\.\w+$',
                    'phone': r'^\+?1?\d{9,15}$'
                }
            }
        }
```

### 2. Data Completeness
```python
class CompletenessChecker:
    def check_completeness(self, dataset):
        """Check data completeness"""
        try:
            # Check required fields
            missing = self.check_required_fields(dataset)
            
            # Check null values
            nulls = self.check_null_values(dataset)
            
            # Check empty values
            empty = self.check_empty_values(dataset)
            
            return {
                'missing_fields': missing,
                'null_count': nulls,
                'empty_count': empty
            }
        except Exception as e:
            raise DataQualityError(str(e))
```

## Validation Strategies

### 1. Schema Validation
```python
class SchemaValidator:
    def validate_schema(self, data):
        """Validate data schema"""
        return {
            'fields': {
                'id': {
                    'type': 'string',
                    'required': True,
                    'unique': True
                },
                'name': {
                    'type': 'string',
                    'required': True,
                    'max_length': 100
                },
                'email': {
                    'type': 'string',
                    'required': True,
                    'pattern': 'email'
                },
                'age': {
                    'type': 'integer',
                    'min': 0,
                    'max': 150
                }
            }
        }
```

### 2. Business Rules
```python
class BusinessRuleValidator:
    async def validate_rules(self, data):
        """Validate business rules"""
        try:
            # Apply domain rules
            domain_valid = await self.check_domain_rules(data)
            
            # Apply relationship rules
            relation_valid = await self.check_relationships(data)
            
            # Apply constraint rules
            constraint_valid = await self.check_constraints(data)
            
            return all([
                domain_valid,
                relation_valid,
                constraint_valid
            ])
        except Exception as e:
            await self.handle_validation_error(e)
```

## Implementation Patterns

### 1. Data Profiling
```python
class DataProfiler:
    def profile_data(self, dataset):
        """Profile dataset"""
        return {
            'statistics': {
                'numeric': {
                    'mean': self.calculate_mean,
                    'std': self.calculate_std,
                    'quartiles': self.calculate_quartiles
                },
                'categorical': {
                    'unique_count': self.count_unique,
                    'frequency': self.calculate_frequency
                },
                'temporal': {
                    'range': self.calculate_range,
                    'patterns': self.detect_patterns
                }
            }
        }
```

### 2. Quality Monitoring
```python
class QualityMonitor:
    async def monitor_quality(self):
        """Monitor data quality"""
        try:
            # Collect metrics
            metrics = await self.collect_quality_metrics()
            
            # Check thresholds
            violations = self.check_thresholds(metrics)
            
            # Generate alerts
            if violations:
                await self.generate_alerts(violations)
                
            # Store results
            await self.store_quality_results(metrics)
            
        except Exception as e:
            await self.handle_monitoring_error(e)
```

## Common Use Cases

### 1. ETL Validation
```python
class ETLValidator:
    async def validate_etl(self, data):
        """Validate ETL process"""
        try:
            # Source validation
            source_valid = await self.validate_source(data)
            
            # Transformation validation
            transform_valid = await self.validate_transformation(data)
            
            # Load validation
            load_valid = await self.validate_load(data)
            
            return {
                'source': source_valid,
                'transform': transform_valid,
                'load': load_valid
            }
        except Exception as e:
            await self.handle_etl_error(e)
```

### 2. Data Pipeline Quality
```python
class PipelineQuality:
    async def check_pipeline_quality(self, pipeline):
        """Check data pipeline quality"""
        try:
            # Check data freshness
            freshness = await self.check_freshness(pipeline)
            
            # Check data consistency
            consistency = await self.check_consistency(pipeline)
            
            # Check data accuracy
            accuracy = await self.check_accuracy(pipeline)
            
            return {
                'freshness': freshness,
                'consistency': consistency,
                'accuracy': accuracy
            }
        except Exception as e:
            await self.handle_quality_error(e)
```

## Trade-offs

| Choice | Pros | Cons | Best For |
|--------|------|------|----------|
| Validate at ingestion | Catch errors early, clean downstream | Ingest latency, pipeline coupling | Structured critical feeds |
| Validate at consumption | Flexible, per-use-case rules | Bad data spreads before detection | Exploratory/analytics data |
| Strict blocking rules | Guarantees quality | Data loss on false positives | Financial/regulated data |
| Quarantine + alerting | No data loss, human review | Delayed availability, triage cost | Most production pipelines |

**Accuracy vs completeness:** Rejecting suspicious rows raises accuracy but loses volume; quarantine preserves data but delays it.

**Detection cost vs incident cost:** Heavy validation spends compute continuously; skipping it spends incident time episodically — rare but expensive.

**Manual review vs automation:** Human-in-the-loop handles edge cases well but does not scale; automate the common, escalate the rare.

## Interview Tips

### 1. Key Considerations
- Data quality dimensions
- Validation strategies
- Monitoring approach
- Error handling
- Scalability

### 2. Common Questions
1. How to ensure data quality?
2. How to handle data anomalies?
3. How to scale validation?
4. How to monitor quality?

### 3. Best Practices
- Define clear metrics
- Implement automated checks
- Monitor continuously
- Document rules
- Plan for failures

## Further Reading
- [Data Quality Guide](https://www.dqglobal.com/data-quality-guide/)
- [Data Validation Patterns](https://www.oreilly.com/library/view/data-quality/9780128166682/)
- [Data Quality Best Practices](https://www.informatica.com/resources/articles/data-quality-best-practices.html)

