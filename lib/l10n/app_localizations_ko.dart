// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'TODO: Appoint';

  @override
  String get welcome => 'TODO: Welcome';

  @override
  String get home => 'TODO: Home';

  @override
  String get menu => 'TODO: Menu';

  @override
  String get profile => 'TODO: Profile';

  @override
  String get signOut => 'TODO: Sign Out';

  @override
  String get login => 'TODO: Login';

  @override
  String get email => 'TODO: Email';

  @override
  String get password => 'TODO: Password';

  @override
  String get signIn => 'TODO: Sign In';

  @override
  String get bookMeeting => 'TODO: Book a Meeting';

  @override
  String get bookAppointment => 'TODO: Book Appointment';

  @override
  String get bookingRequest => 'TODO: Booking Request';

  @override
  String get confirmBooking => 'TODO: Confirm Booking';

  @override
  String get chatBooking => 'TODO: Chat Booking';

  @override
  String get bookViaChat => 'TODO: Book via Chat';

  @override
  String get submitBooking => 'TODO: Submit Booking';

  @override
  String get next => 'TODO: Next';

  @override
  String get selectStaff => 'TODO: Select Staff';

  @override
  String get pickDate => 'TODO: Pick Date';

  @override
  String get staff => 'TODO: Staff';

  @override
  String get service => 'TODO: Service';

  @override
  String get dateTime => 'TODO: Date & Time';

  @override
  String duration(String duration) {
    return 'TODO: Duration: $duration minutes';
  }

  @override
  String get notSelected => 'TODO: Not Selected';

  @override
  String get noSlots => 'TODO: No slots available';

  @override
  String get bookingConfirmed => 'TODO: Booking Confirmed';

  @override
  String get failedToConfirmBooking => 'TODO: Failed to confirm booking';

  @override
  String get noBookingsFound => 'TODO: No bookings found';

  @override
  String errorLoadingBookings(String error) {
    return 'TODO: Error loading bookings: $error';
  }

  @override
  String get shareOnWhatsApp => 'TODO: Share on WhatsApp';

  @override
  String get shareMeetingInvitation => 'TODO: Share your meeting invitation:';

  @override
  String get meetingReadyMessage =>
      'TODO: The meeting is ready! Would you like to send it to your group?';

  @override
  String get customizeMessage => 'TODO: Customize your message...';

  @override
  String get saveGroupForRecognition =>
      'TODO: Save group for future recognition';

  @override
  String get groupNameOptional => 'TODO: Group Name (optional)';

  @override
  String get enterGroupName => 'TODO: Enter group name for recognition';

  @override
  String get knownGroupDetected => 'TODO: Known group detected';

  @override
  String get meetingSharedSuccessfully => 'TODO: Meeting shared successfully!';

  @override
  String get bookingConfirmedShare =>
      'TODO: Booking confirmed! You can now share the invitation.';

  @override
  String get defaultShareMessage =>
      'TODO: Hey! I\'ve scheduled a meeting with you through APP-OINT. Click here to confirm or suggest a different time:';

  @override
  String get dashboard => 'TODO: Dashboard';

  @override
  String get businessDashboard => 'TODO: Business Dashboard';

  @override
  String get myProfile => 'TODO: My Profile';

  @override
  String get noProfileFound => 'TODO: No profile found';

  @override
  String get errorLoadingProfile => 'TODO: Error loading profile';

  @override
  String get myInvites => 'TODO: My Invites';

  @override
  String get inviteDetail => 'TODO: Invite Detail';

  @override
  String get inviteContact => 'TODO: Invite Contact';

  @override
  String get noInvites => 'TODO: No invites';

  @override
  String get errorLoadingInvites => 'TODO: Error loading invites';

  @override
  String get accept => 'TODO: Accept';

  @override
  String get decline => 'TODO: Decline';

  @override
  String get sendInvite => 'TODO: Send Invite';

  @override
  String get name => 'TODO: Name';

  @override
  String get phoneNumber => 'TODO: Phone Number';

  @override
  String get emailOptional => 'TODO: Email (optional)';

  @override
  String get requiresInstallFallback => 'TODO: Requires installation';

  @override
  String get notifications => 'TODO: Notifications';

  @override
  String get notificationSettings => 'TODO: Notification Settings';

  @override
  String get enableNotifications => 'TODO: Enable Notifications';

  @override
  String get errorFetchingToken => 'TODO: Error fetching token';

  @override
  String fcmToken(String token) {
    return 'TODO: FCM Token: $token';
  }

  @override
  String get familyDashboard => 'TODO: Family Dashboard';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'TODO: Please login to access family features';

  @override
  String get familyMembers => 'TODO: Family Members';

  @override
  String get invite => 'TODO: Invite';

  @override
  String get pendingInvites => 'TODO: Pending Invites';

  @override
  String get connectedChildren => 'TODO: Connected Children';

  @override
  String get noFamilyMembersYet =>
      'TODO: No family members yet. Invite someone to get started!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'TODO: Error loading family links: $error';
  }

  @override
  String get inviteChild => 'TODO: Invite Child';

  @override
  String get managePermissions => 'TODO: Manage Permissions';

  @override
  String get removeChild => 'TODO: Remove Child';

  @override
  String get loading => 'TODO: Loading...';

  @override
  String get childEmail => 'TODO: Child Email';

  @override
  String get childEmailOrPhone => 'TODO: Child Email or Phone';

  @override
  String get enterChildEmail => 'TODO: Enter child email';

  @override
  String get otpCode => 'TODO: OTP Code';

  @override
  String get enterOtp => 'TODO: Enter OTP';

  @override
  String get verify => 'TODO: Verify';

  @override
  String get otpResentSuccessfully => 'TODO: OTP resent successfully!';

  @override
  String failedToResendOtp(String error) {
    return 'TODO: Failed to resend OTP: $error';
  }

  @override
  String get childLinkedSuccessfully => 'TODO: Child linked successfully!';

  @override
  String get invitationSentSuccessfully =>
      'TODO: Invitation sent successfully!';

  @override
  String failedToSendInvitation(String error) {
    return 'TODO: Failed to send invitation: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'TODO: Please enter a valid email';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'TODO: Please enter a valid email or phone';

  @override
  String get invalidCode => 'TODO: Invalid code, please try again';

  @override
  String get cancelInvite => 'TODO: Cancel Invite';

  @override
  String get cancelInviteConfirmation =>
      'TODO: Are you sure you want to cancel this invite?';

  @override
  String get no => 'TODO: No';

  @override
  String get yesCancel => 'TODO: Yes, Cancel';

  @override
  String get inviteCancelledSuccessfully =>
      'TODO: Invite cancelled successfully!';

  @override
  String failedToCancelInvite(String error) {
    return 'TODO: Failed to cancel invite: $error';
  }

  @override
  String get revokeAccess => 'TODO: Revoke Access';

  @override
  String get revokeAccessConfirmation =>
      'TODO: Are you sure you want to revoke access for this child? This action cannot be undone.';

  @override
  String get revoke => 'TODO: Revoke';

  @override
  String get accessRevokedSuccessfully => 'TODO: Access revoked successfully!';

  @override
  String failedToRevokeAccess(String error) {
    return 'TODO: Failed to revoke access: $error';
  }

  @override
  String get grantConsent => 'TODO: Grant Consent';

  @override
  String get revokeConsent => 'TODO: Revoke Consent';

  @override
  String get consentGrantedSuccessfully =>
      'TODO: Consent granted successfully!';

  @override
  String get consentRevokedSuccessfully =>
      'TODO: Consent revoked successfully!';

  @override
  String failedToUpdateConsent(String error) {
    return 'TODO: Failed to update consent: $error';
  }

  @override
  String get checkingPermissions => 'TODO: Checking permissions...';

  @override
  String get cancel => 'TODO: Cancel';

  @override
  String get close => 'TODO: Close';

  @override
  String get save => 'TODO: Save';

  @override
  String get sendNow => 'TODO: Send Now';

  @override
  String get details => 'TODO: Details';

  @override
  String get noBroadcastMessages => 'TODO: No broadcast messages yet';

  @override
  String errorCheckingPermissions(String error) {
    return 'TODO: Error checking permissions: $error';
  }

  @override
  String get mediaOptional => 'TODO: Media (Optional)';

  @override
  String get pickImage => 'TODO: Pick Image';

  @override
  String get pickVideo => 'TODO: Pick Video';

  @override
  String get pollOptions => 'TODO: Poll Options:';

  @override
  String get targetingFilters => 'TODO: Targeting Filters';

  @override
  String get scheduling => 'TODO: Scheduling';

  @override
  String get scheduleForLater => 'TODO: Schedule for later';

  @override
  String errorEstimatingRecipients(String error) {
    return 'TODO: Error estimating recipients: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'TODO: Error picking image: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'TODO: Error picking video: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'TODO: You do not have permission to create broadcast messages.';

  @override
  String get messageSavedSuccessfully => 'TODO: Message saved successfully';

  @override
  String errorSavingMessage(String error) {
    return 'TODO: Error saving message: $error';
  }

  @override
  String get messageSentSuccessfully => 'TODO: Message sent successfully';

  @override
  String errorSendingMessage(String error) {
    return 'TODO: Error sending message: $error';
  }

  @override
  String content(String content) {
    return 'TODO: Content: $content';
  }

  @override
  String type(String type) {
    return 'TODO: Type: $type';
  }

  @override
  String link(String link) {
    return 'TODO: Link: $link';
  }

  @override
  String status(String status) {
    return 'TODO: Status: $status';
  }

  @override
  String recipients(String count) {
    return 'TODO: Recipients: $count';
  }

  @override
  String opened(String count) {
    return 'TODO: Opened: $count';
  }

  @override
  String clicked(String count) {
    return 'TODO: Clicked: $count';
  }

  @override
  String created(String date) {
    return 'TODO: Created: $date';
  }

  @override
  String scheduled(String date) {
    return 'TODO: Scheduled: $date';
  }

  @override
  String get organizations => 'TODO: Organizations';

  @override
  String get noOrganizations => 'TODO: No organizations';

  @override
  String get errorLoadingOrganizations => 'TODO: Error loading organizations';

  @override
  String members(String count) {
    return 'TODO: $count members';
  }

  @override
  String get users => 'TODO: Users';

  @override
  String get noUsers => 'TODO: No users';

  @override
  String get errorLoadingUsers => 'TODO: Error loading users';

  @override
  String get changeRole => 'TODO: Change Role';

  @override
  String get totalAppointments => 'TODO: Total Appointments';

  @override
  String get completedAppointments => 'TODO: Completed Appointments';

  @override
  String get revenue => 'TODO: Revenue';

  @override
  String get errorLoadingStats => 'TODO: Error loading stats';

  @override
  String appointment(String id) {
    return 'TODO: Appointment: $id';
  }

  @override
  String from(String name) {
    return 'TODO: From: $name';
  }

  @override
  String phone(String number) {
    return 'TODO: Phone: $number';
  }

  @override
  String noRouteDefined(String route) {
    return 'TODO: No route defined for $route';
  }

  @override
  String get meetingDetails => 'TODO: Meeting Details';

  @override
  String meetingId(String id) {
    return 'TODO: Meeting ID: $id';
  }

  @override
  String creator(String id) {
    return 'TODO: Creator: $id';
  }

  @override
  String context(String id) {
    return 'TODO: Context: $id';
  }

  @override
  String group(String id) {
    return 'TODO: Group: $id';
  }

  @override
  String get requestPrivateSession => 'TODO: Request Private Session';

  @override
  String get privacyRequestSent =>
      'TODO: Privacy request sent to your parents!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'TODO: Failed to send privacy request: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'TODO: Error loading privacy requests: $error';
  }

  @override
  String requestType(String type) {
    return 'TODO: $type Request';
  }

  @override
  String statusColon(String status) {
    return 'TODO: Status: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'TODO: Failed to $action privacy request: $error';
  }

  @override
  String get yes => 'TODO: Yes';

  @override
  String get send => 'TODO: Send';

  @override
  String get permissions => 'TODO: Permissions';

  @override
  String permissionsFor(String childId) {
    return 'TODO: Permissions - $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'TODO: Error loading permissions: $error';
  }

  @override
  String get none => 'TODO: None';

  @override
  String get readOnly => 'TODO: Read Only';

  @override
  String get readWrite => 'TODO: Read & Write';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'TODO: Permission $category updated to $newValue';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'TODO: Failed to update permission: $error';
  }

  @override
  String invited(String date) {
    return 'TODO: Invited: $date';
  }

  @override
  String get adminBroadcast => 'TODO: Admin Broadcast';

  @override
  String get composeBroadcastMessage => 'TODO: Compose Broadcast Message';

  @override
  String get adminScreenTBD => 'TODO: Admin Screen - To Be Developed';

  @override
  String get staffScreenTBD => 'TODO: Staff Screen - To Be Developed';

  @override
  String get clientScreenTBD => 'TODO: Client Screen - To Be Developed';

  @override
  String get ambassadorTitle => '대사';

  @override
  String get ambassadorOnboardingTitle => '대사가 되기';

  @override
  String get ambassadorOnboardingSubtitle =>
      '당신의 언어와 지역에서 우리 커뮤니티를 성장시키는 데 도움을 주세요.';

  @override
  String get ambassadorOnboardingButton => '지금 시작하기';

  @override
  String get ambassadorDashboardTitle => '대사 대시보드';

  @override
  String get ambassadorDashboardSubtitle => '당신의 통계 및 활동 개요';

  @override
  String get ambassadorDashboardChartLabel => '이번 주 초대된 사용자';

  @override
  String get REDACTED_TOKEN => '남은 대사 자리';

  @override
  String get REDACTED_TOKEN => '국가 및 언어';

  @override
  String get ambassadorQuotaFull => '당신 지역의 대사 할당량이 가득 찼습니다.';

  @override
  String get ambassadorQuotaAvailable => '대사 자리가 사용 가능합니다!';

  @override
  String get ambassadorStatusAssigned => '당신은 활성 대사입니다.';

  @override
  String get ambassadorStatusNotEligible => '당신은 대사 자격이 없습니다.';

  @override
  String get ambassadorStatusWaiting => '자리 가용성을 기다리는 중...';

  @override
  String get ambassadorStatusRevoked => '당신의 대사 자격이 취소되었습니다.';

  @override
  String get ambassadorNoticeAdultOnly => '성인 계정만 대사가 될 수 있습니다.';

  @override
  String get ambassadorNoticeQuotaReached => '당신의 국가와 언어에 대한 대사 할당량에 도달했습니다.';

  @override
  String get ambassadorNoticeAutoAssign => '대사 자격은 자격을 갖춘 사용자에게 자동으로 부여됩니다.';
}
