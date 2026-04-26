# 🧪 Notification System Testing Guide

Complete testing procedures to verify the notification system is working correctly.

---

## 🔍 Pre-Testing Checklist

- [ ] Admin web running (`npm run dev` in admin-web/)
- [ ] Supabase connection active and verified
- [ ] Real-time subscriptions enabled in Supabase
- [ ] All notification files created successfully
- [ ] No console errors visible
- [ ] Browser dev tools open (F12)

---

## 🧪 Test 1: Verify Components Load

### Step 1: Check Dashboard Header
1. Open admin dashboard: `http://localhost:3000/dashboard`
2. Look for bell icon (🔔) in top-right of header
3. Badge should show "0" (no unread notifications)

**Expected Result:**
```
✅ Bell icon visible
✅ No unread badge or shows "0"
✅ No console errors
```

### Step 2: Check Notification Toast Container
1. Open browser console (F12)
2. Navigate to any page
3. Toast container should be present in DOM

**Expected Result:**
```
✅ No layout shift
✅ No console errors about NotificationToast
✅ Container positioned at bottom-right
```

---

## 🧪 Test 2: Browser Notification Permission

### Step 1: Request Permission
1. Admin should see browser permission dialog
2. Click "Allow" to enable notifications

**Expected Result:**
```
✅ Permission dialog appears
✅ Shows "Your admin site wants to show notifications"
✅ Can grant permission
```

### Step 2: Verify Settings
1. Check browser settings → Notifications
2. Verify notification domain is allowed

**Expected Result:**
```
✅ Domain listed with "Allow" status
✅ Can toggle on/off
```

---

## 🧪 Test 3: Manual Toast Notification

### Step 1: Trigger Test Notification
Open browser console and run:
```javascript
// Access the notification context
const event = new CustomEvent('addNotification', {
  detail: {
    type: 'success',
    title: '✅ Test Notification',
    message: 'If you see this, toasts are working!'
  }
});
window.dispatchEvent(event);
```

**Alternative - Direct Context Check:**
1. Open React Developer Tools
2. Find `NotificationContext` provider
3. Check if it's rendering properly

**Expected Result:**
```
✅ Toast appears in bottom-right
✅ Shows green background (success)
✅ Displays title and message
✅ Auto-dismisses after 5 seconds
✅ No console errors
```

---

## 🧪 Test 4: Notification Bell Dropdown

### Step 1: Click Bell Icon
1. Click notification bell (🔔)
2. Dropdown should appear below bell

**Expected Result:**
```
✅ Dropdown opens smoothly
✅ Shows "No notifications" message or list
✅ Can scroll if many notifications
```

### Step 2: Test Clear All Button
1. If notifications exist, click "Clear All"
2. All notifications should disappear

**Expected Result:**
```
✅ Clear All button visible
✅ Removes all notifications
✅ Badge disappears or resets to 0
✅ Dropdown shows "No notifications"
```

---

## 🧪 Test 5: Real-Time Order Notification

### Step 1: Prepare
1. Keep admin dashboard open in one tab
2. Open Supabase Studio in another tab
3. Navigate to `orders` table in Supabase

### Step 2: Create Test Order (Method 1 - Direct Insert)
```sql
-- Run in Supabase SQL Editor
INSERT INTO orders (
  order_number,
  user_id,
  payment_method,
  payment_status,
  status,
  subtotal,
  vat,
  delivery_fee,
  grand_total
) VALUES (
  'TEST-' || to_char(now(), 'YYYYMMDDHH24MISS'),
  (SELECT id FROM users LIMIT 1),
  'CARD',
  'COMPLETED',
  'PENDING',
  5000,
  1000,
  500,
  6500
);
```

### Step 3: Watch Admin Dashboard
1. Check bottom-right corner for toast
2. Check notification bell badge
3. Check browser notification (if enabled)

**Expected Result:**
```
✅ Toast appears with "🛒 New Order Received"
✅ Shows order number and amount
✅ Bell badge updates to "1"
✅ Clicking bell shows notification in dropdown
✅ Clicking notification navigates to order
✅ Sound plays (if not muted)
✅ Browser notification appears (if enabled)
```

---

## 🧪 Test 6: Real-Time Survey Notification

### Step 1: Create Test Survey
```sql
-- Run in Supabase SQL Editor
INSERT INTO surveys (
  user_id,
  property_type,
  status,
  requested_date
) VALUES (
  (SELECT id FROM users LIMIT 1),
  'RESIDENTIAL',
  'PENDING',
  now()
);
```

### Step 2: Watch Admin Dashboard
Look for:
- Toast with "📋 New Survey Request"
- Bell badge increment
- Dropdown notification

**Expected Result:**
```
✅ Toast appears with survey icon
✅ Shows customer name from surveys
✅ Bell badge increments
✅ Browser notification appears
✅ Click navigates to survey detail
```

---

## 🧪 Test 7: Real-Time Support Ticket Notification

