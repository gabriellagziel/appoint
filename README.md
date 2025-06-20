# Appoint

Appointment scheduling app built with Flutter with advanced features including Ambassador program, real-time analytics, and responsive design.

## Features

### Core Functionality
- Appointment scheduling and management
- Real-time notifications
- Multi-language support
- Family account management
- Business dashboard with analytics

### Ambassador Program
- **Ambassador Onboarding**: Complete registration flow with form validation and Firestore integration
- **Ambassador Dashboard**: Real-time analytics with interactive charts using `fl_chart`
- **Referral Tracking**: Monitor referrals and earnings with live data
- **Share Integration**: WhatsApp sharing and link copying functionality

### Technical Highlights
- **Responsive Design**: Filter rows wrap or become horizontally scrollable on small screens
- **Real-time Data**: Live Firestore integration with fallback to mock data
- **Interactive Charts**: Beautiful bar charts for ambassador statistics
- **State Management**: Riverpod providers for efficient data flow
- **Form Validation**: Comprehensive validation with user-friendly error messages

## Setup

1. **Flutter version**  
   Ensure you have Flutter 3.3+ installed.

2. **Dependencies & Codegen**  
   
```bash
   flutter pub get
   ./tool/codegen.sh

```

3. **iOS Setup** (if building for iOS)
   
```bash
   cd ios
   pod install
   ```
   
   **Note**: Enable "Enable Modules (C and Objective-C)" in Xcode Build Settings to resolve `@import` errors.

4. **Run & Test**

   
```bash
   flutter run
   flutter test
```

## Ambassador Features

### Onboarding Flow
The Ambassador onboarding screen (`lib/features/ambassador_onboarding_screen.dart`) provides:
- Multi-step registration form with validation
- Country and language selection dropdowns
- Bio and personal information collection
- Real-time Firestore integration
- Success screen with shareable ambassador ID and link

### Dashboard Analytics
The Ambassador dashboard (`lib/features/ambassador_dashboard_screen.dart`) features:
- **Interactive Charts**: Bar charts powered by `fl_chart` showing referral trends
- **Real-time Data**: Live statistics from Firestore with mock data fallback
- **Filtering**: Country and language filters that update both table and chart
- **Responsive Layout**: Adaptive design that works on all screen sizes

### Data Integration
- **AmbassadorService**: Handles Firestore operations and data fetching
- **AmbassadorDataNotifier**: Riverpod provider managing state and filtering
- **AmbassadorStats Model**: Structured data model with Freezed code generation

## UI/UX Improvements

### Responsive Design
- Filter rows automatically wrap on small screens
- Horizontal scrolling for filter components when needed
- LayoutBuilder implementation for adaptive layouts
- No more RenderFlex overflow errors

### Chart Integration
- `fl_chart` dependency added for beautiful, interactive charts
- Bar charts showing referral statistics over time
- Responsive chart sizing and touch interactions
- Color-coded data visualization

## Contribution Guidelines

1. Run `flutter pub get` before development.
2. Execute `flutter analyze` and `flutter test` before submitting a PR.
3. Follow the existing code structure and patterns.
4. Ensure responsive design works on all screen sizes.

## CI

Our GitHub Actions pipeline (`.github/workflows/flutter.yml`) runs on every push/PR to `main`:

* `flutter pub get`
* `tool/codegen.sh`
* `flutter analyze`
* `flutter test --coverage`
* Uploads coverage to Codecov

## Recent Updates

### Ambassador Feature Finalization
- ✅ Complete ambassador registration flow with backend integration
- ✅ Real-time dashboard with interactive charts
- ✅ Responsive UI/UX improvements
- ✅ Comprehensive unit tests
- ✅ Route integration and navigation
- ⚠️ iOS setup requires manual configuration (bundle ID, GoogleService-Info.plist)

**Note**: Localization and language files were excluded from this update round as requested.
