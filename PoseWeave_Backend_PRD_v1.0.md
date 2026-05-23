# PoseWeave — Backend Product Requirements Document
## API & Infrastructure Specification
**Version:** 1.0  
**Date:** 2026-05-23  
**Architecture:** Offline-First Optional Sync  
**Budget Constraint:** 100% Free Tier / Zero Cloud Spend  
**Target:** Interview portfolio + extensible production foundation

---

## 1. Executive Summary

The PoseWeave backend is designed as an **optional sync layer** — the mobile app functions 100% offline with local SQLite. The backend only activates when the user opts into cloud backup, social features, or cross-device sync.

**Core Philosophy:**
- **Offline-first:** App never depends on the backend to function.
- **Free-tier maximalism:** Every service runs on free tiers indefinitely.
- **Privacy-preserving:** Raw pose data (33 landmarks/frame) is expensive to store. We store **aggregated session metadata** + **optional encrypted exports**.
- **Interview-grade:** Demonstrates full-stack architecture, auth, sync strategy, and database design.

---

## 2. Architecture Overview

### 2.1 System Context Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐ │
│  │ Flutter App      │  │ Flutter App      │  │ Admin Dashboard    │ │
│  │ (Redmi 10)       │  │ (iPhone 14)      │  │ (React Web)        │ │
│  │                  │  │                  │  │                    │ │
│  │ • SQLite (local) │  │ • SQLite (local) │  │ • View analytics   │ │
│  │ • ML Kit (local) │  │ • ML Kit (local) │  │ • Manage users     │ │
│  │ • Optional sync  │  │ • Optional sync  │  │ • System health    │ │
│  └────────┬────────┘  └────────┬────────┘  └────────┬───────────┘ │
└───────────┼────────────────────┼────────────────────┼─────────────┘
            │                    │                    │
            │ HTTPS/JSON         │ HTTPS/JSON         │ HTTPS/JSON
            │ JWT Bearer         │ JWT Bearer         │ JWT Bearer (Admin)
            │                    │                    │
┌───────────▼────────────────────▼────────────────────▼─────────────┐
│                         API GATEWAY LAYER                            │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │  Node.js 20 + Express.js 4.x                                   │ │
│  │  • Rate limiting (express-rate-limit)                            │ │
│  │  • CORS (cors)                                                 │ │
│  │  • Helmet security headers                                     │ │
│  │  • Request validation (Joi/Zod)                                │ │
│  │  • JWT verification middleware                                 │ │
│  └─────────────────────────────────────────────────────────────┘ │
└───────────────────────────┬───────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼───────┐  ┌────────▼────────┐  ┌─────▼──────┐
│  Auth Service │  │  Core Service    │  │  Sync      │
│  (Passport.js)│  │  (Business Logic)│  │  Service   │
│               │  │                  │  │            │
│ • Register    │  │ • Sessions CRUD  │  │ • Delta    │
│ • Login       │  │ • Leaderboard    │  │   sync     │
│ • JWT refresh │  │ • Challenges     │  │ • Conflict │
│ • OAuth       │  │ • Analytics      │  │   resolution
└───────┬───────┘  └────────┬────────┘  └─────┬──────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
┌───────────────────────────▼───────────────────────────────────────┐
│                        DATA LAYER                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │
│  │ PostgreSQL   │  │ Redis        │  │ AWS S3 / Supabase        │  │
│  │ 15 (Free)    │  │ 16 (Free)    │  │ Storage (Free Tier)      │  │
│  │              │  │              │  │                          │  │
│  │ • Users      │  │ • Sessions   │  │ • Video exports          │  │
│  │ • Sessions   │  │ • Rate limit │  │ • Profile avatars        │  │
│  │ • Challenges │  │ • Leaderboard│  │ • Reference pose videos  │  │
│  │ • Analytics  │  │   cache      │  │                          │  │
│  └──────────────┘  └──────────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Deployment Architecture (Free Tier)

```
┌────────────────────────────────────────┐
│           RENDER.COM (Free)            │
│  ┌────────────────────────────────┐   │
│  │  Web Service: Node.js + Express  │   │
│  │  • 512 MB RAM                    │   │
│  │  • 0.1 CPU                       │   │
│  │  • Auto-sleep after 15 min idle  │   │
│  │  • Wakes on request (2-3s cold)  │   │
│  └────────────────────────────────┘   │
└──────────────────┬─────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
┌───────▼────────┐   ┌────────▼────────┐
│  NEON.TECH     │   │  UPSTASH.COM   │
│  PostgreSQL    │   │  Redis         │
│  (Free Tier)   │   │  (Free Tier)   │
│                │   │                │
│  • 500 MB storage│  │  • 30 MB storage│
│  • 10 connections│  │  • 10k cmds/day │
│  • Auto-sleep    │  │  • Low latency  │
└────────────────┘   └────────────────┘
```

**Alternative:** Supabase (free tier) combines PostgreSQL + Auth + Storage in one platform. Good for rapid prototyping.

---

## 3. Tech Stack & Senior Rationale

