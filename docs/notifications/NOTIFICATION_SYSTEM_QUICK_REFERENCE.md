# 🚀 Notification System Quick Reference

Fast reference guide for using and extending the notification system.

---

## 📌 Quick Start

### Using Notifications in Components

```tsx
import { useContext } from 'react';
import { NotificationContext } from '@/context/NotificationContext';

export function MyComponent() {
  const { addNotification } = useContext(NotificationContext);

  const handleClick = () => {
    addNotification({
      type: 'success',
      title: '✅ Success',
      message: 'Operation completed successfully',
      action: {
        label: 'View Details',
        href: '/dashboard/details'
      }
    });
  };

  return <button onClick={handleClick}>Click Me</button>;
}
```

---

## 🎨 Notification Types

```tsx
// Alert (Orange) - Important, persistent, with sound
addNotification({ type: 'alert', title: '⚠️ Alert', message: '...' });

// Success (Green) - Positive action result
addNotification({ type: 'success', title: '✅ Success', message: '...' });

// Error (Red) - Something went wrong
addNotification({ type: 'error', title: '❌ Error', message: '...' });

// Warning (Yellow) - Caution needed
addNotification({ type: 'warning', title: '⚠️ Warning', message: '...' });

// Info (Blue) - Informational only
addNotification({ type: 'info', title: 'ℹ️ Info', message: '...' });
```

---

## 🔔 Adding New Real-Time Events

### Step 1: Edit `useRealtimeNotifications.ts`

```tsx
// Add new subscription
const newTableChannel = supabase
  .channel('public:new_table')
  .on('postgres_changes', {
    event: 'INSERT',        // or 'UPDATE', 'DELETE'
    schema: 'public',
    table: 'new_table',
    filter: 'status=eq.PENDING'  // Optional filter
  }, (payload) => {
    // Handle event
    addNotification({
      type: 'alert',
      title: '🆕 New Item',
      message: `Item created: ${payload.new.name}`,
      action: {
        label: 'View',
        href: `/path/${payload.new.id}`
      }
    });
    
    // Trigger sound
    playSound();
    
    // Browser notification
    if (notificationsEnabled) {
      showBrowserNotification({
        title: '🆕 New Item',
        body: `Item created: ${payload.new.name}`
      });
    }
  })
  .subscribe();

// Add to cleanup
return () => {
  newTableChannel.unsubscribe();
};
```

---

## 🎯 Common Patterns

### Pattern 1: Navigate on Close

```tsx
const { addNotification } = useContext(NotificationContext);
const router = useRouter();

addNotification({
  type: 'success',
  title: 'Order Created',
  message: 'Order #001 created successfully',
  action: {
    label: 'View Order',
    href: `/dashboard/orders/123`
  }
});
```

### Pattern 2: Multiple Notifications

```tsx
// Show progress of multi-step operation
addNotification({ type: 'info', title: 'Starting...', message: 'Processing your request' });

setTimeout(() => {
  addNotification({ type: 'info', title: 'Step 1...', message: 'Validating data' });
}, 2000);

setTimeout(() => {
  addNotification({ 
    type: 'success', 
    title: 'Complete!', 
    message: 'All steps finished' 
  });
}, 4000);
```

### Pattern 3: Error Handling

```tsx
try {
  await deleteOrder(id);
  addNotification({
    type: 'success',
    title: 'Deleted',
    message: 'Order deleted successfully'
  });
} catch (error) {
  addNotification({
    type: 'error',
    title: 'Failed',
    message: error.message || 'Could not delete order'
  });
}
```

### Pattern 4: Conditional Notifications

