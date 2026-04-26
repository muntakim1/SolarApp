# Master Test Plan (MTP) - SolventZ Solar Solutions

## 1. Introduction
The purpose of this Master Test Plan (MTP) is to provide a comprehensive roadmap for verifying and validating the SolventZ Solar Solutions platform. This document serves as the guide for QA testers to ensure all features are stable, secure, and user-friendly.

### 1.1 Scope of Testing
The testing effort covers:
- **Client 1**: React Native / Expo Mobile Application (iOS and Android).
- **Client 2**: Next.js Admin Web Panel (Desktop browsers).
- **Backend**: Supabase (Database, Auth, Storage, RLS).

### 1.2 Testing Objectives
- Validate that all functional requirements are met.
- Ensure the security and data isolation model (RLS) is strictly enforced.
- Verify the cross-platform consistency of the UI and UX.
- Confirm that the integration between clients and the BaaS is seamless.

---

## 2. Test Environment & Tools
- **Environment**: Local Development, Staging, and Production.
- **Tools**: Expo Go, React Native Debugger, Chrome DevTools, Supabase CLI, Postman (API testing).
- **Infrastructure**: Supabase (PostgreSQL, GoTrue, PostgREST).

---

## 3. Test Suites and Execution Report

### Suite A: Authentication and Security
Goal: Ensure secure access control and data privacy.

| Test ID | Scenario | Pre-conditions | Step-by-Step | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| AUTH-001 | Mobile Login | App not in session. | 1. Enter email/phone.<br>2. Submit OTP.<br>3. Verify login. | User successfully logs in and is redirected to App Stack. | Successful Login. | ✅ Pass |
| AUTH-002 | Admin Login | Admin page protected. | 1. Enter email/pass.<br>2. Click Login. | Admin enters dashboard; middleware allows access. | Logged in. | ✅ Pass |
| AUTH-003 | Unauthorized Access | Logged in as User B. | 1. Attempt to fetch Order ID from User A. | Supabase RLS returns 0 results or error. | Data not found. | ✅ Pass |

### Suite B: Product Catalog and Experience
Goal: Guarantee a premium discovery and search experience.

| Test ID | Scenario | Pre-conditions | Step-by-Step | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| CAT-001 | Catalog Loading | Products exist in DB. | 1. Open Catalog.<br>2. Scroll list. | Products display with high-res images and brands. | Products render. | ✅ Pass |
| CAT-002 | Search Logic | Products exist. | 1. Enter search term (e.g., 'Panel'). | Results only show items matching 'Panel'. | Results filter. | ✅ Pass |
| CAT-003 | Stock Badges | Item count is zero. | 1. View product details. | "Out of Stock" badge is visible; CTA is disabled. | Badge shown. | ✅ Pass |

### Suite C: Cart and Transactional Integrity
Goal: Ensure zero-error in ordering and checkout.

| Test ID | Scenario | Pre-conditions | Step-by-Step | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| TRAN-001 | Persistent Cart | Items added. | 1. Close app.<br>2. Re-open app. | Items remain in cart (AsyncStorage/State). | Cart persists. | ✅ Pass |
| TRAN-002 | Checkout Process | Cart has items. | 1. Enter address.<br>2. Place order. | Order created in 'pending' status; success screen shown. | Order successful. | ✅ Pass |
| TRAN-003 | Order Tracking | Order exists. | 1. Open Orders tab.<br>2. View detail. | Status timeline reflects the database state. | Timeline match. | ✅ Pass |

### Suite D: Service Requests (Surveys and Support)
Goal: Verify seamless communication between customer and company.

| Test ID | Scenario | Pre-conditions | Step-by-Step | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| SERV-001 | Survey Submit | User logged in. | 1. Fill 3-step form.<br>2. Click Submit. | Survey record created in DB; alert confirmation shown. | Survey recorded. | ✅ Pass |
| SERV-002 | Ticket Creation | User profile exists. | 1. Select category.<br>2. Enter desc.<br>3. Submit. | Ticket record created; visible in Admin panel. | Ticket sent. | ✅ Pass |
| SERV-003 | Helpline Usage | Device has a dialer. | 1. Click "Call Us". | Device dialer opens with correctly formatted number. | Dialer opened. | ✅ Pass |

### Suite E: Admin Operations
Goal: Empower staff with real-time management controls.

| Test ID | Scenario | Pre-conditions | Step-by-Step | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| ADM-001 | Product Creation | Admin has manager role. | 1. Upload image.<br>2. Save details. | Product appears in mobile app instantly. | Product live. | ✅ Pass |
| ADM-002 | Status Sync | Order is 'pending'. | 1. Update to 'shipped'. | Mobile order view updates to 'shipped'. | Status synced. | ✅ Pass |
| ADM-003 | Dashboard Real-time | Orders made recently. | 1. View metrics. | Revenue and order volume reflect recent activity. | Metrics updated. | ✅ Pass |

---

## 4. Defect Reporting Procedure
When a test fails, the QA tester should follow this reporting template:

- **Defect ID**: BUG-XXXX
- **Component**: [Mobile/Admin/Backend]
- **Severity**: [High/Medium/Low]
- **Summary**: Brief description of the issue.
- **Steps to Reproduce**: Detailed numbered list.
- **Expected Result**: What should have happened.
- **Actual Result**: What really happened.
- **Log / Screenshot**: Attachment or console dump.

---

## 5. Summary and Final Verdict
The SolventZ platform undergoes rigorous validation across every feature release. As of this documentation, all core features mentioned above are functional and meet the desired performance and security thresholds.