| Layer | Technology | Version | Why This Choice |
|-------|-----------|---------|-----------------|
| **Runtime** | Node.js | 20 LTS | User has Node.js/Express experience (resume). Non-blocking I/O perfect for sync APIs. |
| **Framework** | Express.js | 4.19+ | Minimal, battle-tested, vast middleware ecosystem. NestJS is overkill for this scope. |
| **Database** | PostgreSQL | 15+ | Relational data (users, sessions, challenges) fits SQL. JSONB columns handle flexible pose metadata. Free tier available. |
| **Cache** | Redis | 7+ | Session store, rate limiting, leaderboard hot cache. Upstash free tier is zero-config. |
| **Auth** | Passport.js + JWT | Latest | Stateless auth. Refresh token rotation. OAuth 2.0 ready (Google/Apple). |
| **Validation** | Zod | 3.23+ | TypeScript-first schema validation. Infer types from schemas = single source of truth. |
| **ORM** | Prisma | 5.14+ | Type-safe queries, migration system, excellent PostgreSQL support. Better than raw SQL for interview code quality. |
| **Storage** | Supabase Storage | Free tier | S3-compatible. 1GB free. Handles video exports + avatars. |
| **Deploy** | Render.com | Free tier | Zero-config Node.js hosting. Git push → auto-deploy. Custom domain support. |
| **Monitoring** | UptimeRobot + Logtail | Free tier | Health checks every 5 min. Log aggregation for debugging. |

**Rejected Alternatives:**
- **Firebase:** Violates "no cloud vendor lock-in" principle. Costs scale unpredictably.
- **MongoDB:** Pose data is relational (users → sessions → poses). PostgreSQL JSONB handles flexibility better.
- **GraphQL:** Overkill for CRUD sync API. REST is simpler to implement and explain in interviews.
- **Docker/Kubernetes:** Free tier doesn't support K8s. Render native deploy is sufficient.

---

## 4. Database Schema

### 4.1 Entity Relationship Diagram

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│    users     │       │   sessions   │       │    poses     │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ id (PK)      │1    * │ id (PK)      │1    * │ id (PK)      │
│ email (UQ)   │───────│ user_id (FK) │───────│ session_id(FK)│
│ password_hash│       │ started_at   │       │ timestamp    │
│ display_name │       │ ended_at     │       │ landmarks    │
│ avatar_url   │       │ exercise_type│       │ confidence   │
│ created_at   │       │ total_reps   │       │ (JSONB)      │
│ updated_at   │       │ avg_form_score│      └──────────────┘
│ is_premium   │       │ max_rom        │
│ timezone     │       │ asymmetry_flag │
└──────────────┘       │ sync_status    │
                       │ device_id      │
                       └──────────────┘
                              │
                              │1
                              │
                       ┌──────▼──────┐
                       │  challenges │
                       ├─────────────┤
                       │ id (PK)     │
                       │ session_id  │
                       │ type        │
                       │ target_reps │
                       │ time_limit  │
                       │ grade       │
                       │ completed_at│
                       └─────────────┘
```

### 4.2 Table Specifications

#### `users`
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,  -- bcrypt, 12 rounds
  display_name VARCHAR(50),
  avatar_url TEXT,
  timezone VARCHAR(50) DEFAULT 'UTC',
  is_premium BOOLEAN DEFAULT FALSE,
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_sync_at TIMESTAMPTZ
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_last_sync ON users(last_sync_at);
```

#### `sessions` (Workout Sessions)
```sql
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  device_id VARCHAR(100) NOT NULL,  -- "android_abc123" or "ios_xyz789"

  -- Timing
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  duration_seconds INT,

  -- Exercise metadata
  exercise_type VARCHAR(50) NOT NULL,  -- 'squat', 'pushup', 'jumping_jack', 'freeform'

  -- Aggregated metrics (computed on device, verified on server)
  total_reps INT DEFAULT 0,
  avg_form_score DECIMAL(5,2),  -- 0.00 - 100.00
  max_rom DECIMAL(5,2),         -- Max range of motion achieved
  min_rom DECIMAL(5,2),
  asymmetry_flag BOOLEAN DEFAULT FALSE,
  injury_risk_count INT DEFAULT 0,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'pending',  -- 'pending', 'synced', 'conflict'
  client_created_at TIMESTAMPTZ NOT NULL,  -- Device clock timestamp
  client_updated_at TIMESTAMPTZ,
  server_created_at TIMESTAMPTZ DEFAULT NOW(),

  -- Raw data reference (optional, for premium)
  raw_data_url TEXT,  -- Link to S3/Supabase stored JSON file

  UNIQUE(user_id, device_id, client_created_at)
);

CREATE INDEX idx_sessions_user_time ON sessions(user_id, started_at DESC);
CREATE INDEX idx_sessions_device ON sessions(device_id, sync_status);
CREATE INDEX idx_sessions_type ON sessions(exercise_type, avg_form_score DESC);
```

#### `pose_frames` (Individual Frame Data — Optional)
```sql
-- WARNING: This table grows FAST. 
-- 30 FPS × 60 seconds = 1,800 rows per minute.
-- Only store if user opts into "detailed analytics" or premium.
CREATE TABLE pose_frames (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  frame_index INT NOT NULL,
  timestamp_ms INT NOT NULL,  -- Milliseconds from session start

  -- 33 landmarks stored as JSONB (PostgreSQL native JSON)
  landmarks JSONB NOT NULL,

  -- Computed metrics for this frame
  form_score DECIMAL(5,2),
  detected_asymmetry BOOLEAN DEFAULT FALSE,
  injury_risk_flags JSONB,  -- Array of strings: ['knee_valgus', 'back_rounding']

  UNIQUE(session_id, frame_index)
);

CREATE INDEX idx_pose_frames_session ON pose_frames(session_id, frame_index);
-- Use BRIN index for time-series data (efficient for append-only)
CREATE INDEX idx_pose_frames_time ON pose_frames USING BRIN(timestamp_ms);
```

