# System Design Interview Approach

How FAANG companies evaluate system design skills.

---

## Interview Flow

```mermaid
graph LR
    A[Clarify Requirements<br/>5-10 min] --> B[High-Level Design<br/>10-15 min]
    B --> C[Deep Dive<br/>15-20 min]
    C --> D[Bottlenecks & Trade-offs<br/>5-10 min]

    style A fill:#9cf
    style B fill:#9f9
    style C fill:#ff9
    style D fill:#f9c
```

---

## Step 1: Requirements Clarification

```mermaid
mindmap
  root((Requirements))
    Functional
      Core features?
      User actions?
      API endpoints?
    Non-Functional
      Scale (Users/QPS)?
      Latency targets?
      Consistency needs?
    Constraints
      Budget?
      Technology stack?
      Timeline?
```

**Key Questions to Ask:**
- How many users? (DAU/MAU)
- Read vs Write ratio?
- Peak traffic patterns?
- Data retention period?
- Geographic distribution?

---

## Step 2: Capacity Estimation

```mermaid
graph TB
    Start[Requirements] --> Users[Users<br/>100M DAU]
    Users --> Requests[Requests<br/>10 actions/user/day]
    Requests --> QPS[QPS Calculation<br/>100M × 10 / 86400]
    QPS --> Result[~12K QPS<br/>Peak: 36K QPS]

    Start --> Data[Data Volume]
    Data --> Storage[Storage Calc<br/>1KB per action]
    Storage --> Total[Daily: ~1TB<br/>Yearly: ~365TB]

    style Result fill:#9f9
    style Total fill:#9f9
```

**Back-of-envelope Math:**
- QPS = (DAU × actions) / 86,400
- Peak QPS = Average QPS × 3
- Storage = QPS × data_size × seconds_per_day

---

## Step 3: API Design

```mermaid
sequenceDiagram
    participant Client
    participant API Gateway
    participant Service

    Note over Client,Service: POST /api/v1/posts
    Client->>API Gateway: Create Post
    API Gateway->>Service: Forward request
    Service-->>API Gateway: 201 Created {id: 123}
    API Gateway-->>Client: Response

    Note over Client,Service: GET /api/v1/feed?user_id=456
    Client->>API Gateway: Get Feed
    API Gateway->>Service: Forward request
    Service-->>API Gateway: 200 OK {posts: [...]}
    API Gateway-->>Client: Response
```

**Define Key APIs Early:**
- `POST /posts` - Create content
- `GET /feed` - Retrieve content
- `PUT /posts/:id` - Update content
- `DELETE /posts/:id` - Remove content

---

## Step 4: High-Level Design

```mermaid
graph TB
    Client[Clients] --> DNS[DNS]
    DNS --> CDN[CDN]
    CDN --> LB[Load Balancer]

    LB --> API1[API Server]
    LB --> API2[API Server]

    API1 & API2 --> Cache[(Redis Cache)]
    API1 & API2 --> DB[(Primary DB)]

    DB --> Replica1[(Replica)]
    DB --> Replica2[(Replica)]

    API1 & API2 --> Queue[Message Queue]
    Queue --> Worker1[Worker]
    Queue --> Worker2[Worker]

    Worker1 & Worker2 --> Storage[(Object Storage)]

    style LB fill:#f9f
    style Cache fill:#9cf
    style Queue fill:#ff9
```

**Start Simple, Then Iterate:**
1. Client → Server → Database
2. Add load balancer (multiple servers)
3. Add caching layer
4. Add database replicas
5. Add message queues for async tasks

---

## Step 5: Deep Dive Areas

```mermaid
mindmap
  root((Deep Dive<br/>Topics))
    Scalability
      Horizontal scaling
      Database sharding
      Caching strategy
    Performance
      Query optimization
      Index design
      CDN usage
    Reliability
      Failover handling
      Data replication
      Backup strategy
    Security
      Authentication
      Rate limiting
      Data encryption
```

**Interviewer May Ask:**
- "How do you handle 10x traffic?"
- "What if the cache fails?"
- "How do you ensure consistency?"
- "What about data privacy?"

---

## Step 6: Bottleneck Analysis

