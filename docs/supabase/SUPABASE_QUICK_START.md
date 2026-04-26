# 🚀 SolventZ - Quick Start with Supabase

Complete guide to get the app running 100% functional with Supabase in minutes.

---

## 📋 Prerequisites

- Node.js 18.17+ installed ([Download](https://nodejs.org))
- Supabase CLI installed: `brew install supabase/tap/supabase`
- Git installed

---

## ⚡ Option 1: Local Development (Fastest - 5 minutes)

Perfect for testing and development without cloud costs.

### Step 1: Start Local Supabase

```bash
cd /Users/muntakim/Developer/Hasib/SolarAPP

# Start local Supabase instance (creates all tables automatically)
supabase start
```

**You should see:**
```
Seeding data sql/seed.sql...
Started Supabase local development setup.
         API URL: http://127.0.0.1:54321
           DB URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
      Studio URL: http://127.0.0.1:54323
```

### Step 2: Update Environment Variables

**Admin Web** (`admin-web/.env.local`):
```env
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WfrbgaSRCFqr3z8QA7dUQeFPFo00xiJLlVaI
```

**Mobile App** (`mobile-app/.env.local`):
```env
EXPO_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WfrbgaSRCFqr3z8QA7dUQeFPFo00xiJLlVaI
```

### Step 3: Start Admin Web

```bash
cd admin-web
npm install  # Only needed once
npm run dev
```

Visit: **http://localhost:3000/dashboard**

### Step 4: Create Admin User

1. Go to Supabase Studio: **http://127.0.0.1:54323**
2. Click **Authentication → Users → Invite** 
3. Add email (e.g., `admin@example.com`) and password
4. Set user role to admin:
```sql
-- Run this in SQL Editor (Supabase Studio)
UPDATE public.users SET role = 'admin' 
WHERE email = 'admin@example.com';
```

### Step 5: Login & Test

Back at http://localhost:3000:
- Click Login
- Enter admin email and password
- Explore Dashboard, Products, Orders, Surveys, Support

**✅ You're done! Local app is fully functional.**

---

## ☁️ Option 2: Production Deployment (Supabase Cloud)

Deploy to a live instance for production use.

### Step 1: Create Cloud Project

1. Visit [app.supabase.com](https://app.supabase.com)
2. Click **"New project"**
3. Fill in:
   - **Project name:** `SolventZ`
   - **Password:** (save securely)
   - **Region:** Select your region
4. Click **"Create new project"** and wait ~2 minutes

### Step 2: Link Your Project

In the project root:
```bash
# Get your Project ID from the URL (xxxxx.supabase.co)
supabase link --project-ref xxxxx

# When prompted, enter your database password
```

### Step 3: Push Database

```bash
# Push all migrations and seed data
supabase db push
```

This will automatically:
- Create all 7 tables
- Set up Row-Level Security policies
- Create database indexes
- Set up storage for images
- Load seed data (8 products, 4 categories)

### Step 4: Get API Keys

1. Go to **Settings → API** in Supabase Console
2. Copy your:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **Anon Public Key**

### Step 5: Update Environment Variables

**Admin Web** (`admin-web/.env.local`):
```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_xxxxx
```

**Mobile App** (`mobile-app/.env.local`):
```env
EXPO_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_xxxxx
```

### Step 6: Start Apps

```bash
# Admin Web
cd admin-web
npm run dev
# Visit http://localhost:3000

# OR Mobile App (in another terminal)
cd mobile-app
npm start
```

**✅ Production deployment complete!**

---

## 📊 Database Schema Overview

All these tables are automatically created:

| Table | Records | Purpose |
|-------|---------|---------|
| **users** | Accounts | User authentication & roles |
| **categories** | 4 | Product categories |
| **products** | 8 | Solar products catalog |
| **orders** | 0 | Customer orders |
| **order_items** | 0 | Order line items |
| **surveys** | 0 | Survey requests |
| **support_tickets** | 0 | Support tickets |

---

## ✅ Verify Everything Works

### Admin Dashboard
1. Login to http://localhost:3000
2. Check these pages load:
   - ✓ /dashboard (metrics & overview)
   - ✓ /dashboard/products (8 products showing)
   - ✓ /dashboard/orders (empty initially)
   - ✓ /dashboard/surveys (empty initially)
   - ✓ /dashboard/support (empty initially)

### API & Database
```bash
# Test if database is connected
curl http://localhost:3000/api/products

# Should return:
# {"success":true,"data":{"products":[...8 products...]}}
```

### Mobile App
```bash
cd mobile-app
npm start
# Scan QR code or press 'i' for iOS / 'a' for Android
```

---

## 🔑 Test Credentials

After creating admin user:
- **Email:** admin@example.com
- **Password:** (whatever you set)

---

## 🛠️ Useful Commands

```bash
# Start local Supabase
supabase start

# Stop local Supabase
supabase stop

# View database via Studio
# Local: http://127.0.0.1:54323
# Cloud: https://app.supabase.com

# Start dev server
cd admin-web && npm run dev

# Build for production
cd admin-web && npm run build && npm start

# Run mobile app
cd mobile-app && npm start
```

---

## 📁 File Structure

```
SolventZ/
├── supabase/
│   ├── config.toml           # Supabase configuration
│   ├── migrations/           # Database migrations
│   │   ├── 2026...schema.sql # Tables & RLS
│   │   └── 2026...storage.sql # Storage bucket
│   └── seed.sql              # Sample data
├── admin-web/
│   ├── .env.local            # Supabase credentials
│   ├── src/app/api/          # API routes
│   └── src/app/(dashboard)/  # Admin pages
└── mobile-app/
    ├── .env.local            # Supabase credentials
    └── src/                  # React Native code
```

---

## ⚠️ Troubleshooting

**Problem:** "NEXT_PUBLIC_SUPABASE_URL is undefined"
```bash
# Solution: Restart dev server after adding .env.local
npm run dev
```

**Problem:** Tables not showing in database
```bash
# Solution: Run migrations
supabase db push
```

**Problem:** "Connection refused at 127.0.0.1:54321"
```bash
# Solution: Start Supabase
supabase start
```

**Problem:** Can't login to admin dashboard
```
# Make sure user has admin role:
UPDATE public.users SET role = 'admin' 
WHERE email = 'your-email@example.com';
```

---

## 📖 Documentation

- **Complete Setup Guide:** `SUPABASE_SETUP_GUIDE.md`
- **Supabase Docs:** https://supabase.com/docs
- **Next.js Docs:** https://nextjs.org/docs
- **React Native Docs:** https://reactnative.dev

---

## 🎯 What's Included

✅ Complete database schema (7 tables)  
✅ Row-Level Security policies  
✅ Product image storage bucket  
✅ 8 sample products ready for testing  
✅ Admin authentication system  
✅ Full CRUD API endpoints  
✅ Mobile & web apps fully integrated  

---

## 🚀 Ready to Deploy?

**For Production:**
1. Use Supabase Cloud instance (not local)
2. Set environment variables in hosting platform
3. Update API keys in .env production
4. Deploy admin-web to Vercel
5. Deploy mobile-app to Expo/App Store

**Questions?** Check `SUPABASE_SETUP_GUIDE.md` for detailed docs.