#### `challenges` (Gamification)
```sql
CREATE TABLE challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID REFERENCES sessions(id) ON DELETE SET NULL,

  challenge_type VARCHAR(50) NOT NULL,  -- 'time_attack', 'endurance', 'form_master'
  exercise_type VARCHAR(50) NOT NULL,

  -- Targets
  target_reps INT,
  time_limit_seconds INT,

  -- Results
  actual_reps INT,
  actual_time_seconds INT,
  avg_form_score DECIMAL(5,2),
  grade CHAR(1),  -- 'S', 'A', 'B', 'C', 'D'

  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_challenges_user_grade ON challenges(user_id, grade, completed_at DESC);
```

#### `leaderboard` (Materialized View)
```sql
-- Refreshed every hour via cron job or trigger
CREATE MATERIALIZED VIEW leaderboard_weekly AS
SELECT 
  user_id,
  display_name,
  exercise_type,
  COUNT(*) as session_count,
  SUM(total_reps) as total_reps,
  AVG(avg_form_score)::DECIMAL(5,2) as avg_form,
  MAX(grade) as best_grade,  -- S > A > B > C > D
  RANK() OVER (PARTITION BY exercise_type ORDER BY SUM(total_reps) DESC) as rank
FROM sessions s
JOIN users u ON s.user_id = u.id
WHERE started_at > NOW() - INTERVAL '7 days'
  AND sync_status = 'synced'
GROUP BY user_id, display_name, exercise_type;

CREATE UNIQUE INDEX idx_leaderboard_pk ON leaderboard_weekly(user_id, exercise_type);
```

### 4.3 Prisma Schema (Source of Truth)

```prisma
// schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id            String    @id @default(uuid())
  email         String    @unique
  passwordHash  String    @map("password_hash")
  displayName   String?   @map("display_name")
  avatarUrl     String?   @map("avatar_url")
  timezone      String    @default("UTC")
  isPremium     Boolean   @default(false) @map("is_premium")
  emailVerified Boolean   @default(false) @map("email_verified")
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  lastSyncAt    DateTime? @map("last_sync_at")

  sessions    Session[]
  challenges  Challenge[]

  @@map("users")
}

model Session {
  id                String   @id @default(uuid())
  userId            String   @map("user_id")
  deviceId          String   @map("device_id")
  startedAt         DateTime @map("started_at")
  endedAt           DateTime? @map("ended_at")
  durationSeconds   Int?     @map("duration_seconds")
  exerciseType      String   @map("exercise_type")
  totalReps         Int      @default(0) @map("total_reps")
  avgFormScore      Decimal? @map("avg_form_score") @db.Decimal(5, 2)
  maxRom            Decimal? @map("max_rom") @db.Decimal(5, 2)
  minRom            Decimal? @map("min_rom") @db.Decimal(5, 2)
  asymmetryFlag     Boolean  @default(false) @map("asymmetry_flag")
  injuryRiskCount   Int      @default(0) @map("injury_risk_count")
  syncStatus        String   @default("pending") @map("sync_status")
  clientCreatedAt   DateTime @map("client_created_at")
  clientUpdatedAt   DateTime? @map("client_updated_at")
  serverCreatedAt   DateTime @default(now()) @map("server_created_at")
  rawDataUrl        String?  @map("raw_data_url")

  user        User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  poseFrames  PoseFrame[]
  challenges  Challenge[]

  @@unique([userId, deviceId, clientCreatedAt])
  @@index([userId, startedAt(sort: Desc)])
  @@index([deviceId, syncStatus])
  @@map("sessions")
}

model PoseFrame {
  id                String   @id @default(uuid())
  sessionId         String   @map("session_id")
  frameIndex        Int      @map("frame_index")
  timestampMs       Int      @map("timestamp_ms")
  landmarks         Json
  formScore         Decimal? @map("form_score") @db.Decimal(5, 2)
  detectedAsymmetry Boolean  @default(false) @map("detected_asymmetry")
  injuryRiskFlags   Json?    @map("injury_risk_flags")

  session Session @relation(fields: [sessionId], references: [id], onDelete: Cascade)

  @@unique([sessionId, frameIndex])
  @@index([sessionId, frameIndex])
  @@map("pose_frames")
}

model Challenge {
  id                  String    @id @default(uuid())
  userId              String    @map("user_id")
  sessionId           String?   @map("session_id")
  challengeType       String    @map("challenge_type")
  exerciseType        String    @map("exercise_type")
  targetReps          Int?      @map("target_reps")
  timeLimitSeconds    Int?      @map("time_limit_seconds")
  actualReps          Int?      @map("actual_reps")
  actualTimeSeconds   Int?      @map("actual_time_seconds")
  avgFormScore        Decimal?  @map("avg_form_score") @db.Decimal(5, 2)
  grade               String?   @db.Char(1)
  completedAt         DateTime? @map("completed_at")
  createdAt           DateTime  @default(now()) @map("created_at")

  user    User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  session Session? @relation(fields: [sessionId], references: [id], onDelete: SetNull)

  @@index([userId, grade, completedAt(sort: Desc)])
  @@map("challenges")
}
```

