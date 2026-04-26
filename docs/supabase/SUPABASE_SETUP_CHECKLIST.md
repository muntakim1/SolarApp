# ✅ SolventZ Complete Supabase Setup Checklist

Use this checklist to verify that the Supabase setup is 100% complete and functional.

---

## 1️⃣ DATABASE TABLES

- [ ] **users** table created
  - [ ] `id` (UUID PK)
  - [ ] `full_name` (VARCHAR)
  - [ ] `email` (VARCHAR UNIQUE)
  - [ ] `phone` (VARCHAR)
  - [ ] `role` (role enum: customer, admin, support_agent, super_admin)
  - [ ] `is_active` (BOOLEAN)
  - [ ] `created_at`, `updated_at` (TIMESTAMPTZ)

- [ ] **categories** table created
  - [ ] `id` (UUID PK)
  - [ ] `name` (VARCHAR UNIQUE)
  - [ ] `slug` (VARCHAR UNIQUE)
  - [ ] `icon_url` (TEXT)
  - [ ] `is_active` (BOOLEAN)

- [ ] **products** table created
  - [ ] `id` (UUID PK)
  - [ ] `category_id` (FK to categories)
  - [ ] `sku` (VARCHAR UNIQUE)
  - [ ] `name`, `brand`, `description`
  - [ ] `specifications` (JSONB)
  - [ ] `price` (NUMERIC)
  - [ ] `stock_quantity` (INTEGER)
  - [ ] `images` (TEXT[])
  - [ ] `is_active`, `is_deleted` (BOOLEAN)
  - [ ] `created_at` (TIMESTAMPTZ)

- [ ] **orders** table created
  - [ ] `id` (UUID PK)
  - [ ] `order_number` (VARCHAR UNIQUE)
  - [ ] `user_id` (FK to users)
  - [ ] `status` (order_status enum)
  - [ ] `payment_status` (payment_status enum)
  - [ ] `delivery_address` (JSONB)
  - [ ] `subtotal`, `delivery_fee`, `grand_total` (NUMERIC)
  - [ ] `admin_notes` (TEXT)
  - [ ] `created_at`, `updated_at` (TIMESTAMPTZ)

- [ ] **order_items** table created
  - [ ] `id` (UUID PK)
  - [ ] `order_id` (FK to orders)
  - [ ] `product_id` (FK to products)
  - [ ] `product_snapshot` (JSONB)
  - [ ] `quantity` (INTEGER)
  - [ ] `unit_price` (NUMERIC)
  - [ ] `line_total` (NUMERIC - generated)

- [ ] **surveys** table created
  - [ ] `id` (UUID PK)
  - [ ] `user_id` (FK to users)
  - [ ] `full_name`, `phone`, `address`
  - [ ] `property_type` (property_type enum)
  - [ ] `monthly_bill` (NUMERIC)
  - [ ] `preferred_date` (DATE)
  - [ ] `status` (survey_status enum)
  - [ ] `scheduled_at` (TIMESTAMPTZ)
  - [ ] `quote_amount`, `quote_details` (JSONB)
  - [ ] `created_at` (TIMESTAMPTZ)

- [ ] **support_tickets** table created
  - [ ] `id` (UUID PK)
  - [ ] `user_id` (FK to users)
  - [ ] `order_id` (FK to orders)
  - [ ] `assigned_to` (FK to users)
  - [ ] `category` (ticket_category enum)
  - [ ] `subject`, `description`
  - [ ] `attachments` (TEXT[])
  - [ ] `status` (ticket_status enum)
  - [ ] `resolved_at` (TIMESTAMPTZ)
  - [ ] `created_at` (TIMESTAMPTZ)

---

## 2️⃣ REQUIRED ENUMS

- [ ] **user_role** enum (customer, admin, support_agent, super_admin)
- [ ] **order_status** enum (pending, processing, packed, shipped, delivered, cancelled)
- [ ] **payment_method** enum (bank_transfer, cod, online_payment)
- [ ] **payment_status** enum (unpaid, paid, refunded)
- [ ] **property_type** enum (residential, commercial, industrial, agricultural)
- [ ] **survey_status** enum (new, scheduled, completed, quote_sent, accepted, declined)
- [ ] **ticket_category** enum (product_defect, installation_issue, billing, general)
- [ ] **ticket_status** enum (open, in_review, awaiting_customer, resolved, closed)

---

## 3️⃣ INDEXES CREATED

- [ ] `idx_products_category_brand` on products(category_id, brand, is_active, is_deleted)
- [ ] `idx_orders_user_status` on orders(user_id, status, created_at)
- [ ] `idx_order_items_order_product` on order_items(order_id, product_id)
- [ ] `idx_surveys_user_status` on surveys(user_id, status, created_at)
- [ ] `idx_support_tickets_user_status` on support_tickets(user_id, status, assigned_to, created_at)

