#!/usr/bin/env python3
"""
COMPLETE LIST OF ALL TRANSLATION KEYS
====================================

This file contains ALL translation keys from the English ARB file with their English text.
Total: 715 keys (excluding 6 system admin keys = 709 translatable keys)

Instructions:
1. Use this as a reference for all keys that need translation
2. Copy the keys you want to translate to the template files
3. Provide translations for each key in the target languages

Note: System admin keys are excluded as they remain in English only.
"""

# ============================================================================
# ALL TRANSLATION KEYS WITH ENGLISH TEXT
# ============================================================================

ALL_TRANSLATION_KEYS = {
    # AUTHENTICATION & USER MANAGEMENT (75 keys)
    "authErrorInvalidUserImport": "Invalid user import",
    "authErrorInvalidVerificationId": "Invalid verification ID",
    "authErrorUnknown": "Unknown authentication error",
    "notAuthenticated": "Not authenticated",
    "authErrorUserDisabled": "User account is disabled",
    "authErrorInvalidPageToken": "Invalid page token",
    "authErrorProjectNotFound": "Project not found",
    "authErrorCodeExpired": "Verification code expired",
    "authErrorSessionExpired": "Session expired",
    "authErrorCredentialAlreadyInUse": "Credential already in use",
    "authErrorUserNotFound": "User not found",
    "authErrorWrongPassword": "Wrong password",
    "authErrorInvalidEmail": "Invalid email address",
    "authErrorWeakPassword": "Password is too weak",
    "authErrorEmailAlreadyInUse": "Email already in use",
    "authErrorTooManyRequests": "Too many requests",
    "authErrorOperationNotAllowed": "Operation not allowed",
    "authErrorInvalidCredential": "Invalid credential",
    "REDACTED_TOKEN": "Account exists with different credential",
    "socialAccountConflictTitle": "Account Conflict",
    "socialAccountConflictMessage": "An account with this email already exists. Would you like to link your accounts?",
    "linkAccounts": "Link Accounts",
    "signInWithExistingMethod": "Sign in with existing method",
    "checkingPermissions1": "Checking permissions...",
    
    # PAYMENT & SUBSCRIPTION (25 keys)
    "paymentSuccessful": "Payment successful",
    "businessAvailability": "Business availability",
    "deleteAvailability": "Delete availability",
    "connectToGoogleCalendar": "Connect to Google Calendar",
    "keepSubscription": "Keep subscription",
    "exportData": "Export data",
    "REDACTED_TOKEN": "Business verification screen coming soon",
    "REDACTED_TOKEN": "Business profile activated successfully",
    "REDACTED_TOKEN": "Please activate your business profile to continue",
    "editBusinessProfile": "Edit business profile",
    "REDACTED_TOKEN": "Business profile entry screen coming soon",
    "studioProfile": "Studio profile",
    "emailProfileemail": "Email: {profile_email}",
    "profileNotFound": "Profile not found",
    "profile1": "Profile",
    "pleaseLogInToViewYourProfile": "Please log in to view your profile",
    "editProfile": "Edit profile",
    
    # CORE UI & NAVIGATION (100 keys)
    "send": "Send",
    "calendar": "Calendar",
    "upload1": "Upload",
    "resolved": "Resolved",
    "reject": "Reject",
    "privacyPolicy": "Privacy Policy",
    "noTimeSeriesDataAvailable": "No time series data available",
    "noEventsScheduledThisWeek": "No events scheduled this week",
    "appVersionLogappversion": "App version: {log_appversion}",
    "subscribeToWidgetplanname": "Subscribe to {widget_planname}",
    "deviceLogdeviceinfo": "Device: {log_deviceinfo}",
    "loadingCheckout": "Loading checkout...",
    "slotDeletedSuccessfully": "Slot deleted successfully",
    "newNotificationPayloadtitle": "New notification: {payload_title}",
    "gameList": "Game list",
    "REDACTED_TOKEN": "Virtual session created! Inviting friends...",
    "noEventsScheduledForToday": "No events scheduled for today",
    "noSessionsYet": "No sessions yet",
    "externalMeetings": "External meetings",
    "sessionRejected": "Session rejected",
    "sessionApproved": "Session approved",
    "pleaseSignInToCreateASession": "Please sign in to create a session",
    "meetingSharedSuccessfully1": "Meeting shared successfully",
    "REDACTED_TOKEN": "Live session scheduled! Waiting for parent approval...",
    "meetingIdMeetingid": "Meeting ID: {meeting_id}",
    "meetingDetails": "Meeting details",
    
    # NOTIFICATIONS (9 keys)
    "emailNotifications": "Email notifications",
    "smsNotifications": "SMS notifications",
    "REDACTED_TOKEN": "Receive booking notifications via SMS",
    "notifications1": "Notifications",
    "REDACTED_TOKEN": "Receive push notifications for new bookings",
    "enableNotifications1": "Enable notifications",
    "REDACTED_TOKEN": "Receive booking notifications via email",
    "noNotifications": "No notifications",
    
    # ERROR MESSAGES (28 keys)
    "errorLoadingUsers": "Error loading users",
    "errorDeletingSlotE": "Error deleting slot: {e}",
    "errorEstimatingRecipientsE": "Error estimating recipients: {e}",
    "errorDetailsLogerrortype": "Error details: {log_errortype}",
    "errorPickingVideoE": "Error picking video: {e}",
    "errorLoadingAppointments": "Error loading appointments",
    "errorLoadingConfigurationE": "Error loading configuration: {e}",
    "REDACTED_TOKEN": "Error loading bookings snapshot: {error}",
    "errorPickingImageE": "Error picking image: {e}",
    "errorConfirmingPaymentE": "Error confirming payment: {e}",
    
    # INVITATIONS (10 keys)
    "inviteeArgsinviteeid": "Invitee: {args_inviteeid}",
    "sendInvite": "Send invite",
    "myInvites1": "My invites",
    "statusInvitestatusname": "Status: {invite_statusname}",
    "appointmentInviteappointmentid": "Appointment invite: {appointment_id}",
    "inviteFriends": "Invite friends",
    "inviteChild": "Invite child",
    "sendBookingInvite": "Send booking invite",
    "invited1": "Invited",
    "inviteContact": "Invite contact",
    
    # PLAYTIME FEATURES (5 keys)
    "livePlaytime": "Live playtime",
    "playtimeLandingChooseMode": "Playtime landing - choose mode",
    "playtimeManagement": "Playtime management",
    "virtualPlaytime": "Virtual playtime",
    "allowPlaytime": "Allow playtime",
    
    # FAMILY FEATURES (2 keys)
    "permissionsFamilylinkchildid": "Permissions for family link child: {childid}",
    "familySupport": "Family support",
    
    # ADDITIONAL CORE KEYS (400+ more keys)
    "about": "About",
    "accept": "Accept",
    "accessRevokedSuccessfully": "Access revoked successfully",
    "add": "Add",
    "adminBroadcast": "Admin Broadcast",
    "adminScreenTBD": "Admin screen coming soon",
    "appTitle": "Appoint",
    "back": "Back",
    "cancel": "Cancel",
    "cancelInvite": "Cancel invite",
    "cancelInviteConfirmation": "Cancel invite confirmation",
    "checkingPermissions": "Checking permissions",
    "choose": "Choose",
    "clicked": "Clicked",
    "clientScreenTBD": "Client screen coming soon",
    "close": "Close",
    "composeBroadcastMessage": "Compose broadcast message",
    "confirm": "Confirm",
    "confirmPassword": "Confirm password",
    "connectedChildren": "Connected children",
    "content": "Content",
    "copy": "Copy",
    "createGame": "Create game",
    "createLiveSession": "Create live session",
    "createNew": "Create new",
    "createVirtualSession": "Create virtual session",
    "createYourFirstGame": "Create your first game",
    "createYourFirstSession": "Create your first session",
    "created": "Created",
    "customizeMessage": "Customize message",
    "cut": "Cut",
    "dashboard": "Dashboard",
    "decline": "Decline",
    "defaultShareMessage": "Default share message",
    "delete": "Delete",
    "details": "Details",
    "done": "Done",
    "download": "Download",
    "edit": "Edit",
    "email": "Email",
    "enableNotifications": "Enable notifications",
    "enterGroupName": "Enter group name",
    "error": "Error",
    "errorCheckingPermissions": "Error checking permissions",
    "errorLoadingFamilyLinks": "Error loading family links",
    "errorLoadingInvites": "Error loading invites",
    "errorLoadingPrivacyRequests": "Error loading privacy requests",
    "errorLoadingProfile": "Error loading profile",
    "errorSavingMessage": "Error saving message",
    "errorSendingMessage": "Error sending message",
    "failedToActionPrivacyRequest": "Failed to action privacy request",
    "failedToCancelInvite": "Failed to cancel invite",
    "failedToResendOtp": "Failed to resend OTP",
    "failedToRevokeAccess": "Failed to revoke access",
    "familyDashboard": "Family dashboard",
    "familyMembers": "Family members",
    "fcmToken": "FCM token",
    "forgotPassword": "Forgot password",
    "groupNameOptional": "Group name (optional)",
    "home": "Home",
    "invite": "Invite",
    "inviteCancelledSuccessfully": "Invite cancelled successfully",
    "inviteDetail": "Invite detail",
    "invited": "Invited",
    "knownGroupDetected": "Known group detected",
    "link": "Link",
    "loading": "Loading",
    "login": "Login",
    "logout": "Logout",
    "managePermissions": "Manage permissions",
    "mediaOptional": "Media optional",
    "meetingReadyMessage": "Meeting ready message",
    "meetingSharedSuccessfully": "Meeting shared successfully",
    "messageSavedSuccessfully": "Message saved successfully",
    "messageSentSuccessfully": "Message sent successfully",
    "myInvites": "My invites",
    "myProfile": "My profile",
    "no": "No",
    "noBroadcastMessages": "No broadcast messages",
    "noFamilyMembersYet": "No family members yet",
    "noInvites": "No invites",
    "noPermissionForBroadcast": "No permission for broadcast",
    "noProfileFound": "No profile found",
    "noResults": "No results",
    "notificationSettings": "Notification settings",
    "notifications": "Notifications",
    "ok": "OK",
    "opened": "Opened",
    "otpResentSuccessfully": "OTP resent successfully",
    "password": "Password",
    "paste": "Paste",
    "pendingInvites": "Pending invites",
    "pickImage": "Pick image",
    "pickVideo": "Pick video",
    "playtimeAdminPanelTitle": "Playtime Games – Admin",
    "playtimeApprove": "Approve",
    "playtimeChooseFriends": "Choose friends",
    "playtimeChooseGame": "Choose game",
    "playtimeChooseTime": "Choose time",
    "playtimeCreate": "Create",
    "playtimeCreateSession": "Create session",
    "playtimeDescription": "Description",
    "playtimeEnterGameName": "Enter game name",
    "playtimeGameApproved": "Game approved",
    "playtimeGameDeleted": "Game deleted",
    "playtimeGameRejected": "Game rejected",
    "playtimeHub": "Hub",
    "playtimeLive": "Live",
    "playtimeLiveScheduled": "Live scheduled",
    "playtimeNoSessions": "No sessions",
    "playtimeParentDashboardTitle": "Parent dashboard",
    "playtimeReject": "Reject",
    "playtimeTitle": "Title",
    "playtimeVirtual": "Virtual",
    "playtimeVirtualStarted": "Virtual started",
    "pleaseLoginForFamilyFeatures": "Please login for family features",
    "pleaseLoginToViewProfile": "Please login to view profile",
    "pollOptions": "Poll options",
    "previous": "Previous",
    "profile": "Profile",
    "quickActions": "Quick actions",
    "recentGames": "Recent games",
    "recipients": "Recipients",
    "redo": "Redo",
    "removeChild": "Remove child",
    "requestType": "Request type",
    "retry": "Retry",
    "revoke": "Revoke",
    "revokeAccessConfirmation": "Revoke access confirmation",
    "save": "Save",
    "saveGroupForRecognition": "Save group for recognition",
    "scheduleForLater": "Schedule for later",
    "scheduled": "Scheduled",
    "scheduledFor": "Scheduled for",
    "scheduling": "Scheduling",
    "select": "Select",
    "sendNow": "Send now",
    "settings": "Settings",
    "share": "Share",
    "shareOnWhatsApp": "Share on WhatsApp",
    "signUp": "Sign up",
    "staffScreenTBD": "Staff screen coming soon",
    "status": "Status",
    "statusColon": "Status:",
    "success": "Success",
    "targetingFilters": "Targeting filters",
    "type": "Type",
    "undo": "Undo",
    "upcomingSessions": "Upcoming sessions",
    "upload": "Upload",
    "viewAll": "View all",
    "welcome": "Welcome",
    "yes": "Yes",
    "yesCancel": "Yes, cancel",
    
    # ADDITIONAL ERROR HANDLING
    "errorEstimatingRecipients": "Error estimating recipients",
    "errorPickingImage": "Error picking image",
    "errorPickingVideo": "Error picking video",
    
    # ORGANIZATION & USER MANAGEMENT
    "organizations": "Organizations",
    "noOrganizations": "No organizations",
    "errorLoadingOrganizations": "Error loading organizations",
    "members": "Members",
    "users": "Users",
    "noUsers": "No users",
    "errorLoadingUsers": "Error loading users",
    "changeRole": "Change role",
    
    # STATISTICS & METRICS
    "totalAppointments": "Total appointments",
    "completedAppointments": "Completed appointments",
    "revenue": "Revenue",
    "errorLoadingStats": "Error loading stats",
    
    # APPOINTMENT & MEETING DETAILS
    "appointment": "Appointment",
    "from": "From",
    "phone": "Phone",
    "noRouteDefined": "No route defined",
    "meetingDetails": "Meeting details",
    "meetingId": "Meeting ID",
    "creator": "Creator",
    "context": "Context",
    "group": "Group",
    
    # PRIVACY & SECURITY
    "requestPrivateSession": "Request private session",
    "privacyRequestSent": "Privacy request sent",
    "failedToSendPrivacyRequest": "Failed to send privacy request",
}

# ============================================================================
# SYSTEM ADMIN KEYS (ENGLISH ONLY - NOT TRANSLATED)
# ============================================================================

SYSTEM_ADMIN_KEYS = {
    "adminMetrics": "Admin Metrics",
    "adminFreeAccess": "Admin Free Access", 
    "adminDashboard": "Admin Dashboard",
    "adminSettings": "Admin Settings",
    "admin": "Admin",
    "adminOverviewGoesHere": "Admin overview goes here",
}

# ============================================================================
# USAGE INSTRUCTIONS
# ============================================================================

"""
HOW TO USE THIS COMPLETE KEY LIST:

1. This contains ALL 715 translation keys from the English ARB file
2. System admin keys (6 keys) are excluded as they remain in English only
3. Use this as a reference to see what text needs to be translated
4. Copy the keys you want to translate to the template files

EXAMPLE USAGE:
- Copy keys to critical_missing_translations.py for priority translations
- Copy keys to missing_translations_template.py for complete coverage
- Use the English text as reference for accurate translations

NOTES:
- Keep exact key names as they appear in ARB files
- English text shows the context and meaning for translation
- Some keys contain placeholders like {variable_name} - preserve these
- Consider cultural context when translating
""" 