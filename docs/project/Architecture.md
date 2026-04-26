# System Design and Architecture - SolventZ Solar Solutions

> [!TIP]
> For visual representations of user journeys, see the [User Flows](Userflow.md) document.

## 1. High-Level Architecture Overview
The SolventZ platform is built on a modern, scalable architecture utilizing a Backend-as-a-Service (BaaS) provider (Supabase) to handle data persistence, authentication, and file storage. The client-side is split into two specialized applications: a high-performance React Native mobile app and a feature-rich Next.js web application.

### 1.1 Diagram: System Components
- **Client Tier**: Expo/React Native (Mobile), Next.js (Web Admin).
- **Service Tier**: Supabase (Backend-as-a-Service).
- **Data Tier**: PostgreSQL (Database Service), S3-compatible Storage (Product Images).

## 2. Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Mobile App** | React Native, Expo, Redux Toolkit, Zustand, TypeScript | Cross-platform discovery and ordering experience. |
| **Admin Web** | Next.js 14 (App Router), TailwindCSS, Lucide-React, TypeScript | Responsive, modern management dashboard. |
| **Backend** | Supabase (PostgreSQL, GoTrue, PostgREST) | Centralized, secure API and real-time data engine. |
| **Storage** | Supabase Storage (S3-compatible) | Management and serving of product-related media. |
| **State Management** | Redux (Auth), Zustand (Cart) | Optimized global and local state tracking. |

## 3. Database Schema Design
The system uses a relational PostgreSQL schema with specific row-level security (RLS) policies.

### 3.1 Tables and Relations
- **`users`**: Extended user profiles linked to Supabase authentication (publicly visible by owners, modifiable by owners/staff).
- **`categories`**: Product classifications (managed by staff, viewed by everyone).
- **`products`**: Product details (managed by staff, viewed by everyone).
- **`orders`**: Customer purchase records (viewed by owners/staff, modifiable status by staff).
- **`order_items`**: Line items for orders, including snapshots of product data at the time of purchase.
- **`surveys`**: Site survey requests from customers (viewed by owners/staff, status managed by staff).
- **`support_tickets`**: Customer service tickets (managed by staff, viewed by owners).

### 3.2 Row Level Security (RLS) Model
We implement security at the database level using RLS:
- **`is_staff()`**: Returns true if the user has staff/manager privileges.
- **`is_manager()`**: Returns true if the user has higher administrative privileges (e.g., product management).
- **`auth.uid()`**: Ensures standard users can only access their own data.

## 4. Communication Flow

### 4.1 Client-to-Backend Flow
1. **Authentication**: Users log in via the client application (Mobile/Web).
2. **Session Persistence**: JWTs are stored in secure storage (AsyncStorage for Mobile, Cookies for Web).
3. **Data Request**: Clients interact with the Supabase API (PostgREST) via the Supabase client library.
4. **Authoritative Response**: Supabase enforces RLS and returns only the data the user is authorized to see.

### 4.2 Storage Flow
- **Upload**: Admin panel uploads images to the `product-images` bucket.
- **Access**: Clients fetch signed URLs or public URLs (based on policy) to render images in their respective UIs.

## 5. Security Model
- **Token-Based Auth**: Managed through Supabase Auth (GoTrue).
- **Secrets Management**: Environment variables handle API keys and sensitive URLs.
- **CORS Policies**: Restricted to authorized origins for web-based access.
- **Input Validation**: Strongly typed interfaces (TypeScript) and database constraints ensure data integrity.
