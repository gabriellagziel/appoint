# Business Registrations System Setup

This guide will help you set up the business registrations system for the App-Oint Enterprise API admin panel.

## 🚀 Features

- **Business Registration Form**: Public form for companies to register for API access
- **Admin Panel**: Review and approve/reject business registrations
- **Email Notifications**: Automatic emails for approvals and rejections
- **Firebase Integration**: Real-time data storage and retrieval

## 📋 Prerequisites

1. Firebase project with Firestore enabled
2. Node.js 18+ and npm/yarn
3. Admin panel already set up (Next.js with TypeScript)

## 🔧 Setup Instructions

### 1. Firebase Configuration

Create a `.env.local` file in the admin directory with your Firebase configuration:

```bash
# Firebase Configuration
NEXT_PUBLIC_FIREBASE_API_KEY=your_firebase_api_key_here
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=123456789
NEXT_PUBLIC_FIREBASE_APP_ID=1:123456789:web:abcdef123456

# Email Configuration (optional)
SENDGRID_API_KEY=your_sendgrid_api_key_here
SENDGRID_FROM_EMAIL=noreply@app-oint.com

# Admin Authentication
NEXTAUTH_SECRET=your_nextauth_secret_here
NEXTAUTH_URL=http://localhost:3000
```

### 2. Firestore Database Setup

Create the following collection in your Firestore database:

**Collection: `business_registrations`**

Document structure:

```json
{
  "companyName": "string",
  "contactName": "string", 
  "contactEmail": "string",
  "industry": "string",
  "employeeCount": "string",
  "useCase": "string",
  "phoneNumber": "string (optional)",
  "website": "string (optional)",
  "expectedVolume": "string (optional)",
  "status": "pending|approved|rejected",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "apiKey": "string (generated on approval)",
  "approvedAt": "timestamp (optional)",
  "approvedBy": "string (optional)",
  "rejectedAt": "timestamp (optional)",
  "rejectedBy": "string (optional)",
  "rejectionReason": "string (optional)"
}
```

### 3. Firestore Security Rules

Set up security rules for the `business_registrations` collection:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /business_registrations/{document} {
      // Allow read/write for authenticated admin users
      allow read, write: if request.auth != null && 
        request.auth.token.admin == true;
      
      // Allow public write for new registrations
      allow create: if true;
    }
  }
}
```

### 4. Install Dependencies

The Firebase dependency is already included in `package.json`. Run:

```bash
npm install
```

### 5. Start the Development Server

```bash
npm run dev
```

## 🎯 Usage

### For Businesses (Public)

1. Navigate to `/register-business.html`
2. Fill out the registration form
3. Submit the form
4. Wait for approval email

### For Admins

1. Navigate to `/admin/business/registrations`
2. Review pending registrations
3. Click "Approve" or "Reject" for each registration
4. System automatically sends email notifications

## 📧 Email Notifications

The system includes placeholder functions for email notifications. To implement:

1. **SendGrid Integration** (recommended):
   - Sign up for SendGrid
   - Add your API key to environment variables
   - Update the email functions in `business_registrations_service.ts`

2. **AWS SES Integration**:
   - Configure AWS SES
   - Update email functions to use SES SDK

3. **Custom Email Service**:
   - Implement your own email service
   - Update the email functions accordingly

## 🔐 Security Considerations

1. **Admin Authentication**: Ensure only authorized users can access the admin panel
2. **Rate Limiting**: Implement rate limiting on the registration API
3. **Input Validation**: All inputs are validated on both client and server
4. **API Key Security**: Generated API keys are secure and unique

## 🧪 Testing

### Test the Registration Flow

1. Start the development server
2. Navigate to `http://localhost:3000/register-business.html`
3. Fill out and submit the form
4. Check the admin panel at `http://localhost:3000/admin/business/registrations`
5. Approve or reject the registration
6. Verify email notifications (if configured)

### Test with Mock Data

The system includes mock data for testing. To use real Firebase data:

1. Set up Firebase configuration
2. Remove mock data from `fetchRegistrations()` function
3. Test with real Firestore data

## 🚀 Deployment

1. **Environment Variables**: Set all environment variables in production
2. **Firebase Rules**: Deploy Firestore security rules
3. **Email Service**: Configure production email service
4. **Build and Deploy**: Run `npm run build` and deploy

## 📁 File Structure

```
admin/
├── src/
│   ├── app/
│   │   ├── admin/
│   │   │   └── business/
│   │   │       └── registrations/
│   │   │           └── page.tsx          # Admin panel page
│   │   └── api/
│   │       └── business-registrations/
│   │           └── route.ts              # API endpoint
│   └── services/
│       └── business_registrations_service.ts  # Firebase service
├── public/
│   └── register-business.html            # Public registration form
└── BUSINESS_REGISTRATIONS_SETUP.md       # This file
```

## 🔄 Next Steps

1. **Email Integration**: Implement real email notifications
2. **Admin Authentication**: Add proper admin user management
3. **Analytics**: Add registration analytics and reporting
4. **Advanced Features**: Add bulk operations, search, filtering
5. **Audit Logs**: Implement comprehensive audit logging

## 🆘 Troubleshooting

### Common Issues

1. **Firebase Connection Error**: Check environment variables and Firebase project settings
2. **CORS Issues**: Ensure proper CORS configuration for API endpoints
3. **Email Not Sending**: Check email service configuration and API keys
4. **Admin Access Denied**: Verify Firestore security rules and admin authentication

### Debug Mode

Enable debug logging by adding to your environment:

```bash
DEBUG=true
```

This will show detailed logs for Firebase operations and API calls.

## 📞 Support

For issues or questions:

1. Check the Firebase console for errors
2. Review browser console for client-side errors
3. Check server logs for API errors
4. Verify environment variable configuration
