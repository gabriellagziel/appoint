# Firebase Setup for Business Registrations

## 🔥 Quick Setup (5 minutes)

### Step 1: Get Firebase Config

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create/Select your project
3. Go to Project Settings → General → Your Apps
4. Click "Add app" → Web app
5. Copy the config object

### Step 2: Create Environment File

Create `admin/.env.local`:

```bash
# Firebase Configuration
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key_here
REDACTED_TOKEN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
REDACTED_TOKEN=your_project.appspot.com
REDACTED_TOKEN=123456789
NEXT_PUBLIC_FIREBASE_APP_ID=1:123456789:web:abcdef123456

# Optional: Email Service
SENDGRID_API_KEY=your_sendgrid_key_here
SENDGRID_FROM_EMAIL=noreply@app-oint.com
```

### Step 3: Enable Firestore

1. In Firebase Console → Firestore Database
2. Click "Create Database"
3. Choose "Start in test mode" (we'll secure it later)
4. Select a location close to your users

### Step 4: Test the System

```bash
# Start the dev server
npm run dev

# Test the API
node test-registrations.js

# Visit the forms
# Registration: http://localhost:3000/register-business.html
# Admin: http://localhost:3000/admin/business/registrations
```

## 🔐 Security Rules (Production)

Once testing works, update Firestore rules:

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

## 🚀 Production Deployment

1. **Set environment variables** in your hosting platform
2. **Deploy Firestore rules** from Firebase Console
3. **Test the full workflow** before going live

## 📞 Need Help?

- Check browser console for errors
- Verify Firebase config in `.env.local`
- Ensure Firestore is enabled
- Test with `node test-registrations.js`