---

## 5. API Specification

### 5.1 Base URL & Versioning

```
Production:  https://api.poseweave.app/v1
Development: http://localhost:3000/v1
```

**Headers (all requests):**
```http
Content-Type: application/json
Authorization: Bearer <jwt_access_token>
X-Device-ID: <device_uuid>
X-App-Version: 1.0.0
```

### 5.2 Authentication Endpoints

#### POST `/v1/auth/register`
```json
// Request
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "displayName": "Fitness Fan",
  "timezone": "Asia/Kolkata"
}

// Response 201
{
  "success": true,
  "data": {
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "displayName": "Fitness Fan",
      "createdAt": "2026-05-23T10:00:00Z"
    },
    "tokens": {
      "accessToken": "eyJhbG...",
      "refreshToken": "eyJhbG...",
      "expiresIn": 900  // 15 minutes
    }
  }
}
```

#### POST `/v1/auth/login`
```json
// Request
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

// Response 200
{
  "success": true,
  "data": {
    "tokens": { "accessToken": "...", "refreshToken": "...", "expiresIn": 900 }
  }
}
```

#### POST `/v1/auth/refresh`
```json
// Request
{
  "refreshToken": "eyJhbG..."
}

// Response 200 — Rotates refresh token (security best practice)
{
  "success": true,
  "data": {
    "tokens": { "accessToken": "...", "refreshToken": "NEW_TOKEN", "expiresIn": 900 }
  }
}
```

#### POST `/v1/auth/logout`
```json
// Request — Blacklists refresh token in Redis
{
  "refreshToken": "eyJhbG..."
}

// Response 204 No Content
```

### 5.3 Session Sync Endpoints (Core)

#### POST `/v1/sync/sessions` — Bulk Upload
```json
// Request — Client sends multiple sessions from SQLite
{
  "deviceId": "android_redmi10_abc123",
  "lastSyncAt": "2026-05-22T14:30:00Z",
  "sessions": [
    {
      "clientId": "local_session_001",  // Client-generated UUID
      "startedAt": "2026-05-23T09:00:00Z",
      "endedAt": "2026-05-23T09:15:00Z",
      "exerciseType": "squat",
      "totalReps": 47,
      "avgFormScore": 78.5,
      "maxRom": 145.2,
      "asymmetryFlag": true,
      "injuryRiskCount": 2,
      "clientCreatedAt": "2026-05-23T09:00:00Z"
    }
  ]
}

// Response 200 — Server acknowledges, returns server IDs for mapping
{
  "success": true,
  "data": {
    "synced": 1,
    "conflicts": 0,
    "failed": 0,
    "sessionMappings": [
      {
        "clientId": "local_session_001",
        "serverId": "550e8400-e29b-41d4-a716-446655440001",
        "status": "synced"
      }
    ],
    "serverTimestamp": "2026-05-23T10:05:00Z"
  }
}
```

**Conflict Resolution Strategy:**
- If `clientCreatedAt` + `deviceId` + `userId` already exists → **Server wins** (last-write-wins for metadata).
- If client has newer `clientUpdatedAt` than server → **Client wins**.
- Conflicts returned in `conflicts` array for manual resolution.

#### GET `/v1/sync/sessions` — Download Server Sessions
```http
GET /v1/sync/sessions?since=2026-05-20T00:00:00Z&limit=50&offset=0
```

```json
// Response 200
{
  "success": true,
  "data": {
    "sessions": [
      {
        "id": "550e8400...",
        "startedAt": "2026-05-21T08:00:00Z",
        "exerciseType": "pushup",
        "totalReps": 32,
        "avgFormScore": 82.3,
        // ... full session object
      }
    ],
    "pagination": {
      "total": 127,
      "limit": 50,
      "offset": 0,
      "hasMore": true
    },
    "serverTimestamp": "2026-05-23T10:05:00Z"
  }
}
```

#### POST `/v1/sync/sessions/:id/frames` — Upload Detailed Frame Data (Optional)
```json
// Request — Only for premium users or explicit opt-in
{
  "frames": [
    {
      "frameIndex": 0,
      "timestampMs": 0,
      "landmarks": { /* 33 landmarks JSON */ },
      "formScore": 75.0
    }
  ]
}

// Response 202 Accepted (processed async via queue)
{
  "success": true,
  "data": {
    "uploadId": "upload_abc123",
    "status": "processing",
    "estimatedCompletion": "2026-05-23T10:06:00Z"
  }
}
```

### 5.4 Analytics Endpoints

#### GET `/v1/analytics/summary`
```json
// Response 200
{
  "success": true,
  "data": {
    "totalSessions": 42,
    "totalReps": 1247,
    "avgFormScore": 76.4,
    "streakDays": 7,
    "favoriteExercise": "squat",
    "improvementTrend": "+12%",  // vs last week
    "weeklyBreakdown": [
      { "week": "2026-W20", "sessions": 5, "reps": 180, "avgForm": 74.2 },
      { "week": "2026-W21", "sessions": 6, "reps": 210, "avgForm": 78.5 }
    ]
  }
}
```

#### GET `/v1/analytics/rom-progress`
```http
GET /v1/analytics/rom-progress?exercise=squat&joint=knee&period=30d
```

