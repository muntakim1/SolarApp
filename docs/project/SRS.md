# Software Requirement Specification (SRS) - SolventZ Solar Solutions

## 1. Introduction

### 1.1 Purpose
The purpose of this document is to provide a detailed description of the SolventZ Solar Solutions Platform. It will outline the software's purpose, scope, functional and non-functional requirements.

### 1.2 Project Scope
SolventZ is a comprehensive digital platform designed to streamline solar energy adoption. The system provides:
- A customer-facing mobile application for product discovery, order management, and service requests.
- An admin web panel for staff to manage product catalogs, orders, surveys, and support tickets.
- A centralized backend for data persistence and authentication.

## 2. Overall Description

### 2.1 User Classes and Characteristics
- **Customers**: Primary users of the mobile app. They can browse products, place orders, and request site surveys.
- **Staff/Managers**: Users of the admin web panel. They manage the catalog, process orders, and handle customer support.

### 2.2 System Features

#### 2.2.1 Product Catalog & Discovery
- High-quality presentation of solar products (Panels, Inverters, Batteries).
- Detailed specifications, brand info, and real-time stock status.
- Search and multi-category filtering for easy discovery.

#### 2.2.2 Shopping Cart & Order Management
- Seamless checkout process with address and payment method selection.
- Order tracking with visual timelines and status updates.
- Centralized order processing for administrators.

#### 2.2.3 Site Survey & Project Sales
- Digital multi-step survey request form for potential solar installations.
- Scheduling and tracking of site visits for project quotation.

#### 2.2.4 Customer Support & Helpline
- Ticket-based support system for resolving customer issues.
- Quick-access helpline via Phone, WhatsApp, and Email.
- Comprehensive FAQ accordion.

## 3. Functional Requirements

| ID | Requirement | Description |
|---|---|---|
| FR-01 | User Authentication | Secure login via OTP (Mobile) or Email/Password (Admin). |
| FR-02 | Profile Management | Initial profile setup and account management for customers. |
| FR-03 | Product Navigation | Browse, search, and filter the solar product catalog. |
| FR-04 | Cart Operations | Add products, adjust quantities, and manage a persistent cart. |
| FR-05 | Checkout Flow | Submit delivery details and select a payment method. |
| FR-06 | Order Tracking | View list of orders and detailed tracking information. |
| FR-07 | Survey Requests | Submit property and personal details for an installation quote. |
| FR-08 | Support Tickets | Create and track issues through a category-based ticket system. |
| FR-09 | Admin Dashboard | Real-time overview of revenue, orders, and system health. |
| FR-10 | Catalog Management | Managed CRUD operations for products and their associated images. |

## 4. Non-Functional Requirements

### 4.1 Security
- **Data Privacy**: Implementation of Supabase Row Level Security (RLS) ensuring users only see their own data.
- **Role-Based Access**: Restricted admin routes (Staff vs. Manager privileges).
- **Communication Security**: All data transferred over HTTPS.

### 4.2 Performance
- **Responsiveness**: Minimizing load times for both mobile and web interfaces.
- **Concurrency**: Supporting multiple concurrent users for ordering and support services.

### 4.3 Availability
- High availability of catalog and ordering services through Supabase infrastructure.

## 5. System Requirements

### 5.1 External Interface Requirements
- **User Interfaces**: Modern, premium UI for both Expo Mobile (iOS/Android) and Next.js Web Panel.
- **Software Interfaces**: Supabase (Backend-as-a-Service), Expo Go (Mobile prototyping).

### 5.2 Operating Environment
- **Mobile**: Target platforms are iOS 14.0+ and Android 8.0+.
- **Web**: Target browsers are Chrome, Safari, Firefox, and Edge.
