# Production Deployment Guide

## 🚀 Deploying Business Registrations to Production

### Prerequisites

- Firebase project configured
- Environment variables set up
- Domain configured (e.g., api.app-oint.com)

### Step 1: Environment Variables

Set these in your production environment:

```bash
# Firebase Configuration
NEXT_PUBLIC_FIREBASE_API_KEY=your_production_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=123456789
NEXT_PUBLIC_FIREBASE_APP_ID=1:123456789:web:abcdef123456

# Email Configuration (Production)
SENDGRID_API_KEY=your_production_sendgrid_key
SENDGRID_FROM_EMAIL=noreply@app-oint.com
ADMIN_EMAIL=admin@app-oint.com

# NextAuth (if using)
NEXTAUTH_SECRET=your_production_secret
NEXTAUTH_URL=https://api.app-oint.com
```

### Step 2: Firestore Security Rules

Deploy these rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /business_registrations/{document} {
      // Allow public creation (for registrations)
      allow create: if true;
      
      // Allow read/write for authenticated admins
      allow read, write: if request.auth != null && 
        request.auth.token.admin == true;
    }
  }
}
```

### Step 3: Build and Deploy

#### Option A: Vercel (Recommended)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

#### Option B: DigitalOcean App Platform

1. Connect your GitHub repository
2. Set environment variables in DO dashboard
3. Deploy with automatic builds

#### Option C: Docker

```bash
# Build Docker image
docker build -t app-oint-admin .

# Run container
docker run -p 3000:3000 --env-file .env.local app-oint-admin
```

### Step 4: Domain Configuration

1. **Point domain to your deployment**
   - `api.app-oint.com` → Your deployment URL
   - `admin.api.app-oint.com` → Admin panel (optional)

2. **SSL Certificate**
   - Vercel: Automatic
   - DigitalOcean: Automatic with App Platform
   - Custom: Use Let's Encrypt

### Step 5: Testing Production

1. **Test Registration Form**

   ```
   https://api.app-oint.com/register-business.html
   ```

2. **Test Admin Panel**

   ```
   https://api.app-oint.com/admin/business/registrations
   ```

3. **Test API Endpoint**

   ```bash
   curl -X POST https://api.app-oint.com/api/business-registrations \
     -H "Content-Type: application/json" \
     -d '{"companyName":"Test Corp","contactName":"John Doe","contactEmail":"test@example.com","industry":"Technology","employeeCount":"10-50","useCase":"Testing"}'
   ```

### Step 6: Monitoring

1. **Firebase Console**
   - Monitor Firestore usage
   - Check for errors in Functions logs

2. **Application Monitoring**
   - Vercel Analytics
   - Sentry for error tracking
   - Uptime monitoring

3. **Email Monitoring**
   - SendGrid dashboard
   - Bounce rate monitoring
   - Delivery reports

### Step 7: Security Checklist

- [ ] Environment variables secured
- [ ] Firestore rules deployed
- [ ] HTTPS enabled
- [ ] Admin authentication configured
- [ ] Rate limiting implemented
- [ ] CORS configured properly
- [ ] API key generation secure
- [ ] Email templates reviewed

### Step 8: Go Live

1. **Final Testing**
   - Submit test registration
   - Approve/reject in admin panel
   - Verify email notifications

2. **Announcement**
   - Update documentation
   - Notify team
   - Monitor for issues

## 🔧 Troubleshooting

### Common Issues

1. **Firebase Connection Errors**
   - Check environment variables
   - Verify Firebase project settings
   - Check Firestore rules

2. **Email Not Sending**
   - Verify SendGrid API key
   - Check sender email verification
   - Review SendGrid logs

3. **Admin Access Issues**
   - Verify authentication setup
   - Check admin user permissions
   - Review Firestore security rules

### Support Contacts

- **Firebase Issues**: Firebase Console Support
- **SendGrid Issues**: SendGrid Support
- **Deployment Issues**: Platform-specific support
- **App-Oint Issues**: Internal team

## 📊 Post-Deployment

### Analytics to Monitor

1. **Registration Metrics**
   - Daily/weekly submissions
   - Conversion rates
   - Industry distribution

2. **Admin Activity**
   - Approval/rejection rates
   - Response times
   - Admin panel usage

3. **System Health**
   - API response times
   - Error rates
   - Email delivery rates

### Regular Maintenance

- Weekly: Review pending registrations
- Monthly: Update email templates
- Quarterly: Review security settings
- Annually: Audit system access
