# 🔔 Web Notification System

Complete real-time notification system for SolventZ admin dashboard with multiple alert channels and user-friendly UI.

---

## ✨ Features Included

### 1. **Real-Time Alerts** ✅
- **New Orders** - Instant notification when customer places order
- **New Surveys** - Alert when customer requests site survey
- **New Support Tickets** - Notification for new customer support requests
- **Status Updates** - Notification when order status changes

### 2. **Multiple Notification Types** ✅
- **Toast Notifications** - Pop-up alerts in bottom-right corner
- **Notification Bell** - Dropdown with notification history
- **Browser Notifications** - OS-level notifications (macOS, Windows, Linux)
- **Sound Alerts** - Audio feedback for critical alerts
- **In-App Notifications** - Always visible in dashboard

### 3. **User Experience** ✅
- Auto-dismiss non-critical toasts after 5 seconds
- Persistent alert notifications in dropdown
- Unread count badge on notification bell
- Click to view order/survey/ticket directly from notification
- Clear all notifications option
- Smooth animations

---

## 🏗️ Architecture

### Components Created

**1. `NotificationContext.tsx`** - Global state management
- Manages all notifications
- Add, remove, mark as read notifications
- Unread count tracking

**2. `NotificationToast.tsx`** - Toast display component
- Shows recent toasts in top-right (auto-dismiss)
- Color-coded by type (success, error, warning, alert, info)
- Animated entrance/exit

**3. `NotificationBell.tsx`** - Notification center
- Bell icon with unread badge
- Dropdown with notification history
- Click notification to navigate
- Mark as read functionality

**4. `useRealtimeNotifications.ts`** - Real-time listener hook
- Supabase Realtime subscriptions
- Listens to INSERT/UPDATE events on:
  - `orders` table
  - `surveys` table
  - `support_tickets` table
- Triggers browser notifications
- Plays sound alerts

**5. `NotificationSettings.tsx`** - User preferences (optional)
- Toggle sound on/off
- Enable/disable browser notifications
- Select alert types

---

## 📦 Files Structure

```
src/
├── context/
│   └── NotificationContext.tsx          # Global notification state
├── components/
│   ├── NotificationToast.tsx            # Toast display
│   ├── NotificationBell.tsx             # Notification center
│   └── NotificationSettings.tsx         # Preferences (optional)
├── hooks/
│   └── useRealtimeNotifications.ts      # Real-time listeners
└── app/
    ├── layout.tsx                       # Wrapped with provider
    └── (dashboard)/layout.tsx           # Notification bell added
```

---

## 🚀 How It Works

### 1. **New Order Notification**

When a customer places an order:
```
Orders table INSERT event
    ↓
Real-time listener triggered
    ↓
Creates notification:
  - Type: alert
  - Title: "🛒 New Order Received"
  - Message: Order number & amount
  - Action: "View Order" link
    ↓
Displays in:
  - Toast (auto-dismiss)
  - Notification Bell dropdown
  - Browser notification (if enabled)
  - Sound alert
```

### 2. **New Survey Request**

When customer requests survey:
```
Surveys table INSERT event
    ↓
Real-time listener triggered
    ↓
Creates notification:
  - Type: alert
  - Title: "📋 New Survey Request"
  - Message: Customer name & property type
  - Action: "View Survey" link
    ↓
Displays same as orders
```

### 3. **New Support Ticket**

When customer submits support ticket:
```
Support_tickets table INSERT event
    ↓
Real-time listener triggered
    ↓
Creates notification based on category:
  - 🔧 Product Defect
  - ⚡ Installation Issue
  - 💰 Billing Issue
  - ❓ General Query
    ↓
Displays same as orders
```

---

## 📱 Notification Types

### Toast Notifications (Auto-dismiss)
```
✅ Success  - Green, 5 seconds
❌ Error    - Red, 5 seconds  
⚠️  Warning - Yellow, 5 seconds
ℹ️  Info    - Blue, 5 seconds
```

### Alert Notifications (Persistent)
```
🔴 Alert   - Orange, stays until clicked/dismissed
```

---

## 🔐 Real-Time Event Subscriptions

### Orders Channel
```sql
-- Listens to INSERT on orders table
-- Triggers for new orders only (not updates)
```

### Surveys Channel
```sql
-- Listens to INSERT on surveys table
-- Triggers for new survey requests
```

### Support Tickets Channel
```sql
-- Listens to INSERT on support_tickets table
-- Triggers for new tickets
```

### Status Updates Channel
```sql
-- Listens to UPDATE on orders table
-- Triggers only when status changes
```

---

## 🎵 Sound Alerts

Automatic beep sound plays when:
- New order alert triggered
- New survey request alert
- New support ticket alert

Uses Web Audio API to generate pure sine wave beep (800Hz, 0.5 seconds)

---

## 🌐 Browser Notifications