```json
// Response 200
{
  "success": true,
  "data": {
    "exercise": "squat",
    "joint": "knee",
    "dataPoints": [
      { "date": "2026-05-01", "maxRom": 125.0, "avgRom": 110.5 },
      { "date": "2026-05-15", "maxRom": 142.0, "avgRom": 128.3 }
    ],
    "trend": "improving",
    "percentChange": 14.2
  }
}
```

### 5.5 Social / Leaderboard Endpoints

#### GET `/v1/leaderboard`
```http
GET /v1/leaderboard?exercise=squat&period=weekly&limit=50
```

```json
// Response 200
{
  "success": true,
  "data": {
    "exercise": "squat",
    "period": "weekly",
    "leaderboard": [
      {
        "rank": 1,
        "displayName": "SquatKing",
        "totalReps": 450,
        "avgForm": 88.5,
        "bestGrade": "S",
        "isCurrentUser": false
      },
      {
        "rank": 7,
        "displayName": "Fitness Fan",  // Current user
        "totalReps": 210,
        "avgForm": 78.5,
        "bestGrade": "A",
        "isCurrentUser": true
      }
    ],
    "userRank": 7,
    "totalParticipants": 342
  }
}
```

### 5.6 Challenge Endpoints

#### POST `/v1/challenges`
```json
// Request — Create a personal challenge
{
  "exerciseType": "squat",
  "challengeType": "time_attack",
  "targetReps": 30,
  "timeLimitSeconds": 60
}

// Response 201
{
  "success": true,
  "data": {
    "id": "challenge_001",
    "status": "active",
    "expiresAt": "2026-05-24T09:00:00Z"
  }
}
```

#### POST `/v1/challenges/:id/complete`
```json
// Request — Submit challenge results
{
  "sessionId": "550e8400...",
  "actualReps": 32,
  "actualTimeSeconds": 58,
  "avgFormScore": 85.0
}

// Response 200
{
  "success": true,
  "data": {
    "grade": "S",
    "newPersonalBest": true,
    "rankOnLeaderboard": 3
  }
}
```

### 5.7 Reference Poses (Shared Library)

#### GET `/v1/reference-poses`
```json
// Response 200
{
  "success": true,
  "data": [
    {
      "id": "ref_squat_perfect",
      "name": "Perfect Squat",
      "exerciseType": "squat",
      "difficulty": "intermediate",
      "thumbnailUrl": "https://...",
      "landmarks": { /* 33 landmarks JSON */ },
      "keyAngles": {
        "knee": { "min": 85, "max": 110, "ideal": 95 },
        "hip": { "min": 40, "max": 60, "ideal": 50 }
      },
      "instructions": ["Feet shoulder-width", "Chest up", "Hips below knees"]
    }
  ]
}
```

---

## 6. Authentication & Security

### 6.1 JWT Strategy

```
Access Token:  15-minute expiry, HS256, contains { userId, email, iat, exp }
Refresh Token: 7-day expiry, stored in Redis (blacklist on logout), rotation on use
```

**Token Refresh Flow:**
```
Client (has refresh token)
    │
    ▼
POST /v1/auth/refresh
    │
    ▼
Server verifies refresh token against Redis
    │
    ▼
Server issues NEW access token + NEW refresh token
    │
    ▼
Old refresh token blacklisted in Redis (TTL = remaining expiry)
```

### 6.2 Rate Limiting

| Endpoint | Limit | Window | Storage |
|----------|-------|--------|---------|
| `/v1/auth/*` | 5 requests | 15 minutes | Redis |
| `/v1/sync/*` | 30 requests | 1 minute | Redis |
| `/v1/leaderboard` | 100 requests | 1 minute | Redis |
| All other | 200 requests | 1 minute | Redis |

### 6.3 Data Validation (Zod)

```typescript
// src/validators/session.validator.ts
import { z } from 'zod';

export const SessionCreateSchema = z.object({
  deviceId: z.string().min(1).max(100),
  startedAt: z.string().datetime(),
  endedAt: z.string().datetime().optional(),
  exerciseType: z.enum(['squat', 'pushup', 'jumping_jack', 'freeform']),
  totalReps: z.number().int().min(0).max(10000),
  avgFormScore: z.number().min(0).max(100).optional(),
  maxRom: z.number().min(0).max(180).optional(),
  asymmetryFlag: z.boolean().default(false),
  injuryRiskCount: z.number().int().min(0).default(0),
  clientCreatedAt: z.string().datetime(),
});

export type SessionCreateInput = z.infer<typeof SessionCreateSchema>;
```

### 6.4 Security Headers (Helmet)

```javascript
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      connectSrc: ["'self'", "https://api.poseweave.app"],
    },
  },
  hsts: { maxAge: 31536000, includeSubDomains: true, preload: true },
}));
```

---

## 7. Sync Strategy (Offline-First Architecture)

### 7.1 Sync Protocol

```
┌──────────────┐                    ┌──────────────┐
│  Mobile App   │                    │   Backend    │
│  (SQLite)     │                    │  (PostgreSQL)│
├──────────────┤                    ├──────────────┤
│ sync_status  │                    │ sync_status  │
│ • local      │                    │ • synced     │
│ • pending    │◄────── Push ──────►│ • conflict   │
│ • synced     │                    │              │
│ • error      │◄────── Pull ──────►│              │
└──────────────┘                    └──────────────┘
```

