# 📚 Admin Web App - Quick Navigation Guide

**Last Updated:** April 9, 2026

---

## 🎯 Where to Find What You Need

### 📖 Documentation (Read These First)
1. **ADMIN_WEB_COMPLETION_SUMMARY.md** ← Start here for overview
2. **IMPLEMENTATION_GUIDE.md** ← Step-by-step building guide  
3. **ADMIN_WEB_DEVELOPMENT_GUIDE.md** ← Comprehensive reference
4. **ADMIN_WEB_STATUS_REPORT.md** ← Detailed statistics

### 💻 Code Location

#### API Routes (Ready to Use)
```
src/app/api/
├── auth/
│   ├── login/route.ts          -> POST /api/auth/login
│   └── logout/route.ts         -> POST /api/auth/logout
├── products/
│   ├── route.ts                -> GET /api/products (list)
│   │                           -> POST /api/products (create)
│   └── [id]/route.ts           -> GET/PATCH/DELETE product
├── orders/
│   ├── route.ts                -> GET /api/orders
│   └── [id]/route.ts           -> GET/PATCH order
├── surveys/
│   ├── route.ts                -> GET /api/surveys
│   └── [id]/route.ts           -> GET/PATCH survey
├── support/
│   ├── route.ts                -> GET /api/support
│   └── [id]/route.ts           -> GET/PATCH ticket
└── dashboard/
    └── metrics/route.ts        -> GET /api/dashboard/metrics
```

#### Shared Components (Reuse Everywhere)
```
src/components/
├── Button.tsx                  -> <Button variant="primary" />
├── Card.tsx                    -> <Card title="Title">Content</Card>
└── Badge.tsx                   -> <Badge variant="success">Status</Badge>
```

#### Types & Utilities
```
src/
├── types/
│   └── index.ts                -> All TypeScript interfaces
├── utils/
│   ├── format.ts               -> formatCurrency, formatDate, etc.
│   └── supabase/
│       ├── client.ts           -> Browser Supabase client
│       └── server.ts           -> Server Supabase client
```

#### Pages to Build
```
src/app/(dashboard)/
├── dashboard/
│   └── page.tsx                -> Dashboard (metrics)
├── products/
│   ├── page.tsx                -> Products list
│   ├── manage/
│   │   └── page.tsx            -> Create/edit product
│   └── [id]/
│       └── page.tsx            -> Product detail (optional)
├── orders/
│   ├── page.tsx                -> Orders list
│   └── [id]/
│       └── page.tsx            -> Order detail
├── surveys/
│   ├── page.tsx                -> Surveys list
│   └── [id]/
│       └── page.tsx            -> Survey detail & quote
└── support/
    ├── page.tsx                -> Support tickets list
    └── [id]/
        └── page.tsx            -> Ticket detail & messaging
```

---

## 🚀 Quick Start Commands

### Start Development Server
```bash
cd /Users/muntakim/Developer/Hasib/SolarAPP/admin-web
npm run dev
# Dev server running on http://localhost:3000
```

### Test an API Endpoint
```javascript
// In browser console:
fetch('/api/products?page=1').then(r => r.json()).then(console.log)
fetch('/api/dashboard/metrics').then(r => r.json()).then(console.log)
fetch('/api/orders?status=pending').then(r => r.json()).then(console.log)
```

### Build for Production
```bash
npm run build
npm start
```

---

## 📋 Implementation Checklist

### Dashboard Page
- [ ] Fetch `/api/dashboard/metrics`
- [ ] Display 4 main metric cards
- [ ] Show order status breakdown
- [ ] List low stock products (if any)
- [ ] Add quick action buttons
- [ ] Test all sections

### Products Module
- [ ] List page with table (GET /api/products)
- [ ] Add filter by category, brand
- [ ] Add search functionality  
- [ ] Add pagination
- [ ] Create page/form (POST /api/products)
- [ ] Edit page/form (PATCH /api/products/[id])
- [ ] Delete button (DELETE /api/products/[id])
- [ ] Test CRUD operations

### Orders Module
- [ ] List page with filters
- [ ] Filter by status (GET /api/orders?status=pending)
- [ ] Search by order ID/ email
- [ ] Detail page showing order items (GET /api/orders/[id])
- [ ] Update status form (PATCH /api/orders/[id])
- [ ] Test all filters

### Surveys Module
- [ ] List page with pagination
- [ ] Filter by status
- [ ] Detail page with survey info
- [ ] Quote builder form
- [ ] Update survey status (PATCH /api/surveys/[id])
- [ ] Test quote creation

### Support Module
- [ ] Tickets list
- [ ] Filter by status, category
- [ ] Detail page with messages
- [ ] Reply form
- [ ] Assign ticket form (PATCH /api/support/[id])
- [ ] Test messaging