Requires user permission (requested on first visit).

When enabled:
- Shows OS-level notification
- Works even if browser window not focused
- Includes notification title and message
- Clickable to focus browser window

---

## 🎨 UI Components Used

### Notification Bell (Top Right)
- Bell icon with red badge showing unread count
- Click to open dropdown
- Shows up to 5 recent notifications
- "Clear All" button
- Time stamps for each notification

### Toast Display (Bottom Right)
- Slides in from right
- Auto-dismisses after 5 seconds
- Action button to navigate
- Close button to dismiss manually
- Color-coded backgrounds

---

## 🔧 Integration Points

### 1. **Layout Integration**
```tsx
// Root layout - Wraps app with NotificationProvider
<NotificationProvider>
  {children}
  <NotificationToast />
</NotificationProvider>
```

### 2. **Dashboard Integration**
```tsx
// Dashboard layout - Adds notification bell to header
<header>
  <NotificationBell />
</header>
```

### 3. **Real-Time Setup**
```tsx
// Dashboard layout - Initializes listeners
useRealtimeNotifications();
requestBrowserNotificationPermission();
```

---

## 📊 Notification Flow

```
┌─────────────────────┐
│ Database Changes    │
│ (Orders, Surveys,   │
│  Tickets...)        │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ Supabase Realtime   │
│ Event Subscription  │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ Notification Hook   │
│ (catches event)     │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────────────────────┐
│ Creates Notification & Triggers:     │
│ 1. Toast popup (auto-dismiss)       │
│ 2. Bell badge update                │
│ 3. Browser notification             │
│ 4. Sound alert                      │
└─────────────────────────────────────┘
```

---

## 🛠️ Customization

### Add More Notification Types

Edit `useRealtimeNotifications.ts`:
```tsx
// Add new subscription channel
const newChannel = supabase
  .channel('public:new_table')
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'new_table'
  }, (payload) => {
    addNotification({
      type: 'alert',
      title: 'New event',
      message: payload.new.message,
      action: {
        label: 'View',
        href: '/path'
      }
    });
  })
  .subscribe();
```

### Customize Toast Appearance

Edit `NotificationToast.tsx` to change:
- Animation speed
- Position (top-right default)
- Auto-dismiss duration (5 seconds)
- Max visible toasts (5 default)

### Change Notification Bell Style

Edit `NotificationBell.tsx` to modify:
- Bell icon design
- Badge styling
- Dropdown width/height
- Animation effects

---

## ✅ Testing Checklist

- [ ] New order triggers notification
- [ ] New survey triggers notification
- [ ] New support ticket triggers notification
- [ ] Toast auto-dismisses after 5 seconds
- [ ] Notification bell shows unread count
- [ ] Click notification navigates to correct page
- [ ] Sound plays when alert triggered
- [ ] Browser notification appears (if enabled)
- [ ] "Clear All" removes all notifications
- [ ] Animations are smooth

---

## 🔗 Dependencies

- **Supabase** - Real-time subscriptions
- **Next.js** - Framework
- **React** - UI library
- **Lucide Icons** - Icons (Bell, X, AlertCircle, etc.)
- **Web Audio API** - Sound generation (built-in browser API)
- **Notification API** - Browser notifications (built-in browser API)

---

## 📝 Usage Example

### In Dashboard
1. Admin opens dashboard
2. Real-time listeners automatically start
3. Customer places order
4. Toast appears in bottom-right showing order details
5. Sound beeps
6. Notification bell shows badge with "1" unread
7. Admin clicks notification → navigates to order detail page

---

## 🎯 Future Enhancements

- [ ] Email notifications for critical alerts
- [ ] SMS notifications for urgent tickets
- [ ] Notification preferences per user
- [ ] Notification history archive
- [ ] Notification filtering by type
- [ ] Do not disturb mode with time settings
- [ ] Mobile push notifications
- [ ] Slack integration for team alerts

---

## 🐛 Troubleshooting

### Notifications Not Appearing
1. Check browser console for errors
2. Verify Supabase Realtime is enabled
3. Check that tables have new data being inserted
4. Verify notification bell appears in header

### Sound Not Playing
1. Check browser volume
2. Try different browser (some restrict audio)
3. Check browser console for Audio API errors
4. Sound disabled intentionally in settings

### Browser Notifications Not Working
1. Grant notification permission when prompted
2. Check OS notification settings
3. Verify browser is in focus when testing
4. Some browsers require HTTPS for notifications

---

## 📞 Support

For issues or feature requests, check:
- Browser console for error messages
- Supabase dashboard for Realtime subscription status
- Network tab to verify WebSocket connections
- Notification settings to ensure enabled

---

## 🎉 You're All Set!

The notification system is now active and monitoring your database for new orders, surveys, and support tickets. Real-time alerts will help you stay on top of customer requests!