```mermaid
graph TB
    subgraph "Identify Bottlenecks"
        B1[Database writes<br/>Too slow?]
        B2[Memory cache<br/>Insufficient?]
        B3[Single point<br/>of failure?]
        B4[Network<br/>bandwidth?]
    end

    subgraph "Solutions"
        S1[Add write sharding<br/>Message queue]
        S2[Scale cache tier<br/>Multiple Redis clusters]
        S3[Add redundancy<br/>Multi-region deployment]
        S4[Use CDN<br/>Compress data]
    end

    B1 --> S1
    B2 --> S2
    B3 --> S3
    B4 --> S4

    style B1 fill:#f99
    style B2 fill:#f99
    style B3 fill:#f99
    style B4 fill:#f99
    style S1 fill:#9f9
    style S2 fill:#9f9
    style S3 fill:#9f9
    style S4 fill:#9f9
```

---

## Trade-offs Discussion

```mermaid
graph LR
    subgraph "Consistency vs Availability"
        C1[Strong Consistency<br/>SQL, ACID]
        C2[Eventual Consistency<br/>NoSQL, BASE]
    end

    subgraph "Latency vs Accuracy"
        L1[Real-time<br/>Approximate counts]
        L2[Batch Processing<br/>Exact counts]
    end

    subgraph "Cost vs Performance"
        P1[Premium Tier<br/>Low latency]
        P2[Standard Tier<br/>Higher latency]
    end

    style C1 fill:#9cf
    style C2 fill:#fc9
    style L1 fill:#9cf
    style L2 fill:#fc9
    style P1 fill:#9cf
    style P2 fill:#fc9
```

**Common Trade-offs:**
- **CAP Theorem**: Consistency vs Availability vs Partition Tolerance
- **Latency vs Consistency**: Fast reads vs accurate data
- **Storage vs Compute**: Denormalization vs joins
- **Cost vs Performance**: Premium infrastructure vs budget constraints

---

## Evaluation Criteria

```mermaid
graph TB
    Score[Interview Score]

    Score --> C1[Clarity of Thought<br/>30%]
    Score --> C2[Technical Depth<br/>30%]
    Score --> C3[Trade-off Analysis<br/>20%]
    Score --> C4[Communication<br/>20%]

    C1 --> R1[Clear requirements<br/>Structured approach]
    C2 --> R2[Component knowledge<br/>Scalability solutions]
    C3 --> R3[Pros/cons discussion<br/>Alternative approaches]
    C4 --> R4[Explain clearly<br/>Ask good questions]

    style Score fill:#f9f,stroke:#333,stroke-width:4px
```

---

## Common Mistakes to Avoid

```mermaid
graph TD
    M1[❌ Jumping to solution<br/>without clarifying]
    M2[❌ Over-engineering<br/>from the start]
    M3[❌ Ignoring constraints<br/>and scale]
    M4[❌ Not discussing<br/>trade-offs]
    M5[❌ Poor time<br/>management]

    M1 --> F1[✅ Ask questions first]
    M2 --> F2[✅ Start simple]
    M3 --> F3[✅ Calculate capacity]
    M4 --> F4[✅ Explain alternatives]
    M5 --> F5[✅ Watch the clock]

    style M1 fill:#f99
    style M2 fill:#f99
    style M3 fill:#f99
    style M4 fill:#f99
    style M5 fill:#f99
    style F1 fill:#9f9
    style F2 fill:#9f9
    style F3 fill:#9f9
    style F4 fill:#9f9
    style F5 fill:#9f9
```

---

## Interview Time Management

```mermaid
gantt
    title 45-Minute System Design Interview
    dateFormat mm:ss
    axisFormat %M:%S

    section Phase 1
    Requirements & Clarification :00:00, 10m

    section Phase 2
    High-Level Design :10:00, 15m

    section Phase 3
    Deep Dive Components :25:00, 12m

    section Phase 4
    Bottlenecks & Wrap-up :37:00, 8m
```

---

## Practice Problems by Difficulty

```mermaid
graph TB
    subgraph Easy
        E1[URL Shortener]
        E2[Pastebin]
        E3[Key-Value Store]
    end

    subgraph Medium
        M1[Twitter Feed]
        M2[Instagram]
        M3[Uber]
    end

    subgraph Hard
        H1[Google Search]
        H2[Netflix]
        H3[WhatsApp]
    end

    Easy --> Medium --> Hard

    style Easy fill:#9f9
    style Medium fill:#ff9
    style Hard fill:#f99
```

---

## Key Takeaways

1. **Always clarify first** - Don't assume requirements
2. **Start simple** - Build incrementally
3. **Numbers matter** - Do back-of-envelope calculations
4. **Think out loud** - Communicate your reasoning
5. **Discuss trade-offs** - There's no perfect solution
6. **Practice regularly** - Muscle memory is key

---

[← Back to Topics](index.md) | [Home](../index.md)
