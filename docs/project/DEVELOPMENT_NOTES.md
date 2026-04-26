# SolventZ Mobile App - Development Notes & API Integration

## 🔧 Integration Points

### Supabase Database Setup Required

Before running the app, verify these Supabase tables exist:

```sql
-- Already in migrations, verify they exist:

1. users (from auth.users)
   - id (UUID)
   - email
   - full_name
   - phone
   - city
   - role
   - is_active
   - created_at
   - updated_at

2. products
   - id, category_id, sku, name, brand
   - price, stock_quantity, images, is_active
   - specifications (JSONB), ratings (JSONB)

3. categories
   - id, name, slug, icon_url, is_active

4. orders
   - id, user_id, order_number, status
   - delivery_address (JSONB), payment_method
   - subtotal, delivery_fee, grand_total
   - created_at, updated_at

5. order_items
   - id, order_id, product_id
   - product_snapshot (JSONB), quantity, unit_price

6. support_tickets
   - id, user_id, category, subject
   - description, attachments (TEXT[])
   - status, created_at

7. surveys
   - id, user_id, property_type, address
   - monthly_bill, preferred_date, status
   - created_at

8. user_addresses (NEW - needs to be created)
   - id (UUID)
   - user_id (UUID FK → users.id)
   - label (VARCHAR) - "Home", "Office", etc
   - address (TEXT)
   - city (VARCHAR)
   - is_default (BOOLEAN DEFAULT false)
   - created_at (TIMESTAMPTZ DEFAULT NOW())

9. user_preferences (NEW - needs to be created)
   - id (UUID)
   - user_id (UUID FK → users.id, UNIQUE)
   - wishlist (UUID[]) - array of product IDs
   - updated_at (TIMESTAMPTZ DEFAULT NOW())

10. faqs (NEW - needs to be created)
    - id (UUID)
    - category (VARCHAR) - "Installation", "Billing", etc
    - question (TEXT)
    - answer (TEXT)
    - order_rank (INTEGER)
    - is_active (BOOLEAN DEFAULT true)
```

### Supabase Storage Buckets

Create these public buckets:

```
1. product-images (public)
   - Path: /products/{product_id}/*.jpg
   
2. support-attachments (public)
   - Path: /support-attachments/{user_id}/{ticket_id}/*.jpg
```

---

## 🔌 API Endpoints Used

### Authentication
```
POST /auth/v1/auth/signup         (Supabase Auth)
POST /auth/v1/auth/signin         (Supabase Auth)
POST /auth/v1/auth/refresh        (Supabase Auth)
GET  /auth/v1/auth/user           (Supabase Auth)
POST /auth/v1/auth/signout        (Supabase Auth)
```

### Products
```
GET  /rest/v1/products?*          (Supabase Realtime)
GET  /rest/v1/categories?*        (Supabase Realtime)
GET  /rest/v1/products?id=*       (By ID)
```

### Orders
```
GET  /rest/v1/orders?user_id=*    (User's orders)
POST /rest/v1/orders              (Create order)
PATCH /rest/v1/orders?id=*        (Update status)
GET  /rest/v1/order_items?*       (Get items)
```

### Support
```
POST /rest/v1/support_tickets     (Create ticket with images)
GET  /rest/v1/support_tickets?*   (Get user's tickets)
```

### Storage
```
POST /storage/v1/object/support-attachments/  (Upload images)
GET  /storage/v1/object/public/support-attachments/  (Retrieve)
```

---

## 🐛 Common Issues & Fixes

### Issue: "Reanimated plugin not found"
**Fix**: Babel config is already created at `babel.config.js` with reanimated plugin
```js
// babel.config.js already includes:
plugins: ['react-native-reanimated/plugin']
```

### Issue: "Cannot find module '@react-native-async-storage'"
**Fix**: Already installed, but if missing:
```bash
npm install @react-native-async-storage/async-storage
```

### Issue: Image upload fails "bucket not found"
**Fix**: Create the `support-attachments` bucket in Supabase:
1. Go to Storage → Create new bucket
2. Name: `support-attachments`
3. Make it PUBLIC
4. Add object: `support-attachments/**` in policies

### Issue: Notifications not appearing
**Fix**: 
1. Make sure app has notification permission granted
2. Request permission on app start (already done in App.tsx)
3. Test with local notification first:
```typescript
import { sendLocalNotification } from './src/hooks/useRealtimeNotifications';
sendLocalNotification('Test', 'This is a test');
```