### Step 1: Create Test Support Ticket
```sql
-- Run in Supabase SQL Editor
INSERT INTO support_tickets (
  user_id,
  category,
  subject,
  description,
  status
) VALUES (
  (SELECT id FROM users LIMIT 1),
  'PRODUCT_DEFECT',
  'Test Ticket',
  'This is a test support ticket',
  'OPEN'
);
```

### Step 2: Watch Admin Dashboard
Look for:
- Toast with category emoji (🔧)
- Subject line in message
- Bell notification

**Expected Result:**
```
✅ Toast appears with category emoji
✅ Shows subject in toast
✅ Bell badge increments
✅ Browser notification appears
✅ Click navigates to ticket detail
```

---

## 🧪 Test 8: Order Status Update Notification

### Step 1: Find Recent Order
1. Go to Orders page
2. Find a test order created earlier
3. Note its ID

### Step 2: Update Order Status (In Supabase)
```sql
-- Update the order status
UPDATE orders
SET status = 'CONFIRMED'
WHERE id = '<ORDER_ID>';
```

### Step 3: Watch Admin Dashboard
Look for:
- Info notification about status change
- Bell badge increment
- Toast display

**Expected Result:**
```
✅ Toast appears with status update
✅ Shows order number and new status
✅ Blue (info) notification type
✅ Bell badge increments
✅ No sound plays (info notifications silent)
```

---

## 🧪 Test 9: Multiple Rapid Notifications

### Step 1: Create Multiple Orders
```sql
-- Create 3 orders in quick succession
INSERT INTO orders (order_number, user_id, payment_method, payment_status, status, subtotal, vat, delivery_fee, grand_total)
VALUES 
  ('BATCH1-' || to_char(now(), 'YYYYMMDDHH24MISS'), (SELECT id FROM users LIMIT 1), 'CARD', 'COMPLETED', 'PENDING', 5000, 1000, 500, 6500),
  ('BATCH2-' || to_char(now(), 'YYYYMMDDHH24MISS'), (SELECT id FROM users LIMIT 1), 'CARD', 'COMPLETED', 'PENDING', 7000, 1400, 500, 8900),
  ('BATCH3-' || to_char(now(), 'YYYYMMDDHH24MISS'), (SELECT id FROM users LIMIT 1), 'CARD', 'COMPLETED', 'PENDING', 6000, 1200, 500, 7700);
```

### Step 2: Watch Dashboard
1. Toast queue should show only most recent
2. Bell badge should show "3"
3. Dropdown should show all 3

**Expected Result:**
```
✅ Only latest toast visible
✅ Previous toasts disappeared (auto-dismiss)
✅ Bell badge shows correct count
✅ All notifications in dropdown
✅ Can click each to navigate
```

---

## 🧪 Test 10: Sound Alert

### Step 1: Verify System Audio
1. Ensure system volume is on
2. Browser volume not muted
3. Tab not muted (check tab icon)

### Step 2: Create Alert Notification
```sql
INSERT INTO orders (order_number, user_id, payment_method, payment_status, status, subtotal, vat, delivery_fee, grand_total)
VALUES ('SOUND-TEST-' || to_char(now(), 'YYYYMMDDHH24MISS'), (SELECT id FROM users LIMIT 1), 'CARD', 'COMPLETED', 'PENDING', 5000, 1000, 500, 6500);
```

**Expected Result:**
```
✅ Beep sound plays (800Hz, 0.5 seconds)
✅ Only plays for alert type (not info)
✅ Volume corresponds to system audio
✅ No console errors about audio
```

---

## 🧪 Test 11: Notification Actions

### Step 1: Create Order Notification
Create a test order following Test 5.

### Step 2: Click "View Order" Button
1. In toast, click the "View Order" button
2. Or click the notification in dropdown

**Expected Result:**
```
✅ Navigates to /dashboard/orders/[id]
✅ Shows correct order details
✅ URL updates properly
✅ Page loads without errors
```

### Step 3: Test Back Navigation
1. Go back to dashboard
2. Bell should still show notification
3. Clicking again should work

**Expected Result:**
```
✅ Multiple clicks don't cause issues
✅ Navigation works consistently
✅ No state corruption
```

---

## 🧪 Test 12: Auto-Dismiss Timing

### Step 1: Create Notification
```sql
INSERT INTO orders (order_number, user_id, payment_method, payment_status, status, subtotal, vat, delivery_fee, grand_total)
VALUES ('DISMISS-' || to_char(now(), 'YYYYMMDDHH24MISS'), (SELECT id FROM users LIMIT 1), 'CARD', 'COMPLETED', 'PENDING', 5000, 1000, 500, 6500);
```

### Step 2: Time Auto-Dismiss
1. Note when toast appears
2. Count seconds until it disappears
3. Should be approximately 5 seconds

**Expected Result:**
```
✅ Toast visible for ~5 seconds
✅ Smoothly fades out
✅ Doesn't disappear too quickly
✅ Doesn't stay too long
```

