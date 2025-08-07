# API Documentation

This document provides comprehensive documentation for all Cloud Function endpoints in the APP-OINT application.

## Table of Contents

1. [Authentication](#authentication)
2. [User Management](#user-management)
3. [Business Management](#business-management)
4. [Appointment Management](#appointment-management)
5. [Payment Processing](#payment-processing)
6. [Ambassador System](#ambassador-system)
7. [Analytics](#analytics)
8. [Admin Functions](#admin-functions)
9. [Error Handling](#error-handling)

## Authentication

All Cloud Functions require Firebase Authentication. The user's JWT token is automatically validated and the user information is available in the `context.auth` object.

### Authentication Context

```javascript
// Available in all functions
context.auth.uid          // User ID
context.auth.token        // JWT token claims
context.auth.token.role   // User role (if set)
context.auth.token.admin  // Admin flag (if set)
```

## User Management

### createUser

Creates a new user profile in Firestore.

**Endpoint**: `createUser`

**Authentication**: Required

**Parameters**:
```typescript
{
  email: string;
  displayName: string;
  phoneNumber?: string;
  businessId?: string;
  role?: 'user' | 'business_owner' | 'admin';
}
```

**Returns**:
```typescript
{
  success: boolean;
  userId: string;
  message: string;
}
```

**Example**:
```javascript
const functions = FirebaseFunctions.instance;
const createUser = functions.httpsCallable('createUser');

const result = await createUser({
  email: 'user@example.com',
  displayName: 'John Doe',
  phoneNumber: '+1234567890',
  role: 'user'
});
```

### updateUserProfile

Updates an existing user profile.

**Endpoint**: `updateUserProfile`

**Authentication**: Required (own profile or admin)

**Parameters**:
```typescript
{
  userId: string;
  updates: {
    displayName?: string;
    phoneNumber?: string;
    avatar?: string;
    preferences?: {
      notifications?: boolean;
      language?: string;
      timezone?: string;
    };
  };
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

### deleteUser

Deletes a user account and associated data.

**Endpoint**: `deleteUser`

**Authentication**: Required (own account or admin)

**Parameters**:
```typescript
{
  userId: string;
  reason?: string;
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

## Business Management

### createBusiness

Creates a new business profile.

**Endpoint**: `createBusiness`

**Authentication**: Required

**Parameters**:
```typescript
{
  name: string;
  description: string;
  address: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  contactInfo: {
    phone: string;
    email: string;
    website?: string;
  };
  businessHours: {
    [day: string]: {
      open: string;
      close: string;
      closed: boolean;
    };
  };
  services: Array<{
    name: string;
    duration: number;
    price: number;
    description?: string;
  }>;
  category: string;
  tags: string[];
}
```

**Returns**:
```typescript
{
  success: boolean;
  businessId: string;
  message: string;
}
```

### updateBusiness

Updates business information.

**Endpoint**: `updateBusiness`

**Authentication**: Required (business owner or admin)

**Parameters**:
```typescript
{
  businessId: string;
  updates: {
    name?: string;
    description?: string;
    address?: Address;
    contactInfo?: ContactInfo;
    businessHours?: BusinessHours;
    services?: Service[];
    category?: string;
    tags?: string[];
  };
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

### getBusinessDetails

Retrieves detailed business information.

**Endpoint**: `getBusinessDetails`

**Authentication**: Not required

**Parameters**:
```typescript
{
  businessId: string;
}
```

**Returns**:
```typescript
{
  business: Business;
  services: Service[];
  reviews: Review[];
  averageRating: number;
  totalReviews: number;
}
```

## Appointment Management

### createAppointment

Creates a new appointment booking.

**Endpoint**: `createAppointment`

**Authentication**: Required

**Parameters**:
```typescript
{
  businessId: string;
  serviceId: string;
  scheduledAt: string; // ISO 8601 date string
  customerId: string;
  notes?: string;
  customerInfo: {
    name: string;
    email: string;
    phone: string;
  };
}
```

**Returns**:
```typescript
{
  success: boolean;
  appointmentId: string;
  appointment: Appointment;
  message: string;
}
```

### updateAppointment

Updates appointment details.

**Endpoint**: `updateAppointment`

**Authentication**: Required (participant or admin)

**Parameters**:
```typescript
{
  appointmentId: string;
  updates: {
    scheduledAt?: string;
    status?: 'confirmed' | 'cancelled' | 'completed' | 'no_show';
    notes?: string;
  };
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

### cancelAppointment

Cancels an appointment.

**Endpoint**: `cancelAppointment`

**Authentication**: Required (participant or admin)

**Parameters**:
```typescript
{
  appointmentId: string;
  reason?: string;
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
  refundAmount?: number;
}
```

### getAvailableSlots

Retrieves available appointment slots for a business.

**Endpoint**: `getAvailableSlots`

**Authentication**: Not required

**Parameters**:
```typescript
{
  businessId: string;
  serviceId: string;
  date: string; // YYYY-MM-DD format
}
```

**Returns**:
```typescript
{
  slots: Array<{
    time: string;
    available: boolean;
    appointmentId?: string;
  }>;
}
```

## Payment Processing

### createPaymentIntent

Creates a Stripe payment intent for appointment booking.

**Endpoint**: `createPaymentIntent`

**Authentication**: Required

**Parameters**:
```typescript
{
  amount: number; // Amount in cents
  currency: string; // Default: 'usd'
  appointmentId: string;
  customerId: string;
}
```

**Returns**:
```typescript
{
  clientSecret: string;
  paymentIntentId: string;
  status: string;
}
```

### confirmPayment

Confirms a payment after 3D Secure authentication.

**Endpoint**: `confirmPayment`

**Authentication**: Required

**Parameters**:
```typescript
{
  paymentIntentId: string;
  appointmentId: string;
}
```

**Returns**:
```typescript
{
  success: boolean;
  status: string;
  message: string;
}
```

### processRefund

Processes a refund for a cancelled appointment.

**Endpoint**: `processRefund`

**Authentication**: Required (business owner or admin)

**Parameters**:
```typescript
{
  paymentIntentId: string;
  amount: number; // Amount to refund in cents
  reason: string;
}
```

**Returns**:
```typescript
{
  success: boolean;
  refundId: string;
  message: string;
}
```

## Ambassador System

### createAmbassador

Creates a new ambassador account.

**Endpoint**: `createAmbassador`

**Authentication**: Required (admin only)

**Parameters**:
```typescript
{
  userId: string;
  referralCode: string;
  quota: number;
  commissionRate: number;
}
```

**Returns**:
```typescript
{
  success: boolean;
  ambassadorId: string;
  message: string;
}
```

### trackReferral

Tracks a referral made by an ambassador.

**Endpoint**: `trackReferral`

**Authentication**: Required

**Parameters**:
```typescript
{
  referralCode: string;
  customerId: string;
  appointmentId: string;
}
```

**Returns**:
```typescript
{
  success: boolean;
  referralId: string;
  commission: number;
  message: string;
}
```

### getAmbassadorStats

Retrieves ambassador statistics and earnings.

**Endpoint**: `getAmbassadorStats`

**Authentication**: Required (ambassador or admin)

**Parameters**:
```typescript
{
  ambassadorId: string;
  period?: 'week' | 'month' | 'year';
}
```

**Returns**:
```typescript
{
  totalReferrals: number;
  totalEarnings: number;
  periodEarnings: number;
  quotaUsed: number;
  quotaRemaining: number;
  referrals: Referral[];
}
```

## Analytics

### getBusinessAnalytics

Retrieves analytics data for a business.

**Endpoint**: `getBusinessAnalytics`

**Authentication**: Required (business owner or admin)

**Parameters**:
```typescript
{
  businessId: string;
  period: 'week' | 'month' | 'year';
  startDate?: string;
  endDate?: string;
}
```

**Returns**:
```typescript
{
  totalAppointments: number;
  totalRevenue: number;
  averageRating: number;
  customerCount: number;
  popularServices: Array<{
    serviceId: string;
    name: string;
    bookings: number;
    revenue: number;
  }>;
  timeSeriesData: Array<{
    date: string;
    appointments: number;
    revenue: number;
  }>;
}
```

### getSystemAnalytics

Retrieves system-wide analytics (admin only).

**Endpoint**: `getSystemAnalytics`

**Authentication**: Required (admin only)

**Parameters**:
```typescript
{
  period: 'week' | 'month' | 'year';
  startDate?: string;
  endDate?: string;
}
```

**Returns**:
```typescript
{
  totalUsers: number;
  totalBusinesses: number;
  totalAppointments: number;
  totalRevenue: number;
  userGrowth: number;
  businessGrowth: number;
  appointmentGrowth: number;
  revenueGrowth: number;
  topBusinesses: Array<{
    businessId: string;
    name: string;
    appointments: number;
    revenue: number;
  }>;
}
```

## Admin Functions

### setAdminRole

Assigns admin role to a user.

**Endpoint**: `setAdminRole`

**Authentication**: Required (super admin only)

**Parameters**:
```typescript
{
  uid: string;
  role: 'admin' | 'super_admin' | 'moderator';
  permissions: string[];
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

### suspendUser

Suspends a user account.

**Endpoint**: `suspendUser`

**Authentication**: Required (admin only)

**Parameters**:
```typescript
{
  userId: string;
  reason: string;
  duration?: number; // Duration in days
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

### unsuspendUser

Reactivates a suspended user account.

**Endpoint**: `unsuspendUser`

**Authentication**: Required (admin only)

**Parameters**:
```typescript
{
  userId: string;
}
```

**Returns**:
```typescript
{
  success: boolean;
  message: string;
}
```

### generateReport

Generates a system report.

**Endpoint**: `generateReport`

**Authentication**: Required (admin only)

**Parameters**:
```typescript
{
  reportType: 'users' | 'businesses' | 'appointments' | 'revenue' | 'ambassadors';
  format: 'csv' | 'pdf' | 'json';
  filters?: {
    startDate?: string;
    endDate?: string;
    businessId?: string;
    userId?: string;
  };
}
```

**Returns**:
```typescript
{
  success: boolean;
  reportUrl: string;
  expiresAt: string;
  message: string;
}
```

## Error Handling

All Cloud Functions return standardized error responses using Firebase Functions HttpsError.

### Error Types

- `unauthenticated`: User not authenticated
- `permission-denied`: Insufficient permissions
- `invalid-argument`: Invalid input parameters
- `not-found`: Resource not found
- `already-exists`: Resource already exists
- `resource-exhausted`: Rate limit exceeded
- `internal`: Server error

### Error Response Format

```typescript
{
  code: string;
  message: string;
  details?: any;
}
```

### Example Error Handling

```javascript
try {
  const result = await functionCall(data);
  return result;
} catch (error) {
  if (error.code === 'permission-denied') {
    // Handle permission error
    throw new functions.https.HttpsError(
      'permission-denied',
      'You do not have permission to perform this action'
    );
  }
  
  if (error.code === 'invalid-argument') {
    // Handle validation error
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid input parameters',
      error.details
    );
  }
  
  // Handle unexpected errors
  console.error('Unexpected error:', error);
  throw new functions.https.HttpsError(
    'internal',
    'An unexpected error occurred'
  );
}
```

## Rate Limiting

All functions are subject to rate limiting:

- **Standard users**: 100 requests per minute
- **Business owners**: 500 requests per minute
- **Admins**: 1000 requests per minute
- **Super admins**: 2000 requests per minute

Rate limit headers are included in responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

## Testing

### Local Testing

```bash
# Start Firebase emulator
firebase emulators:start

# Test function locally
firebase functions:shell
```

### Unit Testing

```javascript
// Example test for createUser function
describe('createUser', () => {
  it('should create user successfully', async () => {
    const wrapped = testEnv.wrap(createUser);
    const data = {
      email: 'test@example.com',
      displayName: 'Test User'
    };
    
    const result = await wrapped(data, { auth: { uid: 'test-uid' } });
    
    expect(result.data.success).toBe(true);
    expect(result.data.userId).toBeDefined();
  });
});
```

## Security Considerations

1. **Input Validation**: All inputs are validated using Zod schemas
2. **Authentication**: All functions require valid Firebase Auth tokens
3. **Authorization**: Role-based access control for admin functions
4. **Rate Limiting**: Prevents abuse and ensures fair usage
5. **Audit Logging**: All admin actions are logged for security
6. **Data Sanitization**: User inputs are sanitized to prevent injection attacks

## Monitoring

All functions include comprehensive logging and monitoring:

- **Function execution time**
- **Memory usage**
- **Error rates**
- **Success rates**
- **Custom metrics**

Logs can be viewed in Firebase Console or exported to external monitoring systems.

## Support

For API support or questions:

1. Check the [Firebase Functions documentation](https://firebase.google.com/docs/functions)
2. Review function logs in Firebase Console
3. Create an issue in the repository
4. Contact the development team

---

**Last Updated**: December 2024
**Version**: 1.0.0 