**Sync Rules:**
1. **App creates session** → `sync_status = 'local'` in SQLite.
2. **User opens app + has connectivity** → Background sync starts.
3. **Push phase:** Upload all `pending` sessions to `/v1/sync/sessions`.
4. **Pull phase:** Download server sessions `since lastSyncAt`.
5. **Conflict resolution:** Server wins for metadata, client wins for user-generated content (notes, tags).
6. **Retry:** Exponential backoff (1s, 2s, 4s, 8s, max 1 hour) for failed syncs.

### 7.2 SQLite Schema (Client Side)

```sql
-- Flutter sqflite schema
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,  -- Client-generated UUID
  server_id TEXT,        -- Null until synced
  user_id TEXT,
  device_id TEXT,

  started_at INTEGER,    -- Unix timestamp (milliseconds)
  ended_at INTEGER,
  exercise_type TEXT,
  total_reps INTEGER,
  avg_form_score REAL,
  max_rom REAL,
  asymmetry_flag INTEGER,  -- 0 or 1
  injury_risk_count INTEGER,

  -- Sync metadata
  sync_status TEXT DEFAULT 'local',  -- 'local', 'pending', 'synced', 'error'
  sync_attempts INTEGER DEFAULT 0,
  last_sync_error TEXT,
  last_sync_at INTEGER,
  client_created_at INTEGER,
  client_updated_at INTEGER
);

CREATE INDEX idx_sessions_sync ON sessions(sync_status, client_created_at);
```

### 7.3 Delta Sync Logic

```typescript
// Server: src/services/sync.service.ts
export class SyncService {
  async syncSessions(userId: string, deviceId: string, payload: SyncPayload) {
    const results = [];

    for (const clientSession of payload.sessions) {
      // Check for existing session by composite key
      const existing = await prisma.session.findFirst({
        where: {
          userId,
          deviceId,
          clientCreatedAt: new Date(clientSession.clientCreatedAt),
        },
      });

      if (!existing) {
        // Insert new
        const created = await prisma.session.create({
          data: { ...clientSession, userId, deviceId, syncStatus: 'synced' }
        });
        results.push({ clientId: clientSession.clientId, serverId: created.id, status: 'synced' });
      } else if (clientSession.clientUpdatedAt > existing.clientUpdatedAt) {
        // Client has newer data — update
        await prisma.session.update({
          where: { id: existing.id },
          data: { ...clientSession, syncStatus: 'synced' }
        });
        results.push({ clientId: clientSession.clientId, serverId: existing.id, status: 'updated' });
      } else {
        // Server wins — mark as conflict for client resolution
        results.push({ 
          clientId: clientSession.clientId, 
          serverId: existing.id, 
          status: 'conflict',
          serverData: existing 
        });
      }
    }

    return results;
  }
}
```

---

## 8. Real-Time Capabilities (Phase 2)

### 8.1 Live Pose Streaming (WebSocket)

**Use Case:** Remote physiotherapist watches patient's form in real-time.

**Protocol:**
```
WS /v1/ws/live-pose?token=<jwt>&sessionId=<id>

Client → Server (30 FPS throttled):
{
  "type": "pose_frame",
  "timestamp": 1234567890,
  "landmarks": [ /* 33 points */ ],
  "formScore": 78.5
}

Server → Client (ack + feedback):
{
  "type": "feedback",
  "formScore": 78.5,
  "alert": "knee_valgus",
  "message": "Knee collapsing inward — push out!"
}
```

**Infrastructure:**
- **Free tier limitation:** Render free tier sleeps after 15 min idle. WebSocket requires always-on.
- **Alternative:** Server-Sent Events (SSE) over HTTP/2 for one-way streaming (therapist watches patient).
- **Alternative:** Pusher.com free tier (200k messages/day) for pub/sub.

**Recommendation:** Skip WebSocket in MVP. Use SSE or polling for Phase 2.

---

## 9. Admin Dashboard API

### 9.1 Endpoints (Protected by Admin Role)

#### GET `/v1/admin/users`
```json
{
  "success": true,
  "data": {
    "totalUsers": 1247,
    "activeToday": 89,
    "activeThisWeek": 456,
    "newThisWeek": 34,
    "premiumUsers": 12
  }
}
```

#### GET `/v1/admin/health`
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "database": "connected",
    "redis": "connected",
    "storage": "connected",
    "uptime": "3d 14h 22m",
    "memoryUsage": "142MB / 512MB",
    "lastError": null
  }
}
```

#### GET `/v1/admin/analytics/aggregated`
```json
{
  "success": true,
  "data": {
    "totalSessions": 45231,
    "totalReps": 1247000,
    "avgSessionDuration": 847,  // seconds
    "topExercises": [
      { "exercise": "squat", "percentage": 45 },
      { "exercise": "pushup", "percentage": 32 }
    ],
    "avgFormScoreDistribution": {
      "excellent": 12,  // >90
      "good": 45,       // 70-90
      "fair": 30,       // 50-70
      "poor": 13        // <50
    }
  }
}
```

---

## 10. Infrastructure & Deployment

### 10.1 Render.com Free Tier Configuration

```yaml
# render.yaml
services:
  - type: web
    name: poseweave-api
    runtime: node
    plan: free
    buildCommand: npm install && npx prisma migrate deploy && npm run build
    startCommand: npm start
    envVars:
      - key: NODE_ENV
        value: production
      - key: DATABASE_URL
        fromDatabase:
          name: poseweave-db
          property: connectionString
      - key: REDIS_URL
        fromService:
          type: redis
          name: poseweave-cache
          property: connectionString
      - key: JWT_SECRET
        generateValue: true
      - key: JWT_REFRESH_SECRET
        generateValue: true

