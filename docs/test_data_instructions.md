# Test Data Instructions for StudioBookingScreen

## Current Status ✅
The app is running successfully and connecting to Firestore! The logs show:
```
🔍 Fetching staff availability for studio: default-studio
📊 Received 0 slots from Firestore
```

This means the Firestore connection is working, but we need to add test data.

## Manual Test Data Setup

### 1. Go to Firebase Console
- Navigate to: https://console.firebase.google.com/project/app-oint-core
- Go to **Firestore Database**

### 2. Add Studio Slots
Create the following documents:

**Collection Path**: `studio/default-studio/staff_availability`

**Document 1**: `slot1`
```json
{
  "startTime": Timestamp(2024, 1, 15, 9, 0),
  "endTime": Timestamp(2024, 1, 15, 10, 0),
  "isBooked": false
}
```

**Document 2**: `slot2`
```json
{
  "startTime": Timestamp(2024, 1, 15, 10, 0),
  "endTime": Timestamp(2024, 1, 15, 11, 0),
  "isBooked": true
}
```

**Document 3**: `slot3`
```json
{
  "startTime": Timestamp(2024, 1, 15, 11, 0),
  "endTime": Timestamp(2024, 1, 15, 12, 0),
  "isBooked": false
}
```

### 3. Add Dashboard Test Data

**Collection**: `test`
**Document**: `sample1`
```json
{
  "name": "Hello from Firestore"
}
```

**Collection**: `bookings`
**Document**: `booking1`
```json
{
  "clientName": "John Doe",
  "service": "Photography",
  "date": "2024-01-15",
  "status": "confirmed"
}
```

## Expected Results
After adding the test data:
1. Dashboard should show "sample1" and "booking1"
2. StudioBookingScreen should show 3 slots with formatted times
3. "Book" buttons should be enabled for available slots
4. "Booked" button should be disabled for booked slots

## Firebase Configuration Status ✅
- ✅ Web app configured correctly
- ✅ API Key: REDACTED_TOKEN
- ✅ Project ID: app-oint-core
- ✅ Auth Domain: app-oint-core.firebaseapp.com
- ✅ Storage Bucket: app-oint-core.firebasestorage.app

## Authorized Domains
Make sure these are added in Firebase Console → Authentication → Sign-in method → Authorized domains:
- `localhost`
- `localhost:51159` (or whatever port your app is running on) 