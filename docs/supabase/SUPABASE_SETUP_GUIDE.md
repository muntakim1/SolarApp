# SolventZ - Complete Supabase Setup Guide

Complete guide to set up all tables, policies, and configurations in Supabase to make the app 100% functional.

---

## ✅ What's Included

- ✅ **7 Database Tables** with all relationships
- ✅ **Row-Level Security (RLS)** policies for all tables  
- ✅ **Storage Bucket** for product images
- ✅ **Seed Data** with sample products, categories
- ✅ **Indexes** for performance optimization
- ✅ **Authentication Types** (customer, admin, support_agent, super_admin)

---

## 📋 Database Schema

### Tables Created:

1. **users** - User accounts with roles
2. **categories** - Product categories
3. **products** - Solar products catalog
4. **orders** - Customer orders
5. **order_items** - Order line items
6. **surveys** - Solar survey requests
7. **support_tickets** - Customer support tickets

---

## 🚀 Setup Options

### Option 1: Local Development with Supabase CLI (Recommended for Testing)

This allows you to develop and test locally before pushing to production.

#### Step 1: Install Supabase CLI
```bash
# On macOS
brew install supabase/tap/supabase

# Verify installation
supabase --version
```

#### Step 2: Start Local Supabase
```bash
cd /Users/muntakim/Developer/Hasib/SolarAPP/supabase

# Start the local Supabase instance
supabase start
```

You'll see output like:
```
Seeding data sql/seed.sql...
Started Supabase local development setup.

         API URL: http://127.0.0.1:54321
     GraphQL URL: http://127.0.0.1:54321/graphql/v1
          DB URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
      Studio URL: http://127.0.0.1:54323
    Inbucket URL: http://127.0.0.1:54324
```

#### Step 3: Update Environment Variables
In `admin-web/.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WfrbgaSRCFqr3z8QA7dUQeFPFo00xiJLlVaI
```

#### Step 4: Start Dev Server
```bash
cd admin-web
npm run dev
# Visit http://localhost:3000/dashboard
```

---

### Option 2: Production Deployment (Supabase Cloud)

Deploy to a live Supabase instance for production use.

