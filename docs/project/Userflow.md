# User Flows - SolventZ Solar Solutions

This document outlines the primary user journeys within the SolventZ Solar Solutions platform for both Customers (Mobile App) and Admin Staff (Web Panel).

## 1. Customer User Flow (Mobile Application)

The customer flow focuses on product discovery, seamless ordering, and requesting professional solar services.

### 1.1 Authentication & Profile Setup
```mermaid
graph TD
    A[Launch App] --> B{Is Logged In?}
    B -- No --> C[Landing Screen]
    C --> D[Enter Mobile Number]
    D --> E[Receive OTP]
    E --> F[Verify OTP]
    F --> G[Initial Profile Setup]
    G --> H[Home Dashboard]
    B -- Yes --> H
```

### 1.2 Product Discovery & Ordering
```mermaid
graph TD
    A[Home Dashboard] --> B[Browse Categories]
    B --> C[Product List]
    C --> D[Search/Filter]
    D --> C
    C --> E[Product Details]
    E --> F[Add to Cart]
    F --> G[View Cart]
    G --> H{Adjust Quantity?}
    H -- Yes --> G
    H -- No --> I[Checkout]
    I --> J[Select Address]
    J --> K[Select Payment Method]
    K --> L[Place Order]
    L --> M[Order Success Screen]
    M --> N[Order Tracking]
```

### 1.3 Site Survey & Support
```mermaid
graph TD
    A[Home Dashboard] --> B[Request Site Survey]
    B --> C[Multi-step Survey Form]
    C --> D[Submit Survey]
    D --> E[Survey Tracking]
    
    A --> F[Customer Support]
    F --> G[View FAQs]
    F --> H[Create Support Ticket]
    H --> I[Submit Category-based Ticket]
    I --> J[Track Ticket Status]
    F --> K[Quick Help: Phone/WhatsApp]
```

---

## 2. Admin User Flow (Web Panel)

The admin flow is designed for staff to manage operations efficiently from a centralized dashboard.

### 2.1 Staff Authentication & Dashboard
```mermaid
graph TD
    A[Access Admin URL] --> B{Authenticated?}
    B -- No --> C[Login Screen]
    C --> D[Enter Email/Password]
    D --> E[Dashboard Overview]
    B -- Yes --> E
```

### 2.2 Catalog & Order Management
```mermaid
graph TD
    A[Dashboard] --> B[Catalog Management]
    B --> C[Manage Categories]
    B --> D[Manage Products]
    D --> E[Add/Edit/Delete Product]
    E --> F[Upload Images to Storage]
    
    A --> G[Order Management]
    G --> H[View All Orders]
    H --> I[Order Details]
    I --> J[Update Order Status]
    J --> K[Real-time Notification to Customer]
```

### 2.3 Survey & Ticket Handling
```mermaid
graph TD
    A[Dashboard] --> B[Survey Requests]
    B --> C[View All Surveys]
    C --> D[Review Survey Details]
    D --> E[Schedule Site Visit / Update Status]
    
    A --> F[Support Tickets]
    F --> G[View Active Tickets]
    G --> H[Respond to Ticket]
    H --> I[Resolve/Close Ticket]
```
