# AppOint - Business CRM System

A comprehensive appointment booking and business management system with Flutter web app and Next.js dashboard.

## 🚀 Current Status: READY FOR BUSINESS USE

### ✅ What's Working

1. **Flutter Web App**
   - Complete business dashboard with real-time appointment management
   - Firebase integration for data persistence
   - Multi-language support (15+ languages)
   - Authentication with Google Sign-In
   - Real-time appointment tracking and statistics

2. **Next.js Dashboard (CRM)**
   - Modern, responsive business dashboard
   - Real Firebase data integration
   - Appointment management with CRUD operations
   - Status management (confirm/cancel appointments)
   - Authentication with NextAuth.js

3. **Backend Infrastructure**
   - Firebase Firestore with comprehensive security rules
   - User management and business profiles
   - Real-time data synchronization
   - Payment integration ready (Stripe)

## 🛠️ Setup Instructions

### Prerequisites
- Node.js 18+ 
- Flutter 3.8+
- Firebase project
- Google Cloud Console access

### 1. Flutter Web App Setup

```bash
# Install dependencies
flutter pub get

# Run web app
flutter run -d chrome

# Build for production
flutter build web
```

### 2. Next.js Dashboard Setup

```bash
cd dashboard

# Install dependencies
npm install

# Set up environment variables
cp .env.local.example .env.local
# Edit .env.local with your Firebase credentials

# Run development server
npm run dev

# Build for production
npm run build
```

### 3. Firebase Configuration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Firestore Database
3. Set up Authentication (Google Sign-In)
4. Update environment variables with your Firebase config

### 4. Production Deployment

#### Flutter Web
```bash
# Build for production
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

#### Next.js Dashboard
```bash
cd dashboard
npm run build
# Deploy to Vercel, Netlify, or your preferred hosting
```

## 📊 Features

### Business Dashboard
- **Appointment Management**: Create, edit, confirm, and cancel appointments
- **Client Management**: Track client information and appointment history
- **Real-time Statistics**: View appointment counts, revenue, and trends
- **Calendar Integration**: Google Calendar sync (ready for implementation)
- **Notifications**: Email and SMS notifications (ready for implementation)

### CRM Features
- **Multi-user Support**: Staff management and permissions
- **Analytics**: Business insights and reporting
- **Payment Processing**: Stripe integration ready
- **Mobile Responsive**: Works on all devices

## 🔧 Configuration

### Environment Variables

#### Flutter App
```bash
# Copy env.example to .env
cp env.example .env

# Update with your Firebase credentials
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_WEB_API_KEY=your-api-key
```

#### Next.js Dashboard
```bash
# dashboard/.env.local
NEXT_PUBLIC_FIREBASE_API_KEY=your-api-key
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your-project-id
NEXTAUTH_SECRET=your-secret
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd appoint
   ```

2. **Set up Firebase**
   - Create Firebase project
   - Enable Firestore and Authentication
   - Update environment variables

3. **Run the applications**
   ```bash
   # Flutter web app
   flutter run -d chrome
   
   # Next.js dashboard
   cd dashboard
   npm run dev
   ```

4. **Access the applications**
   - Flutter Web: http://localhost:8080
   - Dashboard: http://localhost:3000

## 📱 Business Features

### Appointment Management
- Create new appointments with customer details
- Set appointment status (pending, confirmed, cancelled)
- View appointment history and analytics
- Send notifications to customers

### Client Management
- Store customer information
- Track appointment history per client
- Manage client preferences and notes

### Business Analytics
- Monthly appointment statistics
- Revenue tracking
- Customer retention metrics
- Service popularity analysis

## 🔒 Security

- Firebase security rules implemented
- User authentication required
- Data access controlled by user roles
- Secure API endpoints

## 🎯 Next Steps for Full Production

1. **Complete Payment Integration**
   - Implement Stripe payment processing
   - Add invoice generation
   - Set up recurring payments

2. **Enhanced Notifications**
   - Email notifications for appointments
   - SMS reminders
   - Push notifications

3. **Advanced Features**
   - Calendar synchronization
   - Staff scheduling
   - Inventory management
   - Customer reviews and ratings

## 📞 Support

For technical support or questions about the business CRM system, please contact the development team.

---

**Status**: ✅ Ready for business use with core features implemented and tested.
