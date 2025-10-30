# Microservices Introduction

## Concept
A **microservices architecture** breaks a large monolithic application into smaller, **independent services** that communicate via **APIs**.  
Each service handles a **specific business capability** (e.g., authentication, payments, catalog, orders).

---

## Core Components

| Component | Description |
|------------|--------------|
| **API Gateway** | Single entry point for all backend microservices. Handles routing, authentication, rate limiting, caching, and protocol translation. |
| **Service Registry / Discovery** | Tracks active service instances for dynamic discovery (e.g., *Consul, Eureka, etcd*). |
| **DNS** | Maps service names to IPs; often integrated with service discovery. |
| **Load Balancer** | Distributes traffic for high availability & scalability (*Nginx, AWS ELB*). |
| **Database per Service** | Each service owns its database for loose coupling (SQL or NoSQL). |
| **SQL Databases** | Structured, transactional, relational data (*PostgreSQL, MySQL*). |
| **NoSQL Databases** | Flexible, horizontally scalable (*MongoDB, DynamoDB, Cassandra*). |
| **Synchronous Communication** | Request-response via *HTTP/REST* or *gRPC*; simple but adds latency. |
| **Asynchronous Communication** | Event-driven via *Kafka*, *RabbitMQ*, *AWS SQS*; decoupled and scalable. |
| **Message Broker** | Manages queues, pub/sub, and event streaming (*Kafka, RabbitMQ*). |
| **Swagger / OpenAPI** | API documentation and testing tools. |
| **Event Sync / Event Bus** | Enables event-driven workflows and eventual consistency. |
| **Externalized Config & Logs** | Centralized management with *Spring Cloud Config*, *ELK Stack*. |
| **Monitoring / Tracing** | Observability with *Prometheus*, *Grafana*, *Jaeger*, *Zipkin*. |
| **Reporting / Analytics** | Aggregates data for BI (*ELK, Redshift, Snowflake*). |

---

## DNS (Domain Name System)

### Purpose
Translates human-readable domain names (e.g., `myapp.com`) into IP addresses (e.g., `192.168.1.2`).

### How It Works
1. Client requests `myapp.com`  
2. Resolver queries → Root → TLD → Authoritative server  
3. Returns IP address  
4. Browser connects to IP  

### Cloud Context
Managed via **AWS Route 53**, **Azure DNS**, **Cloudflare**, supporting load balancing and failover.

---

## Load Balancers

### Purpose
Distributes requests to multiple servers for:
- High availability  
- Fault tolerance  
- Scalability  

### Types

| Type | Operates On | Examples | Use Case |
|------|--------------|-----------|-----------|
| **L4 (Transport)** | TCP/UDP | AWS NLB, HAProxy | Fast, network-level routing |
| **L7 (Application)** | HTTP/HTTPS | AWS ALB, Nginx, Traefik | Smart, inspects headers & URLs |

### Features
- Health checks  
- Sticky sessions  
- SSL termination  
- Auto-scaling integration  

---

## Synchronous vs Asynchronous Communication

| Aspect | Synchronous | Asynchronous |
|--------|--------------|--------------|
| **Definition** | Caller waits for response | Caller sends message and continues |
| **Example** | REST API | Kafka, RabbitMQ |
| **Protocol** | HTTP/HTTPS | AMQP, MQTT |
| **Use Case** | Real-time (login) | Decoupled (notifications, billing) |
| **Drawback** | Tight coupling | Complex to debug |

**Visual:**  
- SYNC: Client → Service A → waits → Response  
- ASYNC: Client → Service A → Queue → Service B (later)

---

## SQL vs NoSQL Databases

| Feature | SQL (Relational) | NoSQL (Non-relational) |
|----------|------------------|--------------------------|
| Structure | Tables, rows | Key-value, Document, Graph |
| Schema | Fixed | Dynamic |
| Scaling | Vertical | Horizontal |
| Examples | MySQL, PostgreSQL | MongoDB, DynamoDB |
| Use Cases | Transactions | Scalable, flexible schema |
| Query Language | SQL | JSON-like/custom |

**Microservices often use both** (Polyglot Persistence).

---

## API Gateway

### Role
Sits between clients and backend microservices.

### Responsibilities

| Feature | Description |
|----------|--------------|
| Routing | Direct requests to proper service |
| Auth | Validate tokens (OAuth2, JWT) |
| Rate Limiting | Prevent overload |
| Request Transformation | Modify headers, URLs |
| Caching | Improve performance |
| Monitoring | Centralized tracing |

### Popular Gateways
- AWS API Gateway  
- Kong  
- Nginx  
- Istio  
- Apigee  

---

## Externalizing Logs

### Why
Container logs disappear after restarts → logs must be **centralized**.

### Common Setup

| Tool | Role |
|------|------|
| Fluentd / Fluent Bit / Logstash | Collect logs |
| Elasticsearch / Loki | Store & index |
| Kibana / Grafana | Visualize |
| Cloud-native | CloudWatch, Stackdriver |

### Benefits
- Unified view  
- Easier debugging  
- Log-based alerts  

---

## 12-Factor App Principles

| # | Factor | Description |
|---|---------|--------------|
| 1 | Codebase | One codebase, many deploys |
| 2 | Dependencies | Explicitly declared |
| 3 | Config | Stored in env variables |
| 4 | Backing Services | Treat as attached resources |
| 5 | Build, Release, Run | Separate stages |
| 6 | Processes | Stateless |
| 7 | Port Binding | Services via ports |
| 8 | Concurrency | Scale via process model |
| 9 | Disposability | Fast startup/shutdown |
| 10 | Dev/Prod Parity | Similar environments |
| 11 | Logs | Treat as event streams |
| 12 | Admin Processes | Run as one-off tasks |

Ensures portability, scalability, and resilience — ideal for **microservices**, **containers**, and **Kubernetes**.