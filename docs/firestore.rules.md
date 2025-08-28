# Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() { return request.auth != null; }
    function isSelf(uid) { return request.auth.uid == uid; }

    match /users/{uid} {
      allow read, write: if isSelf(uid);
    }

    match /{coll=meetings|reminders|groups|family}/{id} {
      allow read, write: if isSignedIn() && request.auth.uid == request.resource.data.createdBy;
    }
  }
}
```

## Usage

1. Copy these rules to your Firebase Console
2. Go to Firestore Database → Rules
3. Replace existing rules with the above
4. Click "Publish"

## Security Model

- **Users**: Can only access their own user document
- **Meetings/Reminders**: Users can only access items they created
- **Authentication**: All operations require valid auth token
- **Data Ownership**: `createdBy` field must match authenticated user ID
