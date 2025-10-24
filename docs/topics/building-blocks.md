# Fundamental Building Blocks of Distributed Systems

The core components that power large-scale systems.

---

## System Architecture Overview

```mermaid
graph TB
    subgraph "Client Layer"
        C1[Web Browser]
        C2[Mobile App]
        C3[API Client]
    end

    subgraph "Edge Layer"
        CDN[CDN]
        LB[Load Balancer]
    end

    subgraph "Application Layer"
        API1[API Server 1]
        API2[API Server 2]
        API3[API Server 3]
        Cache[(Cache)]
    end

    subgraph "Data Layer"
        DB1[(Primary DB)]
        DB2[(Replica DB)]
        MQ[Message Queue]
    end

    subgraph "Storage Layer"
        S3[Object Storage]
        FS[File System]
    end

    C1 & C2 & C3 --> CDN
    CDN --> LB
    LB --> API1 & API2 & API3
    API1 & API2 & API3 --> Cache
    API1 & API2 & API3 --> DB1
    DB1 --> DB2
    API1 & API2 & API3 --> MQ
    API1 & API2 & API3 --> S3
```

---

## 1. Load Balancers

Distribute traffic across multiple servers.

```mermaid
graph LR
    Client[Client Requests] --> LB{Load Balancer}
    LB -->|Round Robin| S1[Server 1]
    LB -->|Least Connections| S2[Server 2]
    LB -->|IP Hash| S3[Server 3]

    style LB fill:#f9f,stroke:#333,stroke-width:4px
```

**Key Algorithms:**
- Round Robin: Distribute evenly
- Least Connections: Route to least busy server
- IP Hash: Consistent routing per client

---

## 2. Caching Layers

```mermaid
graph TD
    Request[Client Request] --> CDN{CDN Cache Hit?}
    CDN -->|Yes| Return1[Return Data]
    CDN -->|No| AppCache{App Cache Hit?}
    AppCache -->|Yes| Return2[Return Data]
    AppCache -->|No| DB[(Database)]
    DB --> AppCache
    AppCache --> CDN

    style CDN fill:#9cf
    style AppCache fill:#9cf
```

**Cache Levels:**
- **CDN**: Static assets (images, CSS, JS)
- **Application**: Session data, API responses
- **Database**: Query results

---

## 3. Database Patterns

### Master-Replica Replication

```mermaid
graph TB
    App[Application Servers]
    App -->|Write| Master[(Master DB)]
    App -->|Read| R1[(Replica 1)]
    App -->|Read| R2[(Replica 2)]
    App -->|Read| R3[(Replica 3)]

    Master -.->|Replicate| R1
    Master -.->|Replicate| R2
    Master -.->|Replicate| R3

    style Master fill:#f96,stroke:#333,stroke-width:3px
    style R1 fill:#9f9
    style R2 fill:#9f9
    style R3 fill:#9f9
```

### Database Sharding

```mermaid
graph TB
    App[Application] --> Router{Shard Router}

    Router -->|Users A-M| S1[(Shard 1<br/>A-M)]
    Router -->|Users N-Z| S2[(Shard 2<br/>N-Z)]
    Router -->|Users 0-9| S3[(Shard 3<br/>0-9)]

    style Router fill:#ff9,stroke:#333,stroke-width:3px
```

**Sharding Strategies:**
- Range-based (A-M, N-Z)
- Hash-based (user_id % num_shards)
- Geographic (US, EU, ASIA)

---

## 4. Message Queues

Asynchronous processing and decoupling.

```mermaid
sequenceDiagram
    participant Client
    participant API
    participant Queue
    participant Worker
    participant DB

    Client->>API: Upload Video
    API->>Queue: Add to processing queue
    API-->>Client: 202 Accepted (Job ID)

    Worker->>Queue: Poll for jobs
    Queue-->>Worker: Video processing task
    Worker->>Worker: Transcode video
    Worker->>DB: Update status
    Worker->>Client: Webhook notification
```

**Use Cases:**
- Video/image processing
- Email delivery
- Report generation
- Background tasks

---

## 5. Microservices Communication

```mermaid
graph TB
    Gateway[API Gateway]

    Gateway --> Auth[Auth Service]
    Gateway --> User[User Service]
    Gateway --> Order[Order Service]
    Gateway --> Payment[Payment Service]

    Order --> MQ[Message Queue]
    Payment --> MQ

    Auth --> AuthDB[(Auth DB)]
    User --> UserDB[(User DB)]
    Order --> OrderDB[(Order DB)]
    Payment --> PayDB[(Payment DB)]

    style Gateway fill:#f9f,stroke:#333,stroke-width:3px
```

**Key Patterns:**
- API Gateway: Single entry point
- Service Discovery: Find service instances
- Circuit Breaker: Handle failures gracefully

---

## 6. CDN (Content Delivery Network)

```mermaid
graph TB
    User1[User in US] --> CDN_US[CDN Edge<br/>US East]
    User2[User in EU] --> CDN_EU[CDN Edge<br/>EU West]
    User3[User in Asia] --> CDN_ASIA[CDN Edge<br/>Singapore]

    CDN_US -.->|Cache Miss| Origin[Origin Server]
    CDN_EU -.->|Cache Miss| Origin
    CDN_ASIA -.->|Cache Miss| Origin

    Origin --> S3[(Object Storage)]

    style Origin fill:#f96
    style CDN_US fill:#9cf
    style CDN_EU fill:#9cf
    style CDN_ASIA fill:#9cf
```

**Benefits:**
- Reduced latency (serve from nearby edge)
- Reduced load on origin servers
- DDoS protection

---

## 7. Data Flow Example: Social Media Post

```mermaid
sequenceDiagram
    participant User
    participant LB as Load Balancer
    participant API as API Server
    participant Cache
    participant DB as Database
    participant Queue as Message Queue
    participant Worker

    User->>LB: POST /create-post
    LB->>API: Route request
    API->>DB: Save post
    DB-->>API: Post saved (ID: 123)

    API->>Cache: Invalidate user feed cache
    API->>Queue: Notify followers
    API-->>User: 201 Created

    Worker->>Queue: Poll notifications
    Queue-->>Worker: Fan out to followers
    Worker->>DB: Update follower feeds
```

---

## Key Takeaways

| Component | Purpose | When to Use |
|-----------|---------|-------------|
| **Load Balancer** | Distribute traffic | Multiple servers |
| **Cache** | Speed up reads | Repeated requests |
| **Replicas** | Scale reads | Read-heavy workload |
| **Sharding** | Scale writes | Write-heavy workload |
| **Message Queue** | Async processing | Time-consuming tasks |
| **CDN** | Serve static files | Global users |

---

[← Back to Topics](index.md) | [Home](../index.md)
