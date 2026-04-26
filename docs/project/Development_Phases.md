# Phase-wise Technical Documentation - SolventZ Solar Solutions

## Phase 1: Foundation & Project Setup
- **Core Activities**: Repository initialization, directory structuring (Monorepo-style: `mobile-app/` and `admin-web/`), and dependency management.
- **Key Outcomes**:
    - Project structure definition.
    - Integration of basic TypeScript and ESLint configurations.
    - Setup of initial Supabase project and configuration.

## Phase 2: Authentication & Database Infrastructure
- **Core Activities**: Implementing the security layer for the entire platform.
- **Key Outcomes**:
    - **Database**: Defined 7 core tables and associated PostgreSQL enums for status and categories.
    - **Supabase Auth**: Integrated into both apps.
        - Mobile: OTP login with Redux-managed auth state and AsyncStorage persistence.
        - Admin: Email/Password login via `@supabase/ssr` with Next.js middleware protection.
    - **Database Security**: Implemented Row Level Security (RLS) with specialized functions (`is_staff()`, `is_manager()`).

## Phase 3: Product Catalog & Media Management
- **Core Activities**: Building the discovery experience for customers and management tools for staff.
- **Key Outcomes**:
    - **Mobile Product Discovery**: Search, category filters, and detailed product breakdown with specification tables and horizontally scrolling image carousels.
    - **Admin Media Pipeline**: Specialized Server Actions for product CRUD and direct-to-Supabase Storage image uploads for high-performance media serving.

## Phase 4: Cart, Checkout, and Orders
- **Core Activities**: Finalizing the transactional system of the platform.
- **Key Outcomes**:
    - **State Management**: Implemented a performant, persistent cart store using **Zustand** on the mobile app.
    - **Order Service**: Developed a comprehensive order processing engine.
        - Mobile order placement with delivery address and payment method selection.
        - Order tracking with visual status timelines and deep-dive detail views.
        - Admin-side order management with real-time status and payment updates.

## Phase 5: Surveys, Support, and Admin Insights
- **Core Activities**: Adding the "service" layer and analytical capabilities.
- **Key Outcomes**:
    - **Survey Request System**: Developed a multi-step form (Personal, Property, Scheduling) for site survey requests.
    - **Support Ticketing**: Built a category-based support system for mobile users and a shared inbox for staff.
    - **Helpline & FAQ**: Integrated communication channels (Phone, WhatsApp, Email) and dynamic FAQ accordion.
    - **Admin Dashboard**: Developed a real-time metrics overview capturing revenue, order volume, system health (low stock), and service requests.