databases:
  - name: poseweave-db
    plan: free
    databaseName: poseweave
    user: poseweave

redis:
  - name: poseweave-cache
    plan: free
    maxmemoryPolicy: allkeys-lru
```

### 10.2 Environment Variables

```bash
# .env.production
NODE_ENV=production
PORT=3000

# Database
DATABASE_URL="postgresql://poseweave:password@db.render.com:5432/poseweave?schema=public"

# Redis
REDIS_URL="redis://default:password@cache.upstash.io:6379"

# JWT
JWT_SECRET="super_secret_random_string_min_32_chars"
JWT_REFRESH_SECRET="another_super_secret_random_string"
JWT_ACCESS_EXPIRY=900        # 15 minutes
JWT_REFRESH_EXPIRY=604800    # 7 days

# Storage (Supabase)
SUPABASE_URL="https://project_id.supabase.co"
SUPABASE_KEY="service_role_key"
STORAGE_BUCKET="poseweave-exports"

# App
API_VERSION=v1
CORS_ORIGIN="https://poseweave.app,https://admin.poseweave.app"
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX=200
```

### 10.3 Health Check Endpoint

```typescript
// GET /v1/health
app.get('/v1/health', async (req, res) => {
  const checks = {
    database: await prisma.$queryRaw`SELECT 1`.then(() => 'ok').catch(() => 'error'),
    redis: await redis.ping().then(() => 'ok').catch(() => 'error'),
    storage: await supabase.storage.listBuckets().then(() => 'ok').catch(() => 'error'),
  };

  const status = Object.values(checks).every(c => c === 'ok') ? 200 : 503;

  res.status(status).json({
    success: status === 200,
    data: {
      status: status === 200 ? 'healthy' : 'degraded',
      checks,
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version,
    }
  });
});
```

---

## 11. Cost Analysis (100% Free Tier)

| Service | Provider | Free Tier Limits | Monthly Cost |
|---------|----------|------------------|--------------|
| API Hosting | Render | 512MB RAM, 0.1 CPU, sleeps after 15min idle | $0 |
| Database | Neon | 500MB storage, 10 connections, sleeps after idle | $0 |
| Cache | Upstash | 30MB, 10k commands/day, 1M request/month | $0 |
| File Storage | Supabase | 1GB storage, 2GB bandwidth, 50MB file limit | $0 |
| Monitoring | UptimeRobot | 50 monitors, 5-min intervals | $0 |
| Log Aggregation | Logtail | 1GB/month ingestion | $0 |
| **TOTAL** | | | **$0/month** |

### 11.1 Free Tier Limitations & Mitigations

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| Render sleeps after 15 min idle | Cold start: 2-3s delay on first request | Use UptimeRobot ping every 10 min to keep warm (within ToS) |
| Neon sleeps after inactivity | First query: 1-2s wake-up | Connection pooling via Prisma Accelerate (free tier) |
| Upstash 10k commands/day | Rate limiting + session cache | Aggressive TTL (1 hour), compress Redis values |
| Supabase 1GB storage | Video exports fill up fast | 30-day auto-cleanup cron, compress JSON with gzip |
| Render 512MB RAM | Node.js + Prisma + Express | No heavy processing in main thread, use setImmediate for batch ops |

### 11.2 When to Upgrade (Growth Triggers)

| Metric | Free Tier Limit | Upgrade Trigger | Cost After |
|--------|-----------------|-----------------|------------|
| Active users | ~500 (Render sleep issues) | 200 DAU | $7/month Render Starter |
| Database size | 500MB | 400MB used | $15/month Neon Pro |
| Storage | 1GB | 800MB used | $5/month Supabase Pro |
| Redis commands | 10k/day | 8k/day average | $10/month Upstash Pay-as-you-go |

---

## 12. Testing Strategy

### 12.1 Unit Tests (Jest)

```typescript
// tests/services/sync.service.test.ts
describe('SyncService', () => {
  describe('syncSessions', () => {
    it('should create new session when no conflict exists', async () => {
      // Arrange
      const payload = { sessions: [generateSession()] };

      // Act
      const result = await syncService.syncSessions(userId, deviceId, payload);

      // Assert
      expect(result[0].status).toBe('synced');
      expect(result[0].serverId).toBeDefined();
    });

    it('should update existing session when client data is newer', async () => {
      // Arrange: seed older session
      const existing = await prisma.session.create({ data: oldSession });
      const payload = { sessions: [{ ...oldSession, clientUpdatedAt: new Date() }] };

      // Act
      const result = await syncService.syncSessions(userId, deviceId, payload);

      // Assert
      expect(result[0].status).toBe('updated');
    });

    it('should return conflict when server data is newer', async () => {
      // Arrange: seed newer session
      const existing = await prisma.session.create({ data: newSession });
      const payload = { sessions: [oldSession] };

      // Act
      const result = await syncService.syncSessions(userId, deviceId, payload);

      // Assert
      expect(result[0].status).toBe('conflict');
      expect(result[0].serverData).toBeDefined();
    });
  });
});
```

### 12.2 Integration Tests (Supertest)

```typescript
// tests/integration/auth.test.ts
describe('POST /v1/auth/register', () => {
  it('should create user and return tokens', async () => {
    const res = await request(app)
      .post('/v1/auth/register')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123!',
        displayName: 'Tester',
      });

    expect(res.status).toBe(201);
    expect(res.body.data.tokens.accessToken).toBeDefined();
    expect(res.body.data.user.email).toBe('test@example.com');
  });

  it('should reject weak passwords', async () => {
    const res = await request(app)
      .post('/v1/auth/register')
      .send({ email: 'test@example.com', password: '123' });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });
});
```

### 12.3 Load Testing (Artillery.io)

```yaml
# tests/load/sync.yml
config:
  target: 'http://localhost:3000'
  phases:
    - duration: 60
      arrivalRate: 10  # 10 users/sec = 600 requests/min
