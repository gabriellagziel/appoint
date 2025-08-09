# Family Features - Post-Deployment Guide
## App Check Configuration

### Production Setup
1. Get reCAPTCHA Site Key from Google Console
2. Update main.dart with your Site Key
3. Deploy to production

### Development Setup
1. Get Debug Token from Firebase Console > App Check > Debug
2. Add token to Firebase Console
3. App Check will work in debug mode

## Environment Variables

### Running with dart-define
```bash
flutter run -d chrome --web-port=8080 --dart-define=RECAPTCHA_SITE_KEY=your_site_key_here
flutter build web --release --dart-define=RECAPTCHA_SITE_KEY=your_site_key_here
```