```tsx
if (orderTotal > 50000) {
  addNotification({
    type: 'alert',
    title: '🚨 Large Order',
    message: `Order total: ₨${orderTotal}`,
    action: { label: 'Review', href: `/dashboard/orders/${id}` }
  });
} else {
  addNotification({
    type: 'success',
    title: 'Order Created',
    message: `Order #${orderNumber} created`
  });
}
```

---

## 🛠️ Extending the System

### Add Custom Sound

```tsx
// In NotificationContext.tsx
const playCustomSound = (frequency: number, duration: number) => {
  const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
  const oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();
  
  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);
  
  oscillator.frequency.value = frequency;
  gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
  gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + duration);
  
  oscillator.start(audioContext.currentTime);
  oscillator.stop(audioContext.currentTime + duration);
};

// Use different sounds for different types
if (type === 'alert') playCustomSound(800, 0.5);
if (type === 'success') playCustomSound(1000, 0.3);
if (type === 'error') playCustomSound(400, 0.5);
```

### Add Toast Position Options

```tsx
// In NotificationToast.tsx - modify position
const positionClasses = {
  'top-right': 'top-4 right-4',
  'top-left': 'top-4 left-4',
  'bottom-right': 'bottom-4 right-4',
  'bottom-left': 'bottom-4 left-4',
  'top-center': 'top-4 left-1/2 -translate-x-1/2',
};

// Use: <NotificationToast position="top-center" />
```

### Add Notification Persistence

```tsx
// In NotificationContext.tsx
useEffect(() => {
  // Save to localStorage
  localStorage.setItem('notifications', JSON.stringify(notifications));
}, [notifications]);

// Load from localStorage on mount
useEffect(() => {
  const saved = localStorage.getItem('notifications');
  if (saved) setNotifications(JSON.parse(saved));
}, []);
```

---

## 📊 API Reference

### NotificationContext Methods

```typescript
// Add notification to queue
addNotification(notification: Notification): void

// Remove specific notification
removeNotification(id: string): void

// Mark notification as read
markAsRead(id: string): void

// Get number of unread notifications
getUnreadCount(): number

// Clear all notifications
clearAll(): void

// Play sound alert
playSound(): void

// Request browser notification permission
requestBrowserPermission(): Promise<NotificationPermission>
```

### Notification Interface

```typescript
interface Notification {
  id: string;                    // Auto-generated UUID
  type: NotificationType;        // alert | success | error | warning | info
  title: string;                 // Main heading (max 50 chars)
  message: string;               // Detail message (max 200 chars)
  action?: {                     // Optional action button
    label: string;               // Button text
    href: string;                // Navigation URL
  };
  createdAt: Date;              // Auto-generated timestamp
  isRead: boolean;              // Read status
}

type NotificationType = 'alert' | 'success' | 'error' | 'warning' | 'info';
```

---

## 🎨 Styling Custom Notifications

### Change Toast Colors

```tsx
// In NotificationToast.tsx
const colorMap = {
  alert: 'bg-orange-500 border-orange-600',
  success: 'bg-green-500 border-green-600',
  error: 'bg-red-500 border-red-600',
  warning: 'bg-yellow-500 border-yellow-600',
  info: 'bg-blue-500 border-blue-600',
};

// Modify as needed
```

### Change Bell Icon

```tsx
// In NotificationBell.tsx
import { Bell, AlertCircle, MessageSquare } from 'lucide-react';