---

## 🧪 Testing Endpoints

### Check All Endpoints Work
```bash
# Products
GET  /api/products?page=1
POST /api/products (with body)
GET  /api/products/[id]
PATCH /api/products/[id]
DELETE /api/products/[id]

# Orders
GET  /api/orders?page=1
GET  /api/orders/[id]
PATCH /api/orders/[id]

# Surveys
GET  /api/surveys?page=1
GET  /api/surveys/[id]
PATCH /api/surveys/[id]

# Support
GET  /api/support?page=1
GET  /api/support/[id]
PATCH /api/support/[id]

# Dashboard
GET  /api/dashboard/metrics
```

---

## 💡 Key Patterns to Follow

### Pattern 1: List Page
```tsx
const [items, setItems] = useState([]);
const [page, setPage] = useState(1);

useEffect(() => {
  fetch(`/api/[resource]?page=${page}`)
    .then(r => r.json())
    .then(data => setItems(data.data));
}, [page]);

return <Table data={items} />;
```

### Pattern 2: Detail Page
```tsx
const { id } = params;
const [item, setItem] = useState(null);

useEffect(() => {
  fetch(`/api/[resource]/${id}`)
    .then(r => r.json())
    .then(data => setItem(data.data));
}, [id]);

return <DetailView item={item} />;
```

### Pattern 3: Filter Page
```tsx
const [filter, setFilter] = useState('');
const [items, setItems] = useState([]);

useEffect(() => {
  const params = new URLSearchParams({ status: filter });
  fetch(`/api/[resource]?${params}`)
    .then(r => r.json())
    .then(data => setItems(data.data));
}, [filter]);
```

### Pattern 4: Status Badge
```tsx
<Badge variant={getStatusBadgeVariant(status)}>
  {getStatusLabel(status)}
</Badge>
```

### Pattern 5: Format Data
```tsx
<p>{formatCurrency(price)}</p>
<p>{formatDate(date)}</p>
<p>{getStatusLabel(status)}</p>
```

---

## 🎯 Type Examples

### Using Types in Your Pages
```tsx
import type { Product, Order, Survey, SupportTicket, DashboardMetrics } from '@/types';

// Using in component
const products: Product[] = [];
const order: Order | null = null;
const metrics: DashboardMetrics = {};
```

---

## 🔗 Important Links

### Local Development
- App: http://localhost:3000
- API Base: http://localhost:3000/api

### Cloud Services
- Supabase: https://app.supabase.com/
- Next.js Docs: https://nextjs.org/docs
- Tailwind CSS: https://tailwindcss.com

### Project Documentation
- PRD: `/prd.txt`
- Database Schema: `/supabase/migrations/`

---

## 🆘 Common Issues & Solutions

### "Module not found" Error
→ Restart dev server: `npm run dev`

### Type errors
→ Check src/types/index.ts for correct types

### API 401 Error  
→ Check if authenticated via Supabase

### API 403 Error
→ Check user role in database (must be admin)

### Blank page loading
→ Check browser console (F12) for errors

---

## 📊 Status

| Component | Status | File |
|-----------|--------|------|
| Backend API | ✅ Complete | src/app/api/ |
| Types | ✅ Complete | src/types/index.ts |
| Components | ✅ Complete | src/components/ |
| Utils | ✅ Complete | src/utils/ |
| Dashboard | ⏳ To Build | src/app/(dashboard)/dashboard/ |
| Products | ⏳ To Build | src/app/(dashboard)/products/ |
| Orders | ⏳ To Build | src/app/(dashboard)/orders/ |
| Surveys | ⏳ To Build | src/app/(dashboard)/surveys/ |
| Support | ⏳ To Build | src/app/(dashboard)/support/ |

---

## 📞 Quick Reference

**Need to:**
- **Build a page?** → Read IMPLEMENTATION_GUIDE.md
- **Find API docs?** → Check src/app/api/ comments
- **Understand types?** → Check src/types/index.ts
- **Format data?** → Use src/utils/format.ts functions
- **Use components?** → Import from src/components/
- **Check architecture?** → Read ADMIN_WEB_DEVELOPMENT_GUIDE.md

---

## ✅ Ready to Start?

1. Read: **IMPLEMENTATION_GUIDE.md**
2. Review: **src/types/index.ts**
3. Test: API endpoint in browser console
4. Build: First page following pattern
5. Test: Page loads and displays data
6. Iterate: Build next page using same pattern

**Estimated time:** 12-16 hours for all pages

---

**Happy coding! 🚀**

*The backend is production-ready. Time to build the frontend!*