---

## 4️⃣ ROW-LEVEL SECURITY (RLS)

- [ ] RLS enabled on **users** table
- [ ] RLS enabled on **categories** table
- [ ] RLS enabled on **products** table
- [ ] RLS enabled on **orders** table
- [ ] RLS enabled on **order_items** table
- [ ] RLS enabled on **surveys** table
- [ ] RLS enabled on **support_tickets** table

### Users Policies
- [ ] SELECT: Users can read own record
- [ ] UPDATE: Users can update own record
- [ ] SELECT: Staff can read all users

### Products Policies
- [ ] SELECT: Everyone can read active products
- [ ] ALL: Managers can manage products

### Orders Policies
- [ ] SELECT: Users can read own orders
- [ ] INSERT: Users can insert own orders
- [ ] ALL: Managers can manage all orders

### Surveys Policies
- [ ] SELECT: Users can read own surveys
- [ ] INSERT: Users can insert own surveys
- [ ] ALL: Managers can manage all surveys

### Support Tickets Policies
- [ ] SELECT: Users can read own tickets
- [ ] INSERT: Users can insert own tickets
- [ ] ALL: Staff can manage all tickets

---

## 5️⃣ STORAGE BUCKET

- [ ] Storage bucket **product-images** created
- [ ] Bucket set to **public**
- [ ] Policy: "Public Read Access" allows SELECT
- [ ] Policy: "Managers can insert" allows INSERT
- [ ] Policy: "Managers can update" allows UPDATE
- [ ] Policy: "Managers can delete" allows DELETE

---

## 6️⃣ SEED DATA

### Categories (4 total)
- [ ] "Solar Panels" with slug "solar-panels"
- [ ] "Inverters" with slug "inverters"
- [ ] "Batteries" with slug "batteries"
- [ ] "VED (Voltage Enhancement Devices)" with slug "ved"

### Products (8 total)

**Solar Panels:**
- [ ] Monocrystalline Solar Panel 550W (SKU: SP-550W-001, ₨75,000)
- [ ] Monocrystalline Solar Panel 600W (SKU: SP-600W-002, ₨85,000)

**Inverters:**
- [ ] Hybrid Solar Inverter 5KW (SKU: INV-5KW-001, ₨150,000)
- [ ] Hybrid Solar Inverter 8KW (SKU: INV-8KW-002, ₨220,000)

**Batteries:**
- [ ] Lithium Ion Battery 5kWh (SKU: BAT-5KWH-001, ₨250,000)
- [ ] Lithium Ion Battery 10kWh (SKU: BAT-10KWH-002, ₨480,000)

**VED:**
- [ ] Voltage Enhancement Device 10KVA (SKU: VED-10KVA-001, ₨35,000)
- [ ] Voltage Enhancement Device 20KVA (SKU: VED-20KVA-002, ₨65,000)

---

## 7️⃣ DATABASE FUNCTIONS

- [ ] **is_staff()** function created (checks if user has admin/super_admin/support_agent role)
- [ ] **is_manager()** function created (checks if user has admin/super_admin role)

---

## 8️⃣ ADMIN WEB APPLICATION

### Environment Setup
- [ ] `.env.local` file created with:
  - [ ] `NEXT_PUBLIC_SUPABASE_URL` set correctly
  - [ ] `NEXT_PUBLIC_SUPABASE_ANON_KEY` set correctly

### Pages Working
- [ ] `/dashboard` loads (Dashboard page)
- [ ] `/dashboard/products` loads with 8 products displayed
- [ ] `/dashboard/products/manage` loads (Add/Edit form)
- [ ] `/dashboard/orders` loads (empty initially)
- [ ] `/dashboard/orders/[id]` loads (after creating order)
- [ ] `/dashboard/surveys` loads (empty initially)
- [ ] `/dashboard/surveys/[id]` loads (after creating survey)
- [ ] `/dashboard/support` loads (empty initially)
- [ ] `/dashboard/support/[id]` loads (after creating ticket)

### API Endpoints Working
- [ ] `GET /api/products` returns 8 products
- [ ] `POST /api/products` can create new product (requires auth)
- [ ] `GET /api/products/[id]` returns single product
- [ ] `PATCH /api/products/[id]` can update product (requires auth)
- [ ] `DELETE /api/products/[id]` can soft-delete product (requires auth)
- [ ] `GET /api/orders` returns orders
- [ ] `GET /api/orders/[id]` returns order details
- [ ] `PATCH /api/orders/[id]` can update status (requires auth)
- [ ] `GET /api/surveys` returns surveys
- [ ] `GET /api/surveys/[id]` returns survey details
- [ ] `PATCH /api/surveys/[id]` can update survey (requires auth)
- [ ] `GET /api/support` returns tickets
- [ ] `GET /api/support/[id]` returns ticket details
- [ ] `PATCH /api/support/[id]` can update ticket (requires auth)
- [ ] `GET /api/dashboard/metrics` returns dashboard data

