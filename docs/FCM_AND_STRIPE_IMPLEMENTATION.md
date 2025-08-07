# FCM Push Notifications & Stripe In-App Billing Implementation

## Overview
This document outlines the complete implementation of Firebase Cloud Messaging (FCM) push notifications and Stripe in-app billing for the APP-OINT application.

## 🔔 FCM Push Notifications Implementation

### 1. Service Worker (`web/firebase-messaging-sw.js`)
- **Purpose**: Handles background notifications when the app is not active
- **Features**:
  - Background message handling
  - Notification click handling
  - Proper notification display with icons and badges
  - Navigation to bookings page on click

### 2. Web Configuration (`web/index.html`)
- **Added**: Firebase messaging scripts
- **Added**: Service worker registration
- **Added**: Firebase initialization for messaging

### 3. Flutter FCM Service (`lib/services/fcm_service.dart`)
- **Features**:
  - Permission request handling
  - FCM token generation and storage
  - Token refresh handling
  - Foreground message handling with SnackBar
  - Background/terminated app message handling
  - Navigation to bookings on notification tap
  - Firestore integration for token storage

### 4. Main App Integration (`lib/main.dart`)
- **Added**: FCM service initialization
- **Added**: Global navigator key for notification navigation
- **Added**: Firebase initialization

### 5. Cloud Function (`functions/src/index.ts`)
- **Function**: `onNewBooking`
  - Triggers on new booking creation
  - Retrieves studio's FCM token
  - Sends notification with booking details
  - Handles multiple platforms (Web, Android, iOS)
- **Function**: `sendNotificationToStudio`
  - Manual notification sending
  - Error handling and validation

## 💳 Stripe In-App Billing Implementation

### 1. Dependencies
- **Added**: `webview_flutter: ^4.7.0` to `pubspec.yaml`
- **Existing**: `flutter_stripe: ^11.5.0`

### 2. Stripe Service (`lib/services/stripe_service.dart`)
- **Features**:
  - Checkout session creation
  - Session confirmation
  - Subscription status management
  - Firestore integration
  - Error handling and retry logic

### 3. Subscription Screen (`lib/features/billing/screens/subscription_screen.dart`)
- **Features**:
  - WebView integration for Stripe checkout
  - Plan information display
  - Loading and error states
  - Success/cancel handling
  - Navigation and user feedback

### 4. Cloud Functions (`functions/src/stripe.ts`)
- **Functions**:
  - `createCheckoutSession`: Creates Stripe checkout sessions
  - `confirmSession`: Confirms completed sessions
  - `handleCheckoutSessionCompleted`: Webhook handler
  - `cancelSubscription`: Cancels subscriptions
  - Subscription lifecycle management

## 🚀 Setup Instructions

### FCM Setup
1. **Firebase Console**:
   - Enable Cloud Messaging
   - Generate web app configuration
   - Set up FCM API key

2. **Environment Variables**:
   ```bash
   # Add to your environment
   FIREBASE_MESSAGING_SENDER_ID=944776470711
   ```

3. **Deploy Cloud Functions**:
   ```bash
   cd functions
   npm install
   firebase deploy --only functions
   ```

### Stripe Setup
1. **Stripe Dashboard**:
   - Create products and prices
   - Set up webhook endpoints
   - Configure success/cancel URLs

2. **Environment Variables**:
   ```bash
   # Add to Firebase Functions config
   firebase functions:config:set stripe.secret_key="sk_test_your_key"
   firebase functions:config:set stripe.webhook_secret="whsec_your_webhook_secret"
   ```

3. **Update Stripe Service**:
   - Replace `publishableKey` in `stripe_service.dart`
   - Update `functionsBaseUrl` if using different region

## 📱 Usage Examples

### Sending FCM Notification
```dart
// The notification is automatically sent when a new booking is created
// Manual notification sending:
await FirebaseFunctions.instance
    .httpsCallable('sendNotificationToStudio')
    .call({
      'studioId': 'studio123',
      'title': 'New Booking',
      'body': 'Client John booked a session',
    });
```

### Creating Stripe Subscription
```dart
// Navigate to subscription screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SubscriptionScreen(
      studioId: 'studio123',
      priceId: 'price_12345',
      planName: 'Premium Plan',
      price: 29.99,
    ),
  ),
);
```

## 🔧 Configuration

### FCM Configuration
- **Web**: Service worker handles background notifications
- **Android**: Requires `google-services.json` configuration
- **iOS**: Requires `GoogleService-Info.plist` configuration

### Stripe Configuration
- **Webhook URL**: `https://us-central1-app-oint-core.cloudfunctions.net/handleCheckoutSessionCompleted`
- **Success URL**: `https://app-oint-core.web.app?session_id={CHECKOUT_SESSION_ID}`
- **Cancel URL**: `https://app-oint-core.web.app`

## 🧪 Testing

### FCM Testing
1. Create a new booking in Firestore
2. Check Firebase Functions logs for notification sending
3. Verify notification appears on device
4. Test notification tap navigation

### Stripe Testing
1. Use Stripe test mode
2. Create test products and prices
3. Test checkout flow with test cards
4. Verify webhook handling
5. Check Firestore subscription status updates

## 📊 Monitoring

### FCM Monitoring
- Firebase Console > Cloud Messaging
- Firebase Functions logs
- Browser console for web notifications

### Stripe Monitoring
- Stripe Dashboard > Events
- Firebase Functions logs
- Firestore subscription status

## 🔒 Security Considerations

### FCM Security
- FCM tokens are stored securely in Firestore
- Notifications are sent only to authenticated users
- Proper error handling prevents token exposure

### Stripe Security
- Secret keys are stored in Firebase Functions config
- Webhook signature verification
- Proper CORS configuration
- Input validation and sanitization

## 🐛 Troubleshooting

### Common FCM Issues
1. **Notifications not appearing**: Check browser permissions
2. **Token not saved**: Verify Firestore write permissions
3. **Background notifications**: Ensure service worker is registered

### Common Stripe Issues
1. **Checkout not loading**: Verify publishable key
2. **Webhook failures**: Check signature verification
3. **Subscription not updating**: Verify Firestore permissions

## 📈 Future Enhancements

### FCM Enhancements
- Topic-based notifications
- Rich notifications with images
- Notification preferences
- Analytics tracking

### Stripe Enhancements
- Multiple payment methods
- Subscription management UI
- Usage-based billing
- Invoice generation

## 📝 Notes

- All implementations follow Flutter and Firebase best practices
- Error handling is comprehensive with user feedback
- Code is production-ready with proper security measures
- Both features are fully integrated with existing app architecture 