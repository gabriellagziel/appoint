# 🔥 Firebase Setup Instructions

## 📋 שלב 1: יצירת Firebase Project

1. **היכנס ל-[Firebase Console](https://console.firebase.google.com/)**
2. **צור פרויקט חדש:**
   - שם: `app-oint-business-studio`
   - אפשר Google Analytics (אופציונלי)
   - בחר את האזור הקרוב אליך

## 📋 שלב 2: הגדרת Authentication

1. **בחר "Authentication" בסרגל הצד**
2. **לך ל-"Sign-in method"**
3. **הפעל "Email/Password"**
4. **שמור את ההגדרות**

## 📋 שלב 3: הגדרת Firestore Database

1. **בחר "Firestore Database" בסרגל הצד**
2. **לחץ "Create database"**
3. **בחר "Start in test mode" (לפיתוח)**
4. **בחר את האזור הקרוב אליך**

## 📋 שלב 4: הגדרת Security Rules

### Firestore Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /appointments/{appointmentId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.businessId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.businessId;
    }
    
    // Allow users to read their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId;
    }
  }
}
```

## 📋 שלב 5: קבלת Firebase Config

1. **לך ל-"Project settings" (הגלגל)**
2. **בחר "General" tab**
3. **גלול למטה ל-"Your apps"**
4. **לחץ על סמל ה-Web (</>)**
5. **תן שם לאפליקציה: `app-oint-dashboard`**
6. **העתק את ה-config**

## 📋 שלב 6: הגדרת Environment Variables

צור קובץ `.env.local` בתיקיית `dashboard/`:

```env
# Firebase Configuration
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key_here
REDACTED_TOKEN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
REDACTED_TOKEN=your_project.appspot.com
REDACTED_TOKEN=123456789
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id

# App Configuration
NEXT_PUBLIC_APP_NAME=App-Oint Business Studio
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## 📋 שלב 7: בדיקת ההתחברות

1. **התקן dependencies:**
   ```bash
   cd dashboard
   npm install
   ```

2. **הפעל את השרת:**
   ```bash
   npm run dev
   ```

3. **בדוק את האפליקציה:**
   - היכנס ל-`http://localhost:3000/login`
   - נסה ליצור חשבון חדש
   - נסה להתחבר

## 📋 שלב 8: יצירת נתוני Test

### יצירת משתמש Test:

1. **היכנס ל-Firebase Console**
2. **לך ל-Authentication > Users**
3. **לחץ "Add user"**
4. **הזן email ו-password**

### יצירת פגישה Test:

1. **היכנס ל-Firestore Database**
2. **צור collection חדש: `appointments`**
3. **הוסף document חדש:**

```json
{
  "customerName": "John Doe",
  "customerEmail": "john@example.com",
  "customerPhone": "+1234567890",
  "service": "Consultation",
  "date": "2025-01-15",
  "time": "10:00",
  "duration": 60,
  "status": "pending",
  "businessId": "YOUR_USER_UID",
  "createdAt": "2025-01-01T00:00:00Z",
  "updatedAt": "2025-01-01T00:00:00Z"
}
```

## 🚨 Troubleshooting

### בעיות נפוצות:

1. **"Firebase: Error (auth/user-not-found)"**
   - וודא שהמשתמש קיים ב-Authentication
   - בדוק את ה-email וה-password

2. **"Firebase: Error (auth/invalid-api-key)"**
   - בדוק שה-API key נכון ב-.env.local
   - וודא שה-environment variables נטענות

3. **"Firebase: Error (permission-denied)"**
   - בדוק את ה-Security Rules
   - וודא שה-businessId נכון

4. **"Firebase: Error (app/no-app)"**
   - וודא שה-Firebase config נכון
   - בדוק שה-initialization עובד

## 📞 Support

אם יש בעיות:
1. בדוק את ה-console ב-browser
2. בדוק את ה-logs ב-Firebase Console
3. וודא שכל ה-environment variables נכונים
4. בדוק שה-Security Rules מוגדרות נכון
