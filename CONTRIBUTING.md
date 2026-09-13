# Contributing to HLD Handbook for Coding Interviews

First off, thank you for considering contributing to the HLD Handbook! Your contributions help make this resource invaluable for system design interview preparation. 🎉

## 📋 Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [How Can I Contribute?](#-how-can-i-contribute)
- [Style Guidelines](#-style-guidelines)
- [Commit Messages](#-commit-messages)
- [Pull Request Process](#-pull-request-process)
- [Topic Guidelines](#-topic-guidelines)
- [File Structure](#-file-structure)
- [Recognition](#-recognition)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## 🤝 How Can I Contribute?

### 1. Architecture Content
- Add new system design patterns
- Share distributed system concepts
- Document scalability strategies
- Add cloud architecture patterns
- Contribute modern architecture approaches

### 2. Technical Content
- Add architecture diagrams
- Improve code examples
- Share configuration samples
- Add deployment patterns
- Document performance optimizations

### 3. Interview Content
- Share system design questions
- Add case study solutions
- Provide scaling exercises
- Document trade-off analyses
- Share interview experiences

### 4. Other Ways to Help
- Report documentation gaps
- Suggest improvements
- Review pull requests
- Share real-world experiences
- Help others in discussions

## 📝 Style Guidelines

### Markdown Style
- Use appropriate headers (H1 for title, H2 for major sections)
- Include emojis for better visual organization
- Use code blocks with language specification
- Include architecture diagrams using Mermaid
- Keep line length under 120 characters
- Start every topic file with a Table of Contents linking to all H2 sections

### Architecture Diagrams
```markdown
\```mermaid
graph TD
    A[Client] --> B[Load Balancer]
    B --> C[Web Server]
    C --> D[Database]
\```
```

### Code Examples
```python
# Clear, focused examples that illustrate the concept
class LoadBalancer:
    def __init__(self):
        self.servers = []
        self.algorithm = "round_robin"
```

### Content Organization
- Start with system overview
- Define components clearly
- Include architecture diagrams
- Provide implementation considerations
- Document trade-offs
- Add scaling strategies
- Include monitoring approaches

## 💬 Commit Messages

Format: `<type>(<scope>): <subject>`

Types:
- `arch`: Architecture changes
- `docs`: Documentation updates
- `diag`: Diagram additions/updates
- `example`: New examples
- `fix`: Content corrections
- `case`: Case study additions

Examples:
```
arch(microservices): add service mesh pattern
docs(scaling): improve horizontal scaling explanation
diag(caching): add distributed cache diagram
```

## 🔄 Pull Request Process

1. **Fork the Repository**
   - Create your own fork
   - Clone locally

2. **Create a Branch**
   - Use descriptive names
   - Example: `feature/service-mesh-pattern`

3. **Make Changes**
   - Follow style guidelines
   - Include diagrams
   - Add practical examples
   - Document trade-offs

4. **Submit Pull Request**
   - Fill out PR template
   - Link related issues
   - Provide clear description
   - Include architecture changes

5. **Review Process**
   - Address feedback
   - Update diagrams if needed
   - Keep PR focused

## 📚 Topic Guidelines

### When Adding New Topics

1. **Structure** — every topic file follows this template:

```markdown
# Topic Name

## Table of Contents

## Introduction
Overview, context, and why this matters in interviews

## Core Concepts
Key terminology, components, and architecture diagrams (Mermaid)

## Patterns / Techniques
The main approaches, each with:
- How it works (diagram + pseudocode or reference implementation)
- When to use it (keywords and indicators)
- When NOT to use it

## Trade-offs
Comparison tables: consistency vs availability, cost vs performance, etc.

## Implementation Strategies
Reference implementations and configuration examples

## Scalability Considerations
How the technique behaves as load grows

## Real-World Examples
How real companies apply this, with concrete numbers where possible

## Common Pitfalls & Edge Cases
Frequent mistakes and failure modes to avoid

## Interview Tips
Key considerations, common questions, and decision frameworks

## Further Reading
Links to primary sources, docs, and deep dives
```

2. **Content Requirements**
   - Clear architecture diagrams (Mermaid, rendered in GitHub)
   - Trade-off analysis — system design interviews reward defending choices
   - Scalability considerations
   - Performance implications
   - Security aspects where relevant
   - Real-world examples
   - Interview-focused summary

3. **Before You Open a PR**
   - Verify all internal links resolve
   - Verify the topic is listed in the category README and the main README
   - Check that diagrams render correctly in the GitHub preview
   - CI runs `scripts/docs-lint.sh` — every topic file must contain the required sections (**Table of Contents**, **Trade-offs**, **Interview Tips**), so follow the topic template above

## 📁 File Structure

The handbook uses a **flat structure**: one file per topic, grouped into category folders.

```
HLD-Handbook-for-Coding-Interviews/
├── README.md                       # Main handbook entry point (all topics listed here)
├── CONTRIBUTING.md                 # This file
├── LICENSE
├── system-basics/                  # Fundamentals: caching, load balancing, APIs...
│   ├── README.md                   # Category overview + learning path
│   └── topic-name.md               # One file per topic
├── scalability/                    # Scaling, microservices, CAP theorem...
│   ├── README.md
│   └── topic-name.md
├── architecture/                   # Message queues, gateways, rate limiting...
│   ├── README.md
│   └── topic-name.md
├── data-engineering/               # Warehousing, ETL/ELT, modeling...
│   ├── README.md
│   └── topic-name.md
├── cloud-native/                   # Kubernetes, serverless, multi-cloud...
│   ├── README.md
│   └── topic-name.md
├── observability/                  # Logging, metrics, tracing, alerting...
│   ├── README.md
│   └── topic-name.md
├── security/                       # Zero trust, OAuth, API security...
│   ├── README.md
│   └── topic-name.md
├── testing/                        # Load, chaos, contract testing...
│   ├── README.md
│   └── topic-name.md
├── modern-architectures/           # AI/ML, edge, IoT, blockchain...
│   ├── README.md
│   └── topic-name.md
├── compliance/                     # GDPR, data privacy...
│   ├── README.md
│   └── topic-name.md
├── case-studies/                   # End-to-end system walkthroughs
│   ├── README.md
│   └── topic-name.md
├── best-practices/                 # Cross-cutting guidance
│   └── topic-name.md
└── interview-questions/            # Practice problems by difficulty
    ├── easy/README.md
    ├── medium/README.md
    └── hard/README.md
```

**When adding a new topic:**
1. Create `category/topic-name.md` following the topic template above
2. Add it to the category's `README.md` (topics list + learning path if applicable)
3. Add it to the **Topics Covered** section of the main `README.md`
4. Keep all links relative so the handbook works on GitHub and in local previews

## 🎨 Diagram Guidelines

### Use Mermaid for:
- System architecture
- Component interaction
- Data flow
- State transitions
- Sequence diagrams

Example:
```markdown
\```mermaid
sequenceDiagram
    Client->>API Gateway: Request
    API Gateway->>Auth Service: Validate
    Auth Service-->>API Gateway: Token
    API Gateway->>Service: Forward
\```
```

## ⭐ Recognition

Contributors will be acknowledged in:
- Project README
- Contributed files
- Contributors list
- Monthly highlights

## 🙏 Thank You!

Your contributions help make this handbook a comprehensive resource for system design interview preparation. We appreciate your expertise and time!

---

> **Note**: By contributing, you agree that your contributions will be licensed under the same terms as the main project.
