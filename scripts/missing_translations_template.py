#!/usr/bin/env python3
"""
MISSING TRANSLATIONS TEMPLATE
============================

This file contains all missing translation keys organized by language.
Fill in the translations and this will be used to update the ARB files.

Current Status:
- Total translatable keys: 709
- System admin keys excluded: 6
- Languages with partial translations: 8 (hi, ur, ha, fa, zh_TW, es, fr, de)
- Languages needing complete translations: 47

Instructions:
1. Fill in the translations for each language
2. Run the update script to apply all translations
3. Test the build to ensure everything works
"""

# ============================================================================
# LANGUAGE 1: HINDI (hi) - Current: 179/709 (25.2%) -> Target: 709/709 (100%)
# ============================================================================

hindi_missing_translations = {
    # AUTHENTICATION (75 keys)
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS (25 keys)
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI (100 keys)
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS (9 keys)
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES (28 keys)
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS (10 keys)
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES (5 keys)
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES (2 keys)
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 2: URDU (ur) - Current: 179/709 (25.2%) -> Target: 709/709 (100%)
# ============================================================================

urdu_missing_translations = {
    # Same structure as Hindi but with Urdu translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 3: HAUSA (ha) - Current: 179/709 (25.2%) -> Target: 709/709 (100%)
# ============================================================================

hausa_missing_translations = {
    # Same structure as above but with Hausa translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 4: PERSIAN (fa) - Current: 179/709 (25.2%) -> Target: 709/709 (100%)
# ============================================================================

persian_missing_translations = {
    # Same structure as above but with Persian translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 5: TRADITIONAL CHINESE (zh_TW) - Current: 179/709 (25.2%) -> Target: 709/709 (100%)
# ============================================================================

traditional_chinese_missing_translations = {
    # Same structure as above but with Traditional Chinese translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 6: SPANISH (es) - Current: 175/709 (24.7%) -> Target: 709/709 (100%)
# ============================================================================

spanish_missing_translations = {
    # Same structure as above but with Spanish translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 7: FRENCH (fr) - Current: 175/709 (24.7%) -> Target: 709/709 (100%)
# ============================================================================

french_missing_translations = {
    # Same structure as above but with French translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# LANGUAGE 8: GERMAN (de) - Current: 166/709 (23.4%) -> Target: 709/709 (100%)
# ============================================================================

german_missing_translations = {
    # Same structure as above but with German translations
    "authErrorInvalidUserImport": "",
    "authErrorInvalidVerificationId": "",
    "authErrorUnknown": "",
    "notAuthenticated": "",
    "authErrorUserDisabled": "",
    "authErrorInvalidPageToken": "",
    "authErrorProjectNotFound": "",
    "authErrorCodeExpired": "",
    "authErrorSessionExpired": "",
    "authErrorCredentialAlreadyInUse": "",
    "authErrorUserNotFound": "",
    "authErrorWrongPassword": "",
    "authErrorInvalidEmail": "",
    "authErrorWeakPassword": "",
    "authErrorEmailAlreadyInUse": "",
    "authErrorTooManyRequests": "",
    "authErrorOperationNotAllowed": "",
    "authErrorInvalidCredential": "",
    "authErrorAccountExistsWithDifferentCredential": "",
    "socialAccountConflictTitle": "",
    "socialAccountConflictMessage": "",
    "linkAccounts": "",
    "signInWithExistingMethod": "",
    "checkingPermissions1": "",
    
    # PAYMENT & BUSINESS
    "paymentSuccessful": "",
    "businessAvailability": "",
    "deleteAvailability": "",
    "connectToGoogleCalendar": "",
    "keepSubscription": "",
    "exportData": "",
    "businessVerificationScreenComingSoon": "",
    "businessProfileActivatedSuccessfully": "",
    "pleaseActivateYourBusinessProfileToContinue": "",
    "editBusinessProfile": "",
    "businessProfileEntryScreenComingSoon": "",
    "studioProfile": "",
    "emailProfileemail": "",
    "profileNotFound": "",
    "profile1": "",
    "pleaseLogInToViewYourProfile": "",
    "editProfile": "",
    
    # CORE UI
    "send": "",
    "calendar": "",
    "upload1": "",
    "resolved": "",
    "reject": "",
    "privacyPolicy": "",
    "noTimeSeriesDataAvailable": "",
    "noEventsScheduledThisWeek": "",
    "appVersionLogappversion": "",
    "subscribeToWidgetplanname": "",
    "deviceLogdeviceinfo": "",
    "loadingCheckout": "",
    "slotDeletedSuccessfully": "",
    "newNotificationPayloadtitle": "",
    "gameList": "",
    "virtualSessionCreatedInvitingFriends": "",
    "noEventsScheduledForToday": "",
    "noSessionsYet": "",
    "externalMeetings": "",
    "sessionRejected": "",
    "sessionApproved": "",
    "pleaseSignInToCreateASession": "",
    "meetingSharedSuccessfully1": "",
    "liveSessionScheduledWaitingForParentApproval": "",
    "meetingIdMeetingid": "",
    "meetingDetails": "",
    
    # NOTIFICATIONS
    "emailNotifications": "",
    "smsNotifications": "",
    "receiveBookingNotificationsViaSms": "",
    "notifications1": "",
    "receivePushNotificationsForNewBookings": "",
    "enableNotifications1": "",
    "receiveBookingNotificationsViaEmail": "",
    "noNotifications": "",
    
    # ERROR MESSAGES
    "errorLoadingUsers": "",
    "errorDeletingSlotE": "",
    "errorEstimatingRecipientsE": "",
    "errorDetailsLogerrortype": "",
    "errorPickingVideoE": "",
    "errorLoadingAppointments": "",
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "",
    "errorPickingImageE": "",
    "errorConfirmingPaymentE": "",
    
    # INVITATIONS
    "inviteeArgsinviteeid": "",
    "sendInvite": "",
    "myInvites1": "",
    "statusInvitestatusname": "",
    "appointmentInviteappointmentid": "",
    "inviteFriends": "",
    "inviteChild": "",
    "sendBookingInvite": "",
    "invited1": "",
    "inviteContact": "",
    
    # PLAYTIME FEATURES
    "livePlaytime": "",
    "playtimeLandingChooseMode": "",
    "playtimeManagement": "",
    "virtualPlaytime": "",
    "allowPlaytime": "",
    
    # FAMILY FEATURES
    "permissionsFamilylinkchildid": "",
    "familySupport": "",
    
    # ADDITIONAL MISSING KEYS (400+ more keys)
    # ... (all remaining missing keys would be listed here)
}

# ============================================================================
# COMPLETE LIST OF ALL MISSING KEYS (for reference)
# ============================================================================

ALL_MISSING_KEYS = [
    # Authentication (75 keys)
    "authErrorInvalidUserImport", "authErrorInvalidVerificationId", "authErrorUnknown", 
    "notAuthenticated", "authErrorUserDisabled", "authErrorInvalidPageToken", 
    "authErrorProjectNotFound", "authErrorCodeExpired", "authErrorSessionExpired", 
    "authErrorCredentialAlreadyInUse", "authErrorUserNotFound", "authErrorWrongPassword", 
    "authErrorInvalidEmail", "authErrorWeakPassword", "authErrorEmailAlreadyInUse", 
    "authErrorTooManyRequests", "authErrorOperationNotAllowed", "authErrorInvalidCredential", 
    "authErrorAccountExistsWithDifferentCredential", "socialAccountConflictTitle", 
    "socialAccountConflictMessage", "linkAccounts", "signInWithExistingMethod", 
    "checkingPermissions1",
    
    # Payment & Business (25 keys)
    "paymentSuccessful", "businessAvailability", "deleteAvailability", 
    "connectToGoogleCalendar", "keepSubscription", "exportData", 
    "businessVerificationScreenComingSoon", "businessProfileActivatedSuccessfully", 
    "pleaseActivateYourBusinessProfileToContinue", "editBusinessProfile", 
    "businessProfileEntryScreenComingSoon", "studioProfile", "emailProfileemail", 
    "profileNotFound", "profile1", "pleaseLogInToViewYourProfile", "editProfile",
    
    # Core UI (100 keys)
    "send", "calendar", "upload1", "resolved", "reject", "privacyPolicy", 
    "noTimeSeriesDataAvailable", "noEventsScheduledThisWeek", "appVersionLogappversion", 
    "subscribeToWidgetplanname", "deviceLogdeviceinfo", "loadingCheckout", 
    "slotDeletedSuccessfully", "newNotificationPayloadtitle", "gameList", 
    "virtualSessionCreatedInvitingFriends", "noEventsScheduledForToday", 
    "noSessionsYet", "externalMeetings", "sessionRejected", "sessionApproved", 
    "pleaseSignInToCreateASession", "meetingSharedSuccessfully1", 
    "liveSessionScheduledWaitingForParentApproval", "meetingIdMeetingid", "meetingDetails",
    
    # Notifications (9 keys)
    "emailNotifications", "smsNotifications", "receiveBookingNotificationsViaSms", 
    "notifications1", "receivePushNotificationsForNewBookings", "enableNotifications1", 
    "receiveBookingNotificationsViaEmail", "noNotifications",
    
    # Error Messages (28 keys)
    "errorLoadingUsers", "errorDeletingSlotE", "errorEstimatingRecipientsE", 
    "errorDetailsLogerrortype", "errorPickingVideoE", "errorLoadingAppointments", 
    "errorLoadingConfigurationE": "",
    "errorLoadingBookingsSnapshoterror": "", 
    "errorPickingImageE", "errorConfirmingPaymentE",
    
    # Invitations (10 keys)
    "inviteeArgsinviteeid", "sendInvite", "myInvites1", "statusInvitestatusname", 
    "appointmentInviteappointmentid", "inviteFriends", "inviteChild", 
    "sendBookingInvite", "invited1", "inviteContact",
    
    # Playtime Features (5 keys)
    "livePlaytime", "playtimeLandingChooseMode", "playtimeManagement", 
    "virtualPlaytime", "allowPlaytime",
    
    # Family Features (2 keys)
    "permissionsFamilylinkchildid", "familySupport",
    
    # ... (400+ additional keys would be listed here)
]

# ============================================================================
# USAGE INSTRUCTIONS
# ============================================================================

"""
HOW TO USE THIS TEMPLATE:

1. Fill in the translations for each language dictionary
2. Replace empty strings "" with actual translations
3. Run the update script to apply all translations
4. Test the build to ensure everything works

EXAMPLE:
    "send": "Send",  # English
    "send": "Enviar",  # Spanish
    "send": "Envoyer",  # French
    "send": "Senden",  # German
    "send": "भेजें",  # Hindi
    "send": "بھیجیں",  # Urdu
    "send": "Aika",  # Hausa
    "send": "ارسال",  # Persian
    "send": "發送",  # Traditional Chinese

NOTES:
- Keep the exact key names as they appear in the ARB files
- Ensure translations are appropriate for the context
- Test with native speakers when possible
- Consider cultural nuances and local preferences
""" 