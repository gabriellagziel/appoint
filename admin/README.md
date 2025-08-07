# App-Oint Admin Panel

A comprehensive admin panel for managing the App-Oint platform, built with Next.js, TypeScript, and Firebase.

## Features

- **User Management**: View, edit, and manage user accounts
- **Business Management**: Monitor business accounts and subscription plans
- **Payment Tracking**: Track transactions and manage refunds
- **Analytics Dashboard**: Real-time analytics and performance metrics
- **Security Monitoring**: Monitor security threats and abuse reports
- **Flag Management**: Review and handle content/user flags
- **Real-time Data**: All data is fetched from Firebase Firestore

## Tech Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS, Radix UI components
- **Backend**: Firebase (Firestore, Auth)
- **Charts**: Recharts
- **Authentication**: NextAuth.js

## Prerequisites

- Node.js 18+
- npm or yarn
- Firebase project with Firestore enabled

## Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd admin
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Set up environment variables**

   ```bash
   cp env.example .env.local
   ```

   Edit `.env.local` with your Firebase configuration:

   ```env
   NEXT_PUBLIC_FIREBASE_API_KEY=your_firebase_api_key
   NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
   NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
   NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
   NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=123456789
   NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
   
   NEXTAUTH_URL=http://localhost:3000
   NEXTAUTH_SECRET=your_nextauth_secret
   ```

4. **Set up Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Firestore Database
   - Create the following collections:
     - `users`
     - `businesses`
     - `payments`
     - `security_events`
     - `abuse_reports`
     - `flags`

5. **Run the development server**

   ```bash
   npm run dev
   ```

6. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## Firebase Collections Structure

### Users Collection

```typescript
{
  id: string,
  name: string,
  email: string,
  phone?: string,
  role: 'user' | 'admin' | 'moderator' | 'business',
  status: 'active' | 'inactive' | 'suspended',
  type: 'mobile' | 'business',
  createdAt: Date,
  lastActive: Date,
  profileImage?: string,
  businessId?: string
}
```

### Businesses Collection

```typescript
{
  id: string,
  name: string,
  owner: string,
  email: string,
  plan: 'basic' | 'premium' | 'enterprise',
  status: 'active' | 'suspended' | 'pending',
  employees: number,
  locations: number,
  monthlyRevenue: number,
  joinedAt: Date,
  lastActive: Date,
  businessId?: string,
  phone?: string,
  address?: string,
  industry?: string
}
```

### Payments Collection

```typescript
{
  id: string,
  transactionId: string,
  businessName: string,
  customerName: string,
  amount: number,
  currency: string,
  status: 'completed' | 'pending' | 'failed' | 'refunded',
  method: 'credit_card' | 'paypal' | 'bank_transfer' | 'stripe',
  date: Date,
  fee: number,
  netAmount: number,
  businessId?: string,
  customerId?: string,
  description?: string,
  receiptUrl?: string
}
```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm run test` - Run tests
- `npm run test:watch` - Run tests in watch mode

## Project Structure

```
admin/
├── src/
│   ├── app/                    # Next.js app directory
│   │   ├── admin/             # Admin pages
│   │   │   ├── users/         # User management
│   │   │   ├── business/      # Business management
│   │   │   ├── payments/      # Payment tracking
│   │   │   ├── analytics/     # Analytics dashboard
│   │   │   ├── security/      # Security monitoring
│   │   │   └── flags/         # Flag management
│   │   ├── api/               # API routes
│   │   └── auth/              # Authentication pages
│   ├── components/            # Reusable components
│   │   ├── ui/               # UI components
│   │   └── ...               # Other components
│   ├── services/             # Firebase services
│   │   ├── users_service.ts
│   │   ├── business_service.ts
│   │   ├── payments_service.ts
│   │   ├── analytics_service.ts
│   │   ├── security_service.ts
│   │   └── flags_service.ts
│   ├── lib/                  # Utilities
│   │   ├── firebase.ts       # Firebase configuration
│   │   └── utils.ts          # Utility functions
│   └── types/                # TypeScript types
├── public/                   # Static assets
├── test/                     # Test files
└── ...                       # Configuration files
```

## Features Overview

### User Management

- View all users with filtering and search
- Update user roles and status
- Delete users (soft delete)
- View user statistics

### Business Management

- Monitor business accounts
- Track subscription plans
- View revenue statistics
- Manage business status

### Payment Tracking

- View all transactions
- Process refunds
- Track payment statistics
- Filter by status and method

### Analytics Dashboard

- Real-time user growth charts
- Revenue tracking
- Geographic distribution
- Performance metrics

### Security Monitoring

- Monitor security events
- Handle abuse reports
- Block suspicious users
- Track threat statistics

### Flag Management

- Review content and user flags
- Assign flags to admins
- Resolve or dismiss flags
- Track flag statistics

## Security Features

- **Authentication**: NextAuth.js integration
- **Authorization**: Role-based access control
- **Data Validation**: TypeScript interfaces
- **Error Handling**: Comprehensive error handling
- **Loading States**: User-friendly loading indicators

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please contact the development team or create an issue in the repository.
