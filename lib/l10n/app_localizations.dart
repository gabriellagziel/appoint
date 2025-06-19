import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('ms'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Appoint'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Menu navigation label
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Sign out button label
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Sign in button label
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Book meeting button label
  ///
  /// In en, this message translates to:
  /// **'Book a Meeting'**
  String get bookMeeting;

  /// Book appointment button label
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// Booking request label
  ///
  /// In en, this message translates to:
  /// **'Booking Request'**
  String get bookingRequest;

  /// Confirm booking button label
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Chat booking label
  ///
  /// In en, this message translates to:
  /// **'Chat Booking'**
  String get chatBooking;

  /// Book via chat button label
  ///
  /// In en, this message translates to:
  /// **'Book via Chat'**
  String get bookViaChat;

  /// Submit booking button label
  ///
  /// In en, this message translates to:
  /// **'Submit Booking'**
  String get submitBooking;

  /// Label for the next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Label for staff selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Staff'**
  String get selectStaff;

  /// Label for date picker
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// Staff label
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// Service label
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// Date and time label
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// Duration label with parameter
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration} minutes'**
  String duration(String duration);

  /// Not selected state
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get notSelected;

  /// Message shown when no time slots are available
  ///
  /// In en, this message translates to:
  /// **'No slots available'**
  String get noSlots;

  /// Booking confirmed message
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get bookingConfirmed;

  /// Failed to confirm booking message
  ///
  /// In en, this message translates to:
  /// **'Failed to confirm booking'**
  String get failedToConfirmBooking;

  /// No bookings found message
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// Error loading bookings message
  ///
  /// In en, this message translates to:
  /// **'Error loading bookings: {error}'**
  String errorLoadingBookings(String error);

  /// Label for WhatsApp share button
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get shareOnWhatsApp;

  /// Title for meeting invitation sharing section
  ///
  /// In en, this message translates to:
  /// **'Share your meeting invitation:'**
  String get shareMeetingInvitation;

  /// Message shown in WhatsApp share dialog
  ///
  /// In en, this message translates to:
  /// **'The meeting is ready! Would you like to send it to your group?'**
  String get meetingReadyMessage;

  /// Hint text for message customization
  ///
  /// In en, this message translates to:
  /// **'Customize your message...'**
  String get customizeMessage;

  /// Label for group recognition checkbox
  ///
  /// In en, this message translates to:
  /// **'Save group for future recognition'**
  String get saveGroupForRecognition;

  /// Label for group name input field
  ///
  /// In en, this message translates to:
  /// **'Group Name (optional)'**
  String get groupNameOptional;

  /// Hint text for group name input
  ///
  /// In en, this message translates to:
  /// **'Enter group name for recognition'**
  String get enterGroupName;

  /// Message shown when a known group is detected
  ///
  /// In en, this message translates to:
  /// **'Known group detected'**
  String get knownGroupDetected;

  /// Success message when meeting is shared
  ///
  /// In en, this message translates to:
  /// **'Meeting shared successfully!'**
  String get meetingSharedSuccessfully;

  /// Message shown after booking confirmation
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed! You can now share the invitation.'**
  String get bookingConfirmedShare;

  /// Default message for WhatsApp sharing
  ///
  /// In en, this message translates to:
  /// **'Hey! I\'ve scheduled a meeting with you through APP-OINT. Click here to confirm or suggest a different time:'**
  String get defaultShareMessage;

  /// Dashboard label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Business dashboard label
  ///
  /// In en, this message translates to:
  /// **'Business Dashboard'**
  String get businessDashboard;

  /// My profile label
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No profile found message
  ///
  /// In en, this message translates to:
  /// **'No profile found'**
  String get noProfileFound;

  /// Error loading profile message
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// My invites label
  ///
  /// In en, this message translates to:
  /// **'My Invites'**
  String get myInvites;

  /// Invite detail label
  ///
  /// In en, this message translates to:
  /// **'Invite Detail'**
  String get inviteDetail;

  /// Invite contact label
  ///
  /// In en, this message translates to:
  /// **'Invite Contact'**
  String get inviteContact;

  /// No invites message
  ///
  /// In en, this message translates to:
  /// **'No invites'**
  String get noInvites;

  /// Error loading invites message
  ///
  /// In en, this message translates to:
  /// **'Error loading invites'**
  String get errorLoadingInvites;

  /// Accept button label
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Decline button label
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Send invite button label
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get sendInvite;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Optional email field label
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// Requires installation fallback message
  ///
  /// In en, this message translates to:
  /// **'Requires installation'**
  String get requiresInstallFallback;

  /// Notifications label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification settings label
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Enable notifications label
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Error fetching token message
  ///
  /// In en, this message translates to:
  /// **'Error fetching token'**
  String get errorFetchingToken;

  /// FCM token display
  ///
  /// In en, this message translates to:
  /// **'FCM Token: {token}'**
  String fcmToken(String token);

  /// Family dashboard label
  ///
  /// In en, this message translates to:
  /// **'Family Dashboard'**
  String get familyDashboard;

  /// Please login for family features message
  ///
  /// In en, this message translates to:
  /// **'Please login to access family features'**
  String get pleaseLoginForFamilyFeatures;

  /// Family members label
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// Invite button label
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// Pending invites label
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvites;

  /// Connected children label
  ///
  /// In en, this message translates to:
  /// **'Connected Children'**
  String get connectedChildren;

  /// No family members yet message
  ///
  /// In en, this message translates to:
  /// **'No family members yet. Invite someone to get started!'**
  String get noFamilyMembersYet;

  /// Error loading family links message
  ///
  /// In en, this message translates to:
  /// **'Error loading family links: {error}'**
  String errorLoadingFamilyLinks(String error);

  /// Invite child button label
  ///
  /// In en, this message translates to:
  /// **'Invite Child'**
  String get inviteChild;

  /// Manage permissions label
  ///
  /// In en, this message translates to:
  /// **'Manage Permissions'**
  String get managePermissions;

  /// Remove child button label
  ///
  /// In en, this message translates to:
  /// **'Remove Child'**
  String get removeChild;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Child email field label
  ///
  /// In en, this message translates to:
  /// **'Child Email'**
  String get childEmail;

  /// Child email or phone field label
  ///
  /// In en, this message translates to:
  /// **'Child Email or Phone'**
  String get childEmailOrPhone;

  /// Enter child email hint
  ///
  /// In en, this message translates to:
  /// **'Enter child email'**
  String get enterChildEmail;

  /// OTP code field label
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCode;

  /// Enter OTP hint
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// Verify button label
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// OTP resent successfully message
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully!'**
  String get otpResentSuccessfully;

  /// Failed to resend OTP message
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP: {error}'**
  String failedToResendOtp(String error);

  /// Child linked successfully message
  ///
  /// In en, this message translates to:
  /// **'Child linked successfully!'**
  String get childLinkedSuccessfully;

  /// Invitation sent successfully message
  ///
  /// In en, this message translates to:
  /// **'Invitation sent successfully!'**
  String get invitationSentSuccessfully;

  /// Failed to send invitation message
  ///
  /// In en, this message translates to:
  /// **'Failed to send invitation: {error}'**
  String failedToSendInvitation(String error);

  /// Please enter valid email message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Please enter valid email or phone message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email or phone'**
  String get pleaseEnterValidEmailOrPhone;

  /// Invalid code message
  ///
  /// In en, this message translates to:
  /// **'Invalid code, please try again'**
  String get invalidCode;

  /// Cancel invite button label
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInvite;

  /// Cancel invite confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this invite?'**
  String get cancelInviteConfirmation;

  /// No button label
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Yes cancel button label
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// Invite cancelled successfully message
  ///
  /// In en, this message translates to:
  /// **'Invite cancelled successfully!'**
  String get inviteCancelledSuccessfully;

  /// Failed to cancel invite message
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel invite: {error}'**
  String failedToCancelInvite(String error);

  /// Revoke access button label
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// Revoke access confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to revoke access for this child? This action cannot be undone.'**
  String get revokeAccessConfirmation;

  /// Revoke button label
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// Access revoked successfully message
  ///
  /// In en, this message translates to:
  /// **'Access revoked successfully!'**
  String get accessRevokedSuccessfully;

  /// Failed to revoke access message
  ///
  /// In en, this message translates to:
  /// **'Failed to revoke access: {error}'**
  String failedToRevokeAccess(String error);

  /// Grant consent button label
  ///
  /// In en, this message translates to:
  /// **'Grant Consent'**
  String get grantConsent;

  /// Revoke consent button label
  ///
  /// In en, this message translates to:
  /// **'Revoke Consent'**
  String get revokeConsent;

  /// Consent granted successfully message
  ///
  /// In en, this message translates to:
  /// **'Consent granted successfully!'**
  String get consentGrantedSuccessfully;

  /// Consent revoked successfully message
  ///
  /// In en, this message translates to:
  /// **'Consent revoked successfully!'**
  String get consentRevokedSuccessfully;

  /// Failed to update consent message
  ///
  /// In en, this message translates to:
  /// **'Failed to update consent: {error}'**
  String failedToUpdateConsent(String error);

  /// Checking permissions message
  ///
  /// In en, this message translates to:
  /// **'Checking permissions...'**
  String get checkingPermissions;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Send now button label
  ///
  /// In en, this message translates to:
  /// **'Send Now'**
  String get sendNow;

  /// Details button label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No broadcast messages message
  ///
  /// In en, this message translates to:
  /// **'No broadcast messages yet'**
  String get noBroadcastMessages;

  /// Error checking permissions message
  ///
  /// In en, this message translates to:
  /// **'Error checking permissions: {error}'**
  String errorCheckingPermissions(String error);

  /// Media optional section title
  ///
  /// In en, this message translates to:
  /// **'Media (Optional)'**
  String get mediaOptional;

  /// Pick image button label
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// Pick video button label
  ///
  /// In en, this message translates to:
  /// **'Pick Video'**
  String get pickVideo;

  /// Poll options label
  ///
  /// In en, this message translates to:
  /// **'Poll Options:'**
  String get pollOptions;

  /// Targeting filters section title
  ///
  /// In en, this message translates to:
  /// **'Targeting Filters'**
  String get targetingFilters;

  /// Scheduling section title
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get scheduling;

  /// Schedule for later option
  ///
  /// In en, this message translates to:
  /// **'Schedule for later'**
  String get scheduleForLater;

  /// Error estimating recipients message
  ///
  /// In en, this message translates to:
  /// **'Error estimating recipients: {error}'**
  String errorEstimatingRecipients(String error);

  /// Error picking image message
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(String error);

  /// Error picking video message
  ///
  /// In en, this message translates to:
  /// **'Error picking video: {error}'**
  String errorPickingVideo(String error);

  /// No permission for broadcast message
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create broadcast messages.'**
  String get noPermissionForBroadcast;

  /// Message saved successfully message
  ///
  /// In en, this message translates to:
  /// **'Message saved successfully'**
  String get messageSavedSuccessfully;

  /// Error saving message
  ///
  /// In en, this message translates to:
  /// **'Error saving message: {error}'**
  String errorSavingMessage(String error);

  /// Message sent successfully message
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get messageSentSuccessfully;

  /// Error sending message
  ///
  /// In en, this message translates to:
  /// **'Error sending message: {error}'**
  String errorSendingMessage(String error);

  /// Content display
  ///
  /// In en, this message translates to:
  /// **'Content: {content}'**
  String content(String content);

  /// Type display
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String type(String type);

  /// Link display
  ///
  /// In en, this message translates to:
  /// **'Link: {link}'**
  String link(String link);

  /// Status display
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status(String status);

  /// Recipients display
  ///
  /// In en, this message translates to:
  /// **'Recipients: {count}'**
  String recipients(String count);

  /// Opened count display
  ///
  /// In en, this message translates to:
  /// **'Opened: {count}'**
  String opened(String count);

  /// Clicked count display
  ///
  /// In en, this message translates to:
  /// **'Clicked: {count}'**
  String clicked(String count);

  /// Created date display
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String created(String date);

  /// Scheduled date display
  ///
  /// In en, this message translates to:
  /// **'Scheduled: {date}'**
  String scheduled(String date);

  /// Organizations screen title
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizations;

  /// No organizations message
  ///
  /// In en, this message translates to:
  /// **'No organizations'**
  String get noOrganizations;

  /// Error loading organizations message
  ///
  /// In en, this message translates to:
  /// **'Error loading organizations'**
  String get errorLoadingOrganizations;

  /// Members count display
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String members(String count);

  /// Users screen title
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No users message
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get noUsers;

  /// Error loading users message
  ///
  /// In en, this message translates to:
  /// **'Error loading users'**
  String get errorLoadingUsers;

  /// Change role button label
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// Total appointments label
  ///
  /// In en, this message translates to:
  /// **'Total Appointments'**
  String get totalAppointments;

  /// Completed appointments label
  ///
  /// In en, this message translates to:
  /// **'Completed Appointments'**
  String get completedAppointments;

  /// Revenue label
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// Error loading stats message
  ///
  /// In en, this message translates to:
  /// **'Error loading stats'**
  String get errorLoadingStats;

  /// Appointment display
  ///
  /// In en, this message translates to:
  /// **'Appointment: {id}'**
  String appointment(String id);

  /// From display
  ///
  /// In en, this message translates to:
  /// **'From: {name}'**
  String from(String name);

  /// Phone display
  ///
  /// In en, this message translates to:
  /// **'Phone: {number}'**
  String phone(String number);

  /// No route defined message
  ///
  /// In en, this message translates to:
  /// **'No route defined for {route}'**
  String noRouteDefined(String route);

  /// Meeting details title
  ///
  /// In en, this message translates to:
  /// **'Meeting Details'**
  String get meetingDetails;

  /// Meeting ID display
  ///
  /// In en, this message translates to:
  /// **'Meeting ID: {id}'**
  String meetingId(String id);

  /// Creator display
  ///
  /// In en, this message translates to:
  /// **'Creator: {id}'**
  String creator(String id);

  /// Context display
  ///
  /// In en, this message translates to:
  /// **'Context: {id}'**
  String context(String id);

  /// Group display
  ///
  /// In en, this message translates to:
  /// **'Group: {id}'**
  String group(String id);

  /// Request private session button label
  ///
  /// In en, this message translates to:
  /// **'Request Private Session'**
  String get requestPrivateSession;

  /// Privacy request sent message
  ///
  /// In en, this message translates to:
  /// **'Privacy request sent to your parents!'**
  String get privacyRequestSent;

  /// Failed to send privacy request message
  ///
  /// In en, this message translates to:
  /// **'Failed to send privacy request: {error}'**
  String failedToSendPrivacyRequest(String error);

  /// Error loading privacy requests message
  ///
  /// In en, this message translates to:
  /// **'Error loading privacy requests: {error}'**
  String errorLoadingPrivacyRequests(String error);

  /// Request type display
  ///
  /// In en, this message translates to:
  /// **'{type} Request'**
  String requestType(String type);

  /// Status with colon display
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusColon(String status);

  /// Failed to action privacy request message
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} privacy request: {error}'**
  String failedToActionPrivacyRequest(String action, String error);

  /// Yes button label
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Send button label
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Permissions label
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// Permissions for child label
  ///
  /// In en, this message translates to:
  /// **'Permissions - {childId}'**
  String permissionsFor(String childId);

  /// Error loading permissions message
  ///
  /// In en, this message translates to:
  /// **'Error loading permissions: {error}'**
  String errorLoadingPermissions(String error);

  /// None option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Read only option
  ///
  /// In en, this message translates to:
  /// **'Read Only'**
  String get readOnly;

  /// Read and write option
  ///
  /// In en, this message translates to:
  /// **'Read & Write'**
  String get readWrite;

  /// Permission updated message
  ///
  /// In en, this message translates to:
  /// **'Permission {category} updated to {newValue}'**
  String permissionUpdated(String category, String newValue);

  /// Failed to update permission message
  ///
  /// In en, this message translates to:
  /// **'Failed to update permission: {error}'**
  String failedToUpdatePermission(String error);

  /// Invited date display
  ///
  /// In en, this message translates to:
  /// **'Invited: {date}'**
  String invited(String date);

  /// Admin broadcast screen title
  ///
  /// In en, this message translates to:
  /// **'Admin Broadcast'**
  String get adminBroadcast;

  /// Compose broadcast message dialog title
  ///
  /// In en, this message translates to:
  /// **'Compose Broadcast Message'**
  String get composeBroadcastMessage;

  /// Admin screen placeholder
  ///
  /// In en, this message translates to:
  /// **'Admin Screen - To Be Developed'**
  String get adminScreenTBD;

  /// Staff screen placeholder
  ///
  /// In en, this message translates to:
  /// **'Staff Screen - To Be Developed'**
  String get staffScreenTBD;

  /// Client screen placeholder
  ///
  /// In en, this message translates to:
  /// **'Client Screen - To Be Developed'**
  String get clientScreenTBD;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bg',
        'cs',
        'da',
        'de',
        'en',
        'es',
        'fi',
        'fr',
        'he',
        'hu',
        'id',
        'it',
        'ja',
        'ko',
        'lt',
        'ms',
        'nl',
        'no',
        'pl',
        'pt',
        'ro',
        'ru',
        'sk',
        'sl',
        'sr',
        'sv',
        'th',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'lt':
      return AppLocalizationsLt();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