#### Step 1: Create Supabase Project
1. Go to [https://app.supabase.com](https://app.supabase.com)
2. Click "New Project"
3. Fill in:
   - **Project Name:** SolventZ
   - **Password:** (save securely)
   - **Region:** Select closest to your users
4. Click "Create new project" and wait (~2 minutes)

#### Step 2: Get API Keys
Once project is created:
1. Go to **Settings → API**
2. Copy:
   - **Project URL** (appears as `https://xxxxx.supabase.co`)
   - **Anon Public Key** (appears in the table)

#### Step 3: Link Local Project to Remote
```bash
cd /Users/muntakim/Developer/Hasib/SolarAPP
supabase link --project-ref xxxxx  # Replace with your project ID from the URL
# You'll be prompted for your database password
```

#### Step 4: Push Migrations to Production
```bash
supabase db push
```

This will:
- Create all 7 tables
- Set up RLS policies
- Create indexes
- Set up storage bucket

#### Step 5: Seed Production Database (Optional)
The `seed.sql` file will be run automatically during `db push`, but you can also run it manually:
```bash
supabase db execute seed.sql --linked
```

#### Step 6: Update Environment Variables

**For Admin Web** (`admin-web/.env.local`):
```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

**For Mobile App** (`mobile-app/.env.local`):
```env
EXPO_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

---

## 🔐 Security Features Configured

### Row-Level Security (RLS)

All tables have RLS enabled with these policies:

**Users:**
- Users can see their own profile
- Staff can view all users
- Users can update their own profile

**Products:**
- Everyone can read active products
- Only managers can create/update/delete

**Orders:**
- Users can see their own orders
- Managers can manage all orders

**Surveys:**
- Users can see their own surveys
- Managers can manage all surveys

**Support Tickets:**
- Users can see their own tickets
- Support staff can manage all tickets

**Storage:**
- Public read access to product images
- Only managers can upload/modify images

---

## 📊 Database Structure

### Users Table
```sql
- id (UUID) - Primary Key
- full_name, email, phone
- role (customer, admin, support_agent, super_admin)
- is_active
- created_at, updated_at
```

### Products Table
```sql
- id (UUID) - Primary Key
- name, brand, sku
- price, stock_quantity
- specifications (JSONB)
- images TEXT[]
- category_id (FK to categories)
- is_active, is_deleted
- created_at
```

### Orders Table
```sql
- id (UUID) - Primary Key
- order_number (unique)
- user_id (FK)
- status (pending, processing, packed, shipped, delivered, cancelled)
- payment_status (unpaid, paid, refunded)
- delivery_address, admin_notes
- subtotal, delivery_fee, grand_total
- created_at, updated_at
```

### Surveys Table
```sql
- id (UUID) - Primary Key
- user_id (FK)
- full_name, phone, address
- property_type (residential, commercial, industrial)
- monthly_bill
- status (new, scheduled, completed, quote_sent, accepted, declined)
- quote_details (JSONB)
- created_at, scheduled_at
```

### Support Tickets Table
```sql
- id (UUID) - Primary Key
- user_id (FK)
- order_id (FK)
- category (product_defect, installation_issue, billing, general)
- status (open, in_review, awaiting_customer, resolved, closed)
- subject, description
- attachments TEXT[]
- created_at, resolved_at
```

---

## 🧪 Testing the Setup

### Create Test Admin User
1. Go to Supabase Studio (http://127.0.0.1:54323 locally)
2. Click **Authentication → Users**
3. Click **"Invite"** and add user with email, set password
4. On the **users** table in SQL Editor, run:
```sql
UPDATE public.users SET role = 'admin' 
WHERE email = 'admin@example.com';
```

### Test Login
1. Visit http://localhost:3000 (admin-web)
2. Click "Sign in"
3. Use the admin email and password
4. Should be redirected to /dashboard/products

### Test API Endpoints
Use curl to test endpoints:

```bash
# Get all products
curl http://localhost:3000/api/products?page=1&per_page=10

# Create a product (requires auth token)
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","brand":"Test","sku":"TEST001","price":10000,"stock":5}'

# Get surveys
curl http://localhost:3000/api/surveys

# Get orders
curl http://localhost:3000/api/orders
```

---

## 📱 Mobile App Setup

### For Local Development
In `mobile-app/.env.local`:
```env
EXPO_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WfrbgaSRCFqr3z8QA7dUQeFPFo00xiJLlVaI
```

### For Production
```env
EXPO_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

Start the app:
```bash
cd mobile-app
npm start
# Then press 'i' for iOS or 'a' for Android
```

---

## 🔄 Updating Database Schema

If you need to modify the schema:

1. **Create a new migration:**
```bash
supabase migration new add_new_column
```

2. **Edit the new file** in `supabase/migrations/`

3. **Push changes:**
```bash
supabase db push
```

---

## ❌ Troubleshooting

### Issue: "NEXT_PUBLIC_SUPABASE_URL is undefined"
**Solution:** Restart the dev server after adding .env.local
```bash
npm run dev
```

### Issue: "RLS policy violation"
**Solution:** Make sure the user has the correct role in `users` table
```sql
SELECT * FROM public.users WHERE email = 'your-email@example.com';
```

### Issue: "Tables not created"
**Solution:** Manually run the migration:
```bash
supabase db push --dry-run  # Check what will be pushed
supabase db push            # Actually push
```

### Issue: Local Supabase won't start
**Solution:**
```bash
# Stop any running instances
supabase stop

# Reset and start fresh
supabase start --force-docker
```

---

## 📈 Seed Data Included

The `seed.sql` automatically creates:

**Categories:**
- Solar Panels
- Inverters
- Batteries
- VED (Voltage Enhancement Devices)

**Products (8 total):**
- 2 Solar Panels (550W, 600W)
- 2 Inverters (5KW, 8KW)
- 2 Batteries (5kWh, 10kWh)
- 2 VED units (10KVA, 20KVA)

All with realistic pricing in Pakistani Rupees (₨)

---

## ✅ Checklist: Verify Everything Works

- [ ] Tables created (check in Supabase Studio)
- [ ] RLS policies enabled
- [ ] Seed data loaded (see products in UI)
- [ ] Auth working (can login)
- [ ] Can view products in admin dashboard
- [ ] Can view orders page
- [ ] Can view surveys page
- [ ] Can view support tickets page
- [ ] Mobile app connects to Supabase
- [ ] Product images displaying

---

## 🎯 Next Steps

1. **Add more seed data:** Edit `seed.sql` to add more products
2. **Test workflows:** Create orders, surveys, tickets
3. **Connect payment provider:** Integrate Stripe or Easypaisa
4. **Enable notifications:** Set up email/SMS sending
5. **Deploy frontend:** Host on Vercel (admin-web) and Expo / AWS (mobile)

---

## 📞 Support

For issues with Supabase, visit:
- [Supabase Docs](https://supabase.com/docs)
- [Supabase Community](https://discord.supabase.io)

For app-specific issues, check:
- [Next.js Docs](https://nextjs.org/docs)
- [React Native Docs](https://reactnative.dev)