### Authentication
- [ ] Login page accessible
- [ ] Can create admin user in Supabase
- [ ] Can login with admin credentials
- [ ] Session persists after refresh
- [ ] Logout clears session

---

## 9️⃣ MOBILE APP

### Environment Setup
- [ ] `.env.local` file created with:
  - [ ] `EXPO_PUBLIC_SUPABASE_URL` set correctly
  - [ ] `EXPO_PUBLIC_SUPABASE_ANON_KEY` set correctly

### Screens Working
- [ ] Login/Auth screens functional
- [ ] Home screen shows featured products
- [ ] Catalog screen displays all products
- [ ] Product detail screen works
- [ ] Cart functionality works
- [ ] Checkout process works
- [ ] Orders screen shows user orders
- [ ] Orders detail screen works
- [ ] Profile screen displays user info
- [ ] Support/Helpline screen works

### Services Connected
- [ ] `productService` returns products from Supabase
- [ ] `orderService` returns user orders
- [ ] `surveyService` can submit survey requests
- [ ] `supportService` can submit support tickets
- [ ] User authentication working

---

## 🔟 TESTING CHECKLIST

### Admin Web Testing
- [ ] [ ] Create test admin user
- [ ] [ ] Login successfully
- [ ] [ ] View all 8 products on dashboard
- [ ] [ ] Create new product
- [ ] [ ] Edit existing product
- [ ] [ ] Delete product (soft delete)
- [ ] [ ] Search products by name
- [ ] [ ] Filter products by category
- [ ] [ ] Navigate to all pages without 404 errors
- [ ] [ ] Logout successfully

### Mobile App Testing
- [ ] [ ] Cannot access without auth
- [ ] [ ] Register new user
- [ ] [ ] Login successfully
- [ ] [ ] Browse products in catalog
- [ ] [ ] View product details
- [ ] [ ] Add product to cart
- [ ] [ ] Complete checkout
- [ ] [ ] View order history
- [ ] [ ] Submit support ticket
- [ ] [ ] Request survey

### Database Testing
- [ ] [ ] Insert test data into each table
- [ ] [ ] Verify RLS policies work (users see only their data)
- [ ] [ ] Verify staff can see all data
- [ ] [ ] Verify managers can manage all records
- [ ] [ ] Test search functionality
- [ ] [ ] Test pagination
- [ ] [ ] Test filtering

---

## 1️⃣1️⃣ DEPLOYMENT PREPARATION

### Before Going to Production
- [ ] Backup database
- [ ] Update API keys in environment
- [ ] Test all features on production data
- [ ] Set up monitoring/logging
- [ ] Configure CORS if needed
- [ ] Enable HTTP-only cookies
- [ ] Set strong security policies

### Deployment Checklist
- [ ] Admin web deployed to Vercel (or similar)
- [ ] Mobile app deployed to App Store/Play Store
- [ ] Database backups configured
- [ ] Email/SMS notifications set up
- [ ] Monitoring alerts configured
- [ ] Error tracking enabled (Sentry, etc.)

---

## 📞 VERIFICATION COMMANDS

Run these SQL commands in Supabase SQL Editor to verify setup:

```sql
-- Check all tables exist
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' ORDER BY table_name;

-- Check data in categories
SELECT COUNT(*) FROM public.categories;

-- Check seed products loaded
SELECT COUNT(*) FROM public.products;

-- Verify indexes
SELECT indexname FROM pg_indexes 
WHERE schemaname = 'public' ORDER BY indexname;

-- Check RLS is enabled
SELECT tablename FROM pg_tables 
WHERE schemaname = 'public' ORDER BY tablename;

-- Check storage bucket
SELECT name, id, public FROM storage.buckets;
```

---

## ✅ FINAL SIGN-OFF

When all items are checked:

- **Database:** ✅ Fully configured
- **Authentication:** ✅ Working
- **Admin Web:** ✅ 100% Functional
- **Mobile App:** ✅ 100% Functional
- **Security:** ✅ RLS policies enforced
- **Performance:** ✅ Indexes optimized

**Status: READY FOR PRODUCTION** ✅

---

## 📞 Need Help?

1. Check `SUPABASE_SETUP_GUIDE.md` for detailed instructions
2. Review `SUPABASE_QUICK_START.md` for quick setup
3. Visit [Supabase Docs](https://supabase.com/docs)
4. Check app-specific docs (Next.js, React Native)