### Issue: Offline cache not working
**Fix**: Make sure AsyncStorage is properly linked (it's linked by default in Expo)
- Check device storage permission is granted
- Cache keys start with `@SolventZ_Cache_` prefix

### Issue: Wishlist/Comparison not persisting
**Fix**: These use Zustand in-memory stores (persist on restart but not app kill)
- To add persistence: 
```typescript
import { persist } from 'zustand/middleware';
// Wrap store creation with persist middleware
```

### Issue: React Native Reanimated crashes on startup
**Fix**: 
1. Clear metro bundler cache:
```bash
npm start -- --reset-cache
```
2. Restart app from fresh
3. Rebuild if on device:
```bash
npm run android -- --no-cache
```

### Issue: "Support-attachments service not found"
**Fix**: Supabase Storage URLs might need adjustment:
- Check `supportService.ts` upload function
- Verify bucket name matches
- Ensure user has permission to write to storage

### Issue: Animations are stuttering
**Fix**: 
1. Disable heavy tasks during animation:
```typescript
// Use useFadeIn hook instead of custom timing
const fadeIn = useFadeIn(dependency, 300);
```
2. Profile with React DevTools
3. Check for excessive re-renders

### Issue: Camera permission denied
**Fix**: 
1. Update `app.json` with required permissions:
```json
{
  "plugins": [
    ["expo-camera", { "cameraPermission": "Allow $(PRODUCT_NAME) to access your camera" }],
    ["expo-image-picker", { "photosPermission": "Allow..." }]
  ]
}
```
2. For Expo Go: Already includes permission
3. For EAS build: Permissions auto-requested

---

## 🔐 Environment Variables

Create `.env.local`:
```bash
EXPO_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJxxx...
```

Never commit `.env.local`!

---

## 📱 Testing on Different Devices

### Minimum Requirements
- iOS 13+
- Android API 21+
- 100MB free storage
- 2GB RAM recommended

### Test Devices
```
Android:
- Pixel 4a (reference device)
- Samsung A11 (budget phone)
- OnePlus 8 (high-end)

iOS:
- iPhone 12 (reference)
- iPhone SE (budget)
- iPhone 13 Pro (high-end)
```

---

## 🚀 Deployment Checklist

Before submitting to stores:

```
Code
□ All TypeScript errors fixed
□ No console.error or console.warn in production
□ All imported files exist
□ No circular dependencies
□ Proper error boundaries

Features
□ All screens load without crashes
□ Auth flow works end-to-end
□ Cart checkout complete
□ Orders display correctly
□ Images display
□ Offline mode tested
□ Notifications tested
□ Support tickets submit

Performance
□ Lighthouse score >90
□ App startup <3 seconds
□ List scroll smooth (60fps)
□ No memory leaks
□ Cache working properly

Design
□ All screens responsive
□ Readable text sizes
□ Touch targets 44x44pt
□ Color contrast OK
□ Dark & light modes tested

Security
□ No hardcoded secrets
□ Sensitive data cached safely
□ Rate limiting working
□ SQL injection protected
□ XSS protected (N/A for mobile)
□ HTTPS enforced

Documentation
□ README updated
□ API docs complete
□ Setup guide written
□ Deployment guide ready
```

---

## 🔮 Future Enhancements

### Phase 7+ Ideas

1. **Advanced Search**
   - Elasticsearch integration
   - Voice search
   - Search history

2. **Personalization**
   - ML-based recommendations
   - User preference learning
   - Personalized homepage

3. **Social Features**
   - Product reviews & ratings
   - User profiles
   - Referral program

4. **Payment Integration**
   - Stripe integration
   - JazzCash payment
   - Multiple payment methods

5. **Real-Time Updates**
   - Supabase Realtime subscriptions
   - Live inventory updates
   - Real-time order tracking

6. **Enhanced Support**
   - Live chat
   - Video call support
   - AI chatbot

7. **Analytics**
   - User behavior tracking
   - Conversion funnel analysis
   - A/B testing framework

8. **Localization**
   - Urdu language support
   - Currency localization
   - RTL layout support

---

## 💡 Architecture Decisions

### Why Zustand for Wishlist/Comparison?
- Lightweight (vs Redux)
- Perfect for simple state
- No boilerplate
- Good for local feature state

### Why Redux for Auth/Cart?
- Complex state logic
- Middleware support
- Time-travel debugging
- Team familiarity

### Why Supabase Storage for Images?
- Serverless (no EC2)
- Built-in CDN
- RLS support
- Easy integration

### Why Reanimated 3?
- Native performance
- Gesture support
- Worklet API
- Active maintenance

### Why TTL Cache?
- Prevents stale data
- Automatic cleanup
- Reduces storage bloat
- Simple to implement

---

## 📚 Resource Links

- **Supabase Docs**: https://supabase.com/docs
- **React Native**: https://reactnative.dev/
- **Reanimated**: https://docs.swmansion.com/react-native-reanimated/
- **Zustand**: https://github.com/pmndrs/zustand
- **Expo**: https://docs.expo.dev/
- **React Navigation**: https://reactnavigation.org/

---

## 👥 Team Communication

### Code Review Checklist
- [ ] TypeScript types correct
- [ ] No console logs
- [ ] Proper error handling
- [ ] Performance acceptable
- [ ] Follows design system

### Common Git Commands
```bash
# Start feature
git checkout -b feature/wishlist

# Commit
git commit -m "feat: add wishlist functionality"

# Merge
git checkout develop
git pull
git merge feature/wishlist

# Push
git push origin develop
```

### Squash Commits
```bash
git rebase -i HEAD~3  # Last 3 commits
# Mark older commits as 'squash'
# Save and update message
```

---

**Updated**: April 10, 2026  
**Maintainer**: Development Team  
**Status**: Production Ready ✅