---

## 🧪 Test 13: Bell Unread Badge

### Step 1: Verify Badge Updates
1. Create 3 notifications (orders, survey, ticket)
2. Badge should show "3"

### Step 2: Click and Mark as Read
1. Click bell dropdown
2. Click on a notification
3. Badge should decrement to "2"

**Expected Result:**
```
✅ Badge shows correct count
✅ Updates in real-time
✅ One per notification opened
```

---

## 🧪 Test 14: No Persistence Mode (Page Reload)

### Step 1: Create a Notification
Create a test order notification.

### Step 2: Reload Page
1. Press F5 to reload
2. Check if notifications persist

**Expected Result (Current Behavior):**
```
⏳ Notifications cleared on reload (expected - not yet using localStorage)
✅ System continues listening for new notifications
✅ New notifications appear after reload
```

---

## 🧪 Test 15: Console & Network Check

### Step 1: Open DevTools
1. Press F12
2. Go to Console tab
3. Go to Network tab

### Step 2: Filter Logs
1. Create a test notification
2. Check Console for errors
3. Check Network for WebSocket connections

**Expected Result:**
```
✅ No red errors in console
✅ WebSocket connection to Supabase
✅ Message: "Realtime subscription established" (if logging)
✅ No unhandled promise rejections
🔵 Warnings OK (deprecation warnings acceptable)
```

---

## ✅ Full Test Checklist

### Component Tests
- [ ] Bell icon renders in header
- [ ] Toast container positioned correctly
- [ ] Dropdown closes when clicking outside
- [ ] Animations smooth

### Notification Tests
- [ ] Toast appears for new order
- [ ] Toast appears for new survey
- [ ] Toast appears for new ticket
- [ ] Toast appears for order status update
- [ ] All toasts auto-dismiss after 5s

### Bell Tests
- [ ] Unread badge shows correct count
- [ ] Dropdown scrolls if too many
- [ ] "Clear All" removes all notifications
- [ ] Clicking notification navigates

### Real-Time Tests
- [ ] Supabase subscription connects
- [ ] WebSocket connection active
- [ ] New inserts trigger immediately
- [ ] Status updates trigger properly

### Sound & Notifications
- [ ] Sound plays for alert types
- [ ] Sound doesn't play for info
- [ ] Browser notification appears
- [ ] Browser notification clickable

### UX Tests
- [ ] No console errors
- [ ] No page slowdown
- [ ] Animations fluid
- [ ] Mobile responsive (optional)

---

## 🐛 Common Issues

### Issue: Notifications Not Appearing
**Troubleshooting:**
1. Check Supabase connection in console
2. Verify browser notification permission
3. Check if WebSocket is connected
4. Try refreshing page

### Issue: Sound Not Playing
**Troubleshooting:**
1. Check system volume
2. Check browser volume
3. Try different notification type (alert vs info)
4. Check for browser autoplay restrictions

### Issue: Bell Badge Not Updating
**Troubleshooting:**
1. Check React DevTools for state changes
2. Verify NotificationContext is provided
3. Check for console errors
4. Try creating fresh notification

### Issue: Navigation Not Working
**Troubleshooting:**
1. Check Next.js router is working
2. Verify href is correct format
3. Check page exists at destination
4. Try manual navigation

---

## 📊 Sample Test Results

### Expected Console Output
```javascript
// Real-time client subscribed
Supabase realtime client connected

// First notification created
Adding notification: {type: 'alert', title: '🛒 New Order Received', ...}

// Auto-dismiss triggered
Removing notification after 5 seconds

// Bell dropdown opened
Notification bell dropdown toggled
```

### Expected Network Traffic
```
WebSocket: wss://your-project.supabase.co/realtime/v1?api_key=...
Status: 101 Switching Protocols
Message: Authentication confirmation
Message: postgres_changes subscription
```

---

## 🎯 Success Criteria

All tests pass when:
1. ✅ Toast notifications appear for new orders, surveys, tickets
2. ✅ Notifications appear in bell dropdown
3. ✅ Badge shows unread count
4. ✅ Clicking notif navigates to detail page
5. ✅ Auto-dismiss works (5 seconds)
6. ✅ Sound plays for alerts
7. ✅ Browser notification appears
8. ✅ No console errors
9. ✅ WebSocket connection active
10. ✅ Multiple notifications handled correctly

---

## 📝 Notes for Testing

- Use fresh browser tab to avoid cache issues
- Check Supabase dashboard for actual data
- Multiple orders/surveys/tickets help test queuing
- Keep browser console open during tests to catch errors
- Test on different browsers if possible (Chrome, Firefox, Safari)

---

## 🎉 After Passing All Tests

Once all tests pass:
1. The notification system is production-ready
2. All real-time subscriptions are working
3. Sound and browser notifications are configured
4. Dashboard is monitoring all critical events
5. Team is ready to deploy to production

