# Routing Overview

The app uses `onGenerateRoute` in `lib/config/routes.dart` to map named routes to screens. Below is a summary of key routes.

| Route | Screen |
|-------|--------|
| `/` | `HomeScreen` |
| `/studio/booking` | `StudioBookingScreen` |
| `/studio/confirm` | `StudioBookingConfirmScreen` |
| `/studio/library` | `ContentLibraryScreen` |
| `/chat-booking` | `ChatBookingScreen` |
| `/booking/request` | `BookingRequestScreen` |
| `/dashboard` | `DashboardScreen` |
| `/profile` | `ProfileScreen` |
| `/profile/edit` | `EditProfileScreen` |
| `/settings` | `SettingsScreen` |
| `/admin/dashboard` | `AdminDashboardScreen` |
| `/family/invite` | `InvitationModal` |
| `/dashboard/family` | `FamilyDashboardScreen` |
| `/family/invite-child` | `InviteChildScreen` |
| `/family/permissions` | `PermissionsScreen` (expects `familyLink` argument) |
| `/admin/broadcast` | `AdminBroadcastScreen` |
| `/admin/demo-panel` | `AdminDemoPanelScreen` |
| `/google/calendar` | `GoogleIntegrationScreen` |
| `/ambassador-dashboard` | `AmbassadorDashboardScreen` |
| `/ambassador-onboarding` | `AmbassadorOnboardingScreen` |
| `/meeting/details` | `MeetingDetailsScreen` (expects `meetingId` and optional IDs) |
| `/invite/details` | `InviteDetailScreen` (expects `Invite` argument) |
| `/booking/details` | `BookingConfirmScreen` |
| `/business/dashboard` | `BusinessDashboardScreen` |
| `/business/profile` | `BusinessProfileScreen` |
| `/invite/list` | `InviteListScreen` |
| `/content/:id` | `ContentDetailScreen` (expects content ID argument) |
| `/notifications` | `NotificationsScreen` |
| `/search` | `SearchScreen` |
| `/error` | `ErrorScreen` |

Unrecognized routes fall back to a simple screen explaining that no matching route was found. Ensure `onGenerateRoute` stays conflict-free and that each screen imports correctly.
