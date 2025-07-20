# Database Sharding

## Overview
Database sharding is a technique for horizontally partitioning data across multiple databases to improve scalability, performance, and manageability of large-scale applications.

## Key Concepts

### 1. Sharding Types
- **Horizontal Sharding**
  - Split rows across shards
  - Same schema per shard
  - Based on shard key
- **Vertical Sharding**
  - Split columns across shards
  - Different schemas
  - Based on functionality
- **Directory-Based Sharding**
  - Lookup table for shard mapping
  - Flexible but additional overhead
  - Centralized management

### 2. Sharding Strategies
- **Range Based**
  - Data divided by value ranges
  - Good for ordered data
  - Potential for hot spots
- **Hash Based**
  - Hash function determines shard
  - Even distribution
  - Harder to do range queries
- **Geographic**
  - Based on location
  - Reduced latency
  - Regulatory compliance
- **Directory Based**
  - Lookup table approach
  - Flexible but complex
  - Additional overhead

## Implementation Considerations

### 1. Shard Key Selection
- **Key Properties**
  - High cardinality
  - Even distribution
  - Query patterns
  - Future growth
- **Common Choices**
  - User ID
  - Geographic location
  - Time-based values
  - Composite keys

### 2. Data Distribution
- **Consistent Hashing**
  - Minimizes redistribution
  - Handles node changes
  - Complex implementation
- **Range Partitioning**
  - Simple to implement
  - Good for range queries
  - Potential imbalance

### 3. Cross-Shard Operations
- **Distributed Transactions**
  - ACID properties
  - Performance impact
  - Complexity
- **Eventual Consistency**
  - Better performance
  - Complex error handling
  - Data reconciliation

## Common Challenges

### 1. Data Consistency
- Cross-shard transactions
- Referential integrity
- Replication lag
- Data synchronization

### 2. Query Routing
- Shard determination
- Query optimization
- Cross-shard joins
- Aggregation

### 3. Operational Complexity
- Schema changes
- Data rebalancing
- Monitoring
- Backup and recovery

## Best Practices

### 1. Design Guidelines
- Choose appropriate shard key
- Plan for growth
- Consider query patterns
- Monitor shard balance

### 2. Performance Optimization
- Minimize cross-shard queries
- Use connection pooling
- Implement proper indexes
- Cache frequently accessed data

### 3. Maintenance Strategies
- Automated rebalancing
- Regular monitoring
- Backup procedures
- Failover planning

## Real-World Examples

### 1. Instagram's Approach
- User ID-based sharding
- PostgreSQL implementation
- Geographic considerations
- Scaling challenges

### 2. MongoDB Sharding
- Automated sharding
- Config servers
- Mongos routers
- Chunk management

## Interview Tips

### 1. Key Questions to Consider
- How to choose shard key?
- How to handle cross-shard queries?
- What consistency model to use?
- How to manage schema changes?

### 2. Common Pitfalls
- Poor shard key selection
- Ignoring data locality
- Overlooking operational complexity
- Inadequate monitoring

### 3. Design Patterns
- Federated Tables
- Scatter-Gather
- Fan-Out
- Composite Sharding

## Practice Exercises
1. Design a sharding strategy for a social network
2. Implement a simple sharded key-value store
3. Create a shard rebalancing system
4. Build a cross-shard query router

## Further Reading
- [MongoDB Sharding](https://docs.mongodb.com/manual/sharding/)
- [MySQL Sharding](https://dev.mysql.com/doc/refman/8.0/en/sharding.html)
- [Vitess](https://vitess.io/docs/overview/whatisvitess/)
- [Instagram Engineering Blog - Sharding & IDs](https://instagram-engineering.com/sharding-ids-at-instagram-1cf5a71e5a5c) 