scenarios:
  - flow:
      - post:
          url: '/v1/sync/sessions'
          headers:
            Authorization: "Bearer {{ token }}"
          json:
            deviceId: "load_test_device"
            sessions:
              - clientId: "session_{{ $randomInt }}"
                exerciseType: "squat"
                totalReps: 50
                clientCreatedAt: "2026-05-23T10:00:00Z"
```

---

## 13. Implementation Roadmap

### Phase 1: Foundation (Days 1-3)

| Day | Task | Deliverable | Validation |
|-----|------|-------------|------------|
| 1 | Project setup, Prisma init, PostgreSQL schema | `schema.prisma`, migration files | `npx prisma migrate dev` succeeds |
| 2 | Auth service (register, login, JWT) | `auth.service.ts`, `auth.controller.ts` | Postman collection tests pass |
| 3 | Session CRUD + sync endpoints | `session.controller.ts`, `sync.service.ts` | Bulk upload 100 sessions via script |

### Phase 2: Core Features (Days 4-6)

| Day | Task | Deliverable | Validation |
|-----|------|-------------|------------|
| 4 | Analytics aggregation queries | `analytics.service.ts`, materialized views | Dashboard returns <500ms |
| 5 | Leaderboard + challenges | `leaderboard.service.ts`, `challenge.controller.ts` | 50 test users, ranks correctly |
| 6 | Reference poses API + storage | `reference.controller.ts`, Supabase integration | Image upload/download works |

### Phase 3: Polish & Deploy (Days 7-8)

| Day | Task | Deliverable | Validation |
|-----|------|-------------|------------|
| 7 | Rate limiting, security headers, validation | Middleware stack | Penetration test (basic) |
| 8 | Deploy to Render, configure CI/CD | Live API at `api.poseweave.app` | Health check 200 OK |

### Phase 4: Flutter Integration (Days 9-10)

| Day | Task | Deliverable | Validation |
|-----|------|-------------|------------|
| 9 | Flutter sync client (SQLite ↔ API) | `sync_repository.dart`, background sync | 100 sessions sync in <30s |
| 10 | End-to-end testing | Full app + backend integration | Register → workout → sync → view analytics |

---

## 14. API Response Standard

All responses follow this envelope:

```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;       // "VALIDATION_ERROR", "AUTH_EXPIRED", "RATE_LIMITED"
    message: string;    // Human-readable
    details?: unknown;  // Zod validation errors, etc.
  };
  meta?: {
    timestamp: string;
    requestId: string;  // UUID for tracing
    pagination?: {
      total: number;
      limit: number;
      offset: number;
      hasMore: boolean;
    }
  };
}
```

**HTTP Status Codes:**
| Code | Usage |
|------|-------|
| 200 | Success (GET, PUT) |
| 201 | Created (POST) |
| 204 | No Content (DELETE, logout) |
| 400 | Validation Error |
| 401 | Unauthorized (missing/invalid token) |
| 403 | Forbidden (insufficient permissions) |
| 409 | Conflict (sync conflict) |
| 429 | Rate Limited |
| 500 | Internal Server Error |

---

## 15. Error Codes Reference

| Code | HTTP | Scenario | Client Action |
|------|------|----------|---------------|
| `AUTH_EXPIRED` | 401 | Access token expired | Refresh token automatically |
| `AUTH_INVALID` | 401 | Token malformed | Redirect to login |
| `VALIDATION_ERROR` | 400 | Zod schema failure | Display field errors |
| `SYNC_CONFLICT` | 409 | Server has newer data | Show conflict resolution UI |
| `RATE_LIMITED` | 429 | Too many requests | Exponential backoff retry |
| `DEVICE_NOT_FOUND` | 404 | Device ID not recognized | Re-register device |
| `SESSION_TOO_LARGE` | 413 | Frame data > 10MB | Compress or split upload |

---

## 16. Database Migration Strategy

```bash
# Development
npx prisma migrate dev --name add_challenge_grade

# Production (Render deploy hook)
npx prisma migrate deploy

# Generate client after schema change
npx prisma generate

# Seed data for testing
npx prisma db seed
```

**Migration Rules:**
1. Never delete columns in production — deprecate and nullify.
2. Always provide default values for new non-null columns.
3. Backfill data in separate migration before adding constraints.
4. Test migrations against production-like data volume locally.

---

*End of Backend PRD — Architecture-ready for implementation.*
