// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Profile';

  @override
  String get signOut => 'Sign Out';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get bookMeeting => 'Book a Meeting';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get bookingRequest => 'Booking Request';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get chatBooking => 'Chat Booking';

  @override
  String get bookViaChat => 'Book via Chat';

  @override
  String get submitBooking => 'Submit Booking';

  @override
  String get next => 'Next';

  @override
  String get selectStaff => 'Select Staff';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get staff => 'Staff';

  @override
  String get service => 'Service';

  @override
  String get dateTime => 'Date & Time';

  @override
  String duration(String duration) {
    return 'Duration: $duration minutes';
  }

  @override
  String get notSelected => 'Not Selected';

  @override
  String get noSlots => 'No slots available';

  @override
  String get bookingConfirmed => 'Booking Confirmed';

  @override
  String get failedToConfirmBooking => 'Failed to confirm booking';

  @override
  String get noBookingsFound => 'No bookings found';

  @override
  String errorLoadingBookings(String error) {
    return 'Error loading bookings: $error';
  }

  @override
  String get shareOnWhatsApp => 'Share on WhatsApp';

  @override
  String get shareMeetingInvitation => 'Share your meeting invitation:';

  @override
  String get meetingReadyMessage =>
      'The meeting is ready! Would you like to send it to your group?';

  @override
  String get customizeMessage => 'Customize your message...';

  @override
  String get saveGroupForRecognition => 'Save group for future recognition';

  @override
  String get groupNameOptional => 'Group Name (optional)';

  @override
  String get enterGroupName => 'Enter group name for recognition';

  @override
  String get knownGroupDetected => 'Known group detected';

  @override
  String get meetingSharedSuccessfully => 'Meeting shared successfully!';

  @override
  String get bookingConfirmedShare =>
      'Booking confirmed! You can now share the invitation.';

  @override
  String get defaultShareMessage =>
      'Hey! I\'ve scheduled a meeting with you through APP-OINT. Click here to confirm or suggest a different time:';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get businessDashboard => 'Business Dashboard';

  @override
  String get myProfile => 'My Profile';

  @override
  String get noProfileFound => 'No profile found';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get myInvites => 'My Invites';

  @override
  String get inviteDetail => 'Invite Detail';

  @override
  String get inviteContact => 'Invite Contact';

  @override
  String get noInvites => 'No invites';

  @override
  String get errorLoadingInvites => 'Error loading invites';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get sendInvite => 'Send Invite';

  @override
  String get name => 'Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get requiresInstallFallback => 'Requires installation';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get errorFetchingToken => 'Error fetching token';

  @override
  String fcmToken(String token) {
    return 'FCM Token: $token';
  }

  @override
  String get familyDashboard => 'Family Dashboard';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'Please login to access family features';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get invite => 'Invite';

  @override
  String get pendingInvites => 'Pending Invites';

  @override
  String get connectedChildren => 'Connected Children';

  @override
  String get noFamilyMembersYet =>
      'No family members yet. Invite someone to get started!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'Error loading family links: $error';
  }

  @override
  String get inviteChild => 'Invite Child';

  @override
  String get managePermissions => 'Manage Permissions';

  @override
  String get removeChild => 'Remove Child';

  @override
  String get loading => 'Loading...';

  @override
  String get childEmail => 'Child Email';

  @override
  String get childEmailOrPhone => 'Child Email or Phone';

  @override
  String get enterChildEmail => 'Enter child email';

  @override
  String get otpCode => 'OTP Code';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get verify => 'Verify';

  @override
  String get otpResentSuccessfully => 'OTP resent successfully!';

  @override
  String failedToResendOtp(String error) {
    return 'Failed to resend OTP: $error';
  }

  @override
  String get childLinkedSuccessfully => 'Child linked successfully!';

  @override
  String get invitationSentSuccessfully => 'Invitation sent successfully!';

  @override
  String failedToSendInvitation(String error) {
    return 'Failed to send invitation: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'Please enter a valid email or phone';

  @override
  String get invalidCode => 'Invalid code, please try again';

  @override
  String get cancelInvite => 'Cancel Invite';

  @override
  String get cancelInviteConfirmation =>
      'Are you sure you want to cancel this invite?';

  @override
  String get no => 'No';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get inviteCancelledSuccessfully => 'Invite cancelled successfully!';

  @override
  String failedToCancelInvite(String error) {
    return 'Failed to cancel invite: $error';
  }

  @override
  String get revokeAccess => 'Revoke Access';

  @override
  String get revokeAccessConfirmation =>
      'Are you sure you want to revoke access for this child? This action cannot be undone.';

  @override
  String get revoke => 'Revoke';

  @override
  String get accessRevokedSuccessfully => 'Access revoked successfully!';

  @override
  String failedToRevokeAccess(String error) {
    return 'Failed to revoke access: $error';
  }

  @override
  String get grantConsent => 'Grant Consent';

  @override
  String get revokeConsent => 'Revoke Consent';

  @override
  String get consentGrantedSuccessfully => 'Consent granted successfully!';

  @override
  String get consentRevokedSuccessfully => 'Consent revoked successfully!';

  @override
  String failedToUpdateConsent(String error) {
    return 'Failed to update consent: $error';
  }

  @override
  String get checkingPermissions => 'Checking permissions...';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get sendNow => 'Send Now';

  @override
  String get details => 'Details';

  @override
  String get noBroadcastMessages => 'No broadcast messages yet';

  @override
  String errorCheckingPermissions(String error) {
    return 'Error checking permissions: $error';
  }

  @override
  String get mediaOptional => 'Media (Optional)';

  @override
  String get pickImage => 'Pick Image';

  @override
  String get pickVideo => 'Pick Video';

  @override
  String get pollOptions => 'Poll Options:';

  @override
  String get targetingFilters => 'Targeting Filters';

  @override
  String get scheduling => 'Scheduling';

  @override
  String get scheduleForLater => 'Schedule for later';

  @override
  String errorEstimatingRecipients(String error) {
    return 'Error estimating recipients: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'Error picking video: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'You do not have permission to create broadcast messages.';

  @override
  String get messageSavedSuccessfully => 'Message saved successfully';

  @override
  String errorSavingMessage(String error) {
    return 'Error saving message: $error';
  }

  @override
  String get messageSentSuccessfully => 'Message sent successfully';

  @override
  String errorSendingMessage(String error) {
    return 'Error sending message: $error';
  }

  @override
  String content(String content) {
    return 'Content: $content';
  }

  @override
  String type(String type) {
    return 'Type: $type';
  }

  @override
  String link(String link) {
    return 'Link: $link';
  }

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String recipients(String count) {
    return 'Recipients: $count';
  }

  @override
  String opened(String count) {
    return 'Opened: $count';
  }

  @override
  String clicked(String count) {
    return 'Clicked: $count';
  }

  @override
  String created(String date) {
    return 'Created: $date';
  }

  @override
  String scheduled(String date) {
    return 'Scheduled: $date';
  }

  @override
  String get organizations => 'Organizations';

  @override
  String get noOrganizations => 'No organizations';

  @override
  String get errorLoadingOrganizations => 'Error loading organizations';

  @override
  String members(String count) {
    return '$count members';
  }

  @override
  String get users => 'Users';

  @override
  String get noUsers => 'No users';

  @override
  String get errorLoadingUsers => 'Error loading users';

  @override
  String get changeRole => 'Change Role';

  @override
  String get totalAppointments => 'Total Appointments';

  @override
  String get completedAppointments => 'Completed Appointments';

  @override
  String get revenue => 'Revenue';

  @override
  String get errorLoadingStats => 'Error loading stats';

  @override
  String appointment(String id) {
    return 'Appointment: $id';
  }

  @override
  String from(String name) {
    return 'From: $name';
  }

  @override
  String phone(String number) {
    return 'Phone: $number';
  }

  @override
  String noRouteDefined(String route) {
    return 'No route defined for $route';
  }

  @override
  String get meetingDetails => 'Meeting Details';

  @override
  String meetingId(String id) {
    return 'Meeting ID: $id';
  }

  @override
  String creator(String id) {
    return 'Creator: $id';
  }

  @override
  String context(String id) {
    return 'Context: $id';
  }

  @override
  String group(String id) {
    return 'Group: $id';
  }

  @override
  String get requestPrivateSession => 'Request Private Session';

  @override
  String get privacyRequestSent => 'Privacy request sent to your parents!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'Failed to send privacy request: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'Error loading privacy requests: $error';
  }

  @override
  String requestType(String type) {
    return '$type Request';
  }

  @override
  String statusColon(String status) {
    return 'Status: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'Failed to $action privacy request: $error';
  }

  @override
  String get yes => 'Yes';

  @override
  String get send => 'Send';

  @override
  String get permissions => 'Permissions';

  @override
  String permissionsFor(String childId) {
    return 'Permissions - $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'Error loading permissions: $error';
  }

  @override
  String get none => 'None';

  @override
  String get readOnly => 'Read Only';

  @override
  String get readWrite => 'Read & Write';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'Permission $category updated to $newValue';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'Failed to update permission: $error';
  }

  @override
  String invited(String date) {
    return 'Invited: $date';
  }

  @override
  String get adminBroadcast => 'Admin Broadcast';

  @override
  String get composeBroadcastMessage => 'Compose Broadcast Message';

  @override
  String get adminScreenTBD => 'Admin Screen - To Be Developed';

  @override
  String get staffScreenTBD => 'Staff Screen - To Be Developed';

  @override
  String get clientScreenTBD => 'Client Screen - To Be Developed';

  @override
  String get ambassadorTitle => 'Global Ambassador';

  @override
  String get ambassadorOnboardingTitle => 'Become a Voice for Your Country';

  @override
  String get ambassadorOnboardingSubtitle =>
      'Represent your language and help us grow';

  @override
  String get ambassadorOnboardingButton => 'Start Now';

  @override
  String get ambassadorDashboardTitle => 'Ambassador Dashboard';

  @override
  String get ambassadorDashboardSubtitle => 'Your community impact at a glance';

  @override
  String get ambassadorDashboardChartLabel => 'Users joined via your language';

  @override
  String get ambassadorDashboardRemainingSlots => 'Remaining Slots';

  @override
  String get ambassadorDashboardCountryLanguage => 'Country / Language';

  @override
  String get ambassadorQuotaFull =>
      'All ambassador slots are currently filled.';

  @override
  String get ambassadorQuotaAvailable => 'Slots Available';

  @override
  String get ambassadorStatusAssigned => 'You are an official ambassador!';

  @override
  String get ambassadorStatusNotEligible =>
      'You are not eligible for ambassador status.';

  @override
  String get ambassadorStatusWaiting => 'Waiting for assignment...';

  @override
  String get ambassadorStatusRevoked => 'Your ambassador status was revoked.';

  @override
  String get ambassadorNoticeAdultOnly => 'Only adults can become ambassadors.';

  @override
  String get ambassadorNoticeQuotaReached =>
      'Ambassador quota for your region is full.';

  @override
  String get ambassadorNoticeAutoAssign =>
      'Ambassadorship is automatically assigned by the system.';
}
