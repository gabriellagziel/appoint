# B2B API Usage-Based Billing Implementation

## Overview
This implementation removes Stripe dependencies from the B2B API layer and introduces a usage-based billing system for map API calls, with automatic invoice generation and API key suspension for non-payment.

## Key Changes Made

### 1. Removed Stripe Dependencies
- **File:** `lib/features/studio_business/screens/business_subscription_screen.dart`
  - Removed Stripe checkout session creation
  - Replaced with B2B API management interface
  - Added usage-based billing information display

- **File:** `lib/services/business_subscription_service.dart`
  - Removed all Stripe service calls
  - Implemented B2B API key management
  - Added usage tracking and invoice management methods

- **File:** `lib/features/studio_business/providers/business_subscription_provider.dart`
  - Updated to work with new API-based billing system
  - Added providers for API usage tracking

### 2. Implemented Usage-Based Billing System

#### Cloud Functions (`functions/src/businessApi.ts`)
- **New Collections:**
  - `b2bApiKeys`: Stores business API keys with usage tracking
  - `usage_logs`: Detailed usage logs for all API calls
  - `invoices`: Monthly invoices for map usage charges

- **New Functions:**
  - `generateBusinessApiKey`: Creates API keys for authenticated businesses
  - `recordApiUsage`: Tracks API usage and identifies map calls
  - `generateMonthlyInvoice`: Creates invoices for map usage (€0.007 per call)
  - `checkOverdueInvoices`: Scheduled function to suspend overdue accounts

#### Map API Charging
- Map endpoint calls (`/getMap`, `/map/*`) are charged €0.007 per request
- Standard API calls are included in monthly quota (1000 calls/month)
- Real-time usage tracking with automatic counter updates

#### Invoice & Payment System
- Monthly invoice generation for map usage
- 7-day payment terms with automatic suspension
- PDF invoice generation capability
- Manual payment marking for admin users

### 3. API Key Management
- **Registration:** Self-service business registration with API key generation
- **Suspension:** Automatic suspension for overdue payments
- **Reactivation:** Manual reactivation after payment
- **Usage Tracking:** Real-time quota and map usage monitoring

### 4. New API Endpoints
- `POST /registerBusiness`: Self-service business registration
- `GET /getMap`: Map data retrieval (charged per use)
- `GET /usage/stats`: Usage statistics and billing information
- `POST /appointments/create`: Appointment creation (quota-based)
- `POST /appointments/cancel`: Appointment cancellation (quota-based)

### 5. Security & Validation
- API key validation middleware
- Quota enforcement
- Status checking (active/suspended)
- Request logging and audit trail

### 6. Scheduled Tasks
- **Monthly Quota Reset:** Resets API quotas on the 1st of each month
- **Overdue Invoice Check:** Daily check for overdue invoices with automatic suspension

### 7. Router Updates
- Added `/app.business` route for CRM clients only
- Maintains separation between API clients and CRM users

### 8. Internationalization
Added new i18n keys:
- `manageApiAccess`: "Manage API Access"
- `apiQuota`: "API Quota"
- `mapUsageCharges`: "Map Usage Charges"
- `viewApiKeys`: "View API Keys"
- `businessApiManagement`: "Business API Management"

### 9. Test Coverage
- Created comprehensive test suite for business API functions
- Mock Firestore operations for testing
- Coverage for API key generation, usage recording, and invoice generation

## Data Models

### B2B API Key Document
```typescript
{
  businessId: string,
  apiKey: string,
  quotaRemaining: number,
  mapUsageCount: number,
  status: 'active' | 'suspended',
  createdAt: Timestamp,
  lastUsedAt: Timestamp,
  suspensionReason?: string
}
```

### Usage Log Document
```typescript
{
  businessId: string,
  apiKey: string,
  endpoint: string,
  isMapCall: boolean,
  success: boolean,
  timestamp: Timestamp,
  ip?: string,
  latencyMs?: number
}
```

### Invoice Document
```typescript
{
  id: string,
  businessId: string,
  type: 'map_usage',
  periodStart: Date,
  periodEnd: Date,
  mapCallCount: number,
  costPerCall: number,
  totalAmount: number,
  currency: 'EUR',
  status: 'pending' | 'paid' | 'overdue',
  dueDate: Date,
  createdAt: Timestamp
}
```

## Billing Logic

### Map Usage Charges
- Rate: €0.007 per map API call
- Billing cycle: Monthly
- Payment terms: 7 days
- Currency: EUR

### API Quotas
- Standard quota: 1,000 calls/month
- Map calls: Charged separately, unlimited
- Reset: 1st of each month at midnight UTC

### Suspension Policy
- Automatic suspension 7 days after invoice due date
- API calls rejected with 402 Payment Required status
- Manual reactivation after payment confirmation

## Integration Points

### Frontend Integration
- B2B API management dashboard
- Usage statistics display
- Invoice viewing capability
- API key management interface

### Backend Integration
- Cloud Functions for all billing operations
- Firestore for data persistence
- Scheduled functions for automation
- Express middleware for API validation

## Migration Notes

### From Stripe to Usage-Based Billing
1. Existing business subscriptions are converted to API access records
2. Stripe payment methods are no longer used for B2B clients
3. Manual invoicing replaces automated Stripe billing
4. Customer portal functionality removed for B2B clients

### Deployment Considerations
1. Deploy Cloud Functions first to ensure backend availability
2. Update frontend routes and UI components
3. Migrate existing business data to new collections
4. Set up scheduled function monitoring

## Testing

### Unit Tests
- Business API function testing with mocked Firestore
- API key generation and validation
- Usage recording and billing calculations
- Invoice generation and overdue detection

### Integration Testing
- End-to-end API workflow testing
- Payment and suspension flow validation
- Usage tracking accuracy verification

This implementation provides a complete usage-based billing system for B2B API clients, with proper separation from individual user Stripe billing and comprehensive monitoring and management capabilities.