// Use different icon
<AlertCircle className="w-6 h-6" />
```

---

## 🔍 Debugging

### Check Notifications

```javascript
// In browser console
// See current notification context
const notificationContext = document.querySelector('[data-notification-context]');
console.log('Notifications:', notificationContext);
```

### Check Real-Time Connection

```javascript
// In browser console
supabase.getChannels().forEach(channel => {
  console.log('Channel:', channel.state);
});
```

### Monitor Subscriptions

```javascript
// In browser console
// See if subscriptions are active
const status = supabase.getChannels();
status.forEach(s => console.log(s.topic, s.state));
```

### Check Notification Permissions

```javascript
// In browser console
Notification.permission  // Returns: default | denied | granted
```

---

## 📋 Checklist for Adding New Event Type

- [ ] Add new subscription in `useRealtimeNotifications.ts`
- [ ] Define notification title with emoji
- [ ] Set appropriate notification type (alert, success, etc.)
- [ ] Add action button to navigate to detail page
- [ ] Test with browser console
- [ ] Add to NOTIFICATION_SYSTEM_TESTING.md
- [ ] Document in NOTIFICATION_SYSTEM_GUIDE.md

---

## ⚡ Performance Tips

1. **Limit notification history**: Only keep last 50 in dropdown
2. **Batch updates**: Group rapid notifications
3. **Debounce events**: Don't create notification for every micro-event
4. **Use filters**: Filter Supabase subscriptions to reduce events
5. **Cleanup subscriptions**: Unsubscribe when component unmounts

---

## 🔐 Security Notes

1. **Never expose secrets** in notifications
2. **Validate data** before creating notification
3. **Use href carefully** - prevent XSS
4. **RLS policies** protect subscription data
5. **HTTPS only** for browser notifications

---

## 📱 Mobile Considerations

- Toast height should account for mobile keyboard
- Bell dropdown might need full-height modal on small screens
- Touch-friendly button sizes (min 44px)
- Landscape/portrait handling
- Safe area insets for notch devices

---

## 🌍 Internationalization

### Add i18n Support

```tsx
// In NotificationToast.tsx
import { useTranslation } from 'next-i18next';

const { t } = useTranslation('notifications');

// In content
t('order.received', { orderNumber: '#001' })
```

---

## 🧪 Testing Patterns

### Test Adding Notification

```typescript
test('addNotification creates notification', () => {
  const { result } = renderHook(() => useContext(NotificationContext));
  
  act(() => {
    result.current.addNotification({
      type: 'success',
      title: 'Test',
      message: 'Message'
    });
  });
  
  expect(result.current.notifications).toHaveLength(1);
});
```

### Test Auto-Dismiss

```typescript
test('notification auto-dismisses after 5s', async () => {
  jest.useFakeTimers();
  // Add notification
  // Fast-forward 5 seconds
  // Verify removed
  jest.runAllTimers();
});
```

---

## 📚 Related Components

| Component | Purpose | Path |
|-----------|---------|------|
| NotificationContext | State management | src/context/ |
| NotificationToast | Toast display | src/components/ |
| NotificationBell | Dropdown menu | src/components/ |
| useRealtimeNotifications | Real-time listener | src/hooks/ |
| NotificationSettings | User preferences | src/components/ |

---

## 🆘 Common Errors

### "Cannot read property of undefined"
→ Check NotificationContext is provided in layout

### "Notifications not appearing"
→ Check NotificationToast component in layout

### "WebSocket connection failed"
→ Verify Supabase URL and API key

### "Sound not playing"
→ Check browser audio permissions + alert type

---

## 📞 Quick Links

- **Component Location**: `admin-web/src/`
- **Context API**: `src/context/NotificationContext.tsx`
- **Hook Location**: `src/hooks/useRealtimeNotifications.ts`
- **Test Guide**: `NOTIFICATION_SYSTEM_TESTING.md`
- **Full Guide**: `NOTIFICATION_SYSTEM_GUIDE.md`

---

## 🎓 Learning Resources

- [Supabase Realtime](https://supabase.com/docs/guides/realtime)
- [Web Notifications API](https://developer.mozilla.org/en-US/docs/Web/API/Notification)
- [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)
- [React Context](https://react.dev/learn/passing-data-deeply-with-context)
- [Next.js App Router](https://nextjs.org/docs/app)

---

## ✅ Checklist Before Production

- [ ] All tests pass (see NOTIFICATION_SYSTEM_TESTING.md)
- [ ] No console errors
- [ ] WebSocket connection stable
- [ ] Sound works on target devices
- [ ] Browser notifications requested
- [ ] RLS policies verified
- [ ] HTTPS enabled
- [ ] Performance acceptable
- [ ] Mobile responsive
- [ ] Accessibility checked (ARIA labels, keyboard nav)

---

**Last Updated**: Today
**Quick Reference Version**: 1.0
**Status**: ✅ Ready for Use

