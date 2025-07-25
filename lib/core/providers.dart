// Centralized provider exports for the entire application
// This file serves as the single source of truth for all Riverpod providers

// Admin and ambassador providers
export '../providers/admin_provider.dart' hide analyticsProvider;
export '../providers/ambassador_data_provider.dart';
export '../providers/ambassador_quota_provider.dart';
export '../providers/ambassador_record_provider.dart';
export '../providers/appointment_provider.dart';
export '../providers/auth_provider.dart';
// Feature providers
export '../providers/booking_draft_provider.dart';
export '../providers/branch_provider.dart';
export '../providers/business_analytics_provider.dart';
export '../providers/calendar_provider.dart';
export '../providers/care_providers_provider.dart';
// Content and UI providers
export '../providers/content_provider.dart';
export '../providers/dashboard_provider.dart' hide dashboardStatsProvider;
export '../providers/family_provider.dart';
export '../providers/family_support_provider.dart';
// Core providers
export '../providers/fcm_token_provider.dart' hide authServiceProvider;
export '../providers/firebase_providers.dart' hide firebaseAuthProvider;
export '../providers/game_provider.dart';
// Integration providers
export '../providers/google_calendar_provider.dart';
export '../providers/invite_provider.dart';
export '../providers/notification_provider.dart';
export '../providers/otp_provider.dart';
// Payment and rewards providers
export '../providers/payment_provider.dart';
export '../providers/personal_scheduler_provider.dart';
export '../providers/playtime_provider.dart' hide authProvider;
export '../providers/referral_provider.dart';
export '../providers/rewards_provider.dart';
export '../providers/search_provider.dart';
export '../providers/REDACTED_TOKEN.dart';
export '../providers/studio_appointments_provider.dart';
export '../providers/studio_business_providers.dart'
    hide
        analyticsProvider,
        dashboardStatsProvider,
        firebaseAuthProvider,
        staffAvailabilityProvider;
export '../providers/studio_provider.dart' hide staffAvailabilityProvider;
export '../providers/theme_provider.dart';
export '../providers/user_notifications_provider.dart';
export '../providers/user_profile_provider.dart';
export '../providers/user_provider.dart';
export '../providers/user_role_provider.dart';
export '../providers/user_settings_provider.dart';
export '../providers/user_subscription_provider.dart';
export '../providers/whatsapp_share_provider.dart';
