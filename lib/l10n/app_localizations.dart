import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fo.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
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
    Locale('am'),
    Locale('ar'),
    Locale('bg'),
    Locale('bn'),
    Locale('bs'),
    Locale('ca'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fo'),
    Locale('fr'),
    Locale('ga'),
    Locale('gl'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('is'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('lv'),
    Locale('mk'),
    Locale('ms'),
    Locale('mt'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh')
  ];

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No sessions yet message
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessionsYet;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Playtime landing choose mode message
  ///
  /// In en, this message translates to:
  /// **'Choose your play mode:'**
  String get playtimeLandingChooseMode;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Schedule message button
  ///
  /// In en, this message translates to:
  /// **'Schedule Message'**
  String get scheduleMessage;

  /// Decline button
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Admin broadcast title
  ///
  /// In en, this message translates to:
  /// **'Admin Broadcast'**
  String get adminBroadcast;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Choose friends label
  ///
  /// In en, this message translates to:
  /// **'Choose friends to invite'**
  String get playtimeChooseFriends;

  /// No invites message
  ///
  /// In en, this message translates to:
  /// **'No invites'**
  String get noInvites;

  /// Choose time label
  ///
  /// In en, this message translates to:
  /// **'Choose a time'**
  String get playtimeChooseTime;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Undo button text
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Opened status
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String opened(Object count);

  /// Create virtual session button
  ///
  /// In en, this message translates to:
  /// **'Create Virtual Session'**
  String get createVirtualSession;

  /// Message sent successfully message
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get messageSentSuccessfully;

  /// Redo button text
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Cancel invite confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this invite?'**
  String get cancelInviteConfirmation;

  /// Created status
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String created(Object date);

  /// Revoke access button
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// Save group for recognition label
  ///
  /// In en, this message translates to:
  /// **'Save Group for Recognition'**
  String get saveGroupForRecognition;

  /// Live playtime scheduled message
  ///
  /// In en, this message translates to:
  /// **'Live playtime scheduled!'**
  String get playtimeLiveScheduled;

  /// Revoke access confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to revoke access?'**
  String get revokeAccessConfirmation;

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Error loading family links message
  ///
  /// In en, this message translates to:
  /// **'Error loading family links'**
  String errorLoadingFamilyLinks(Object error);

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get playtimeCreate;

  /// Failed to action privacy request message
  ///
  /// In en, this message translates to:
  /// **'Failed to action privacy request'**
  String failedToActionPrivacyRequest(Object action, Object error);

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'APP-OINT'**
  String get appTitle;

  /// Accept button
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Virtual play mode label
  ///
  /// In en, this message translates to:
  /// **'Virtual Play'**
  String get playtimeModeVirtual;

  /// Playtime description
  ///
  /// In en, this message translates to:
  /// **'Enjoy live or virtual games with your friends!'**
  String get playtimeDescription;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Virtual playtime started message
  ///
  /// In en, this message translates to:
  /// **'Virtual playtime started!'**
  String get playtimeVirtualStarted;

  /// Create your first game message
  ///
  /// In en, this message translates to:
  /// **'Create your first game'**
  String get createYourFirstGame;

  /// Participants label
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// Recipients label
  ///
  /// In en, this message translates to:
  /// **'Recipients'**
  String recipients(Object count);

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Invite button
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// Live play mode label
  ///
  /// In en, this message translates to:
  /// **'Live Play'**
  String get playtimeModeLive;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Default share message
  ///
  /// In en, this message translates to:
  /// **'Let\'s meet via Appoint!'**
  String get defaultShareMessage;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Playtime hub title
  ///
  /// In en, this message translates to:
  /// **'Playtime Hub'**
  String get playtimeHub;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Create live session button
  ///
  /// In en, this message translates to:
  /// **'Create Live Session'**
  String get createLiveSession;

  /// Enable notifications label
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Invited status
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String invited(Object date);

  /// Content label
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String content(Object content);

  /// Meeting shared successfully message
  ///
  /// In en, this message translates to:
  /// **'Meeting shared successfully'**
  String get meetingSharedSuccessfully;

  /// Welcome to playtime message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Playtime'**
  String get welcomeToPlaytime;

  /// View all button
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Virtual play label
  ///
  /// In en, this message translates to:
  /// **'Virtual Play'**
  String get playtimeVirtual;

  /// Staff screen TBD message
  ///
  /// In en, this message translates to:
  /// **'Staff screen coming soon'**
  String get staffScreenTBD;

  /// Cut button text
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// Invite cancelled successfully message
  ///
  /// In en, this message translates to:
  /// **'Invite cancelled successfully'**
  String get inviteCancelledSuccessfully;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Compose broadcast message title
  ///
  /// In en, this message translates to:
  /// **'Compose Broadcast Message'**
  String get composeBroadcastMessage;

  /// Send now button
  ///
  /// In en, this message translates to:
  /// **'Send Now'**
  String get sendNow;

  /// No games yet message
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get noGamesYet;

  /// Select button text
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// About navigation label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Choose button text
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Remove child button
  ///
  /// In en, this message translates to:
  /// **'Remove Child'**
  String get removeChild;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String status(Object status);

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Paste button text
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Create playtime session button
  ///
  /// In en, this message translates to:
  /// **'Create a Playtime Session'**
  String get playtimeCreateSession;

  /// Family members label
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// Upload button text
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Upcoming sessions label
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcomingSessions;

  /// Enter group name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Live play label
  ///
  /// In en, this message translates to:
  /// **'Live Play'**
  String get playtimeLive;

  /// Error loading invites message
  ///
  /// In en, this message translates to:
  /// **'Error loading invites'**
  String get errorLoadingInvites;

  /// Targeting filters label
  ///
  /// In en, this message translates to:
  /// **'Targeting Filters'**
  String get targetingFilters;

  /// Pick video button
  ///
  /// In en, this message translates to:
  /// **'Pick Video'**
  String get pickVideo;

  /// Game deleted message
  ///
  /// In en, this message translates to:
  /// **'Game deleted'**
  String get playtimeGameDeleted;

  /// Schedule for later button
  ///
  /// In en, this message translates to:
  /// **'Schedule for Later'**
  String get scheduleForLater;

  /// Access revoked successfully message
  ///
  /// In en, this message translates to:
  /// **'Access revoked successfully'**
  String get accessRevokedSuccessfully;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String type(Object type);

  /// Checking permissions message
  ///
  /// In en, this message translates to:
  /// **'Checking permissions...'**
  String get checkingPermissions;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Yes cancel button
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Share on WhatsApp button
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get shareOnWhatsApp;

  /// Notification settings title
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// My profile title
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Revoke button
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// No broadcast messages message
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noBroadcastMessages;

  /// Request type label
  ///
  /// In en, this message translates to:
  /// **'Request Type'**
  String requestType(Object type);

  /// Notifications title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Details label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Cancel invite button
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInvite;

  /// Create new button
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get createNew;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Playtime reject button
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get playtimeReject;

  /// Error loading profile message
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Game approved message
  ///
  /// In en, this message translates to:
  /// **'Game approved'**
  String get playtimeGameApproved;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Family dashboard title
  ///
  /// In en, this message translates to:
  /// **'Family Dashboard'**
  String get familyDashboard;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Quick actions label
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Playtime title
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get playtimeTitle;

  /// OTP resent successfully message
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccessfully;

  /// Error checking permissions message
  ///
  /// In en, this message translates to:
  /// **'Error checking permissions'**
  String errorCheckingPermissions(Object error);

  /// Client screen TBD message
  ///
  /// In en, this message translates to:
  /// **'Client screen coming soon'**
  String get clientScreenTBD;

  /// FCM token label
  ///
  /// In en, this message translates to:
  /// **'FCM Token'**
  String fcmToken(Object token);

  /// Pick image button
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No profile found message
  ///
  /// In en, this message translates to:
  /// **'No profile found'**
  String get noProfileFound;

  /// No family members yet message
  ///
  /// In en, this message translates to:
  /// **'No family members yet'**
  String get noFamilyMembersYet;

  /// Media optional label
  ///
  /// In en, this message translates to:
  /// **'Media (Optional)'**
  String get mediaOptional;

  /// Message saved successfully message
  ///
  /// In en, this message translates to:
  /// **'Message saved successfully'**
  String get messageSavedSuccessfully;

  /// Scheduled for label
  ///
  /// In en, this message translates to:
  /// **'Scheduled for'**
  String get scheduledFor;

  /// Dashboard title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No permission for broadcast message
  ///
  /// In en, this message translates to:
  /// **'No permission for broadcast'**
  String get noPermissionForBroadcast;

  /// Playtime admin panel title
  ///
  /// In en, this message translates to:
  /// **'Playtime Games – Admin'**
  String get playtimeAdminPanelTitle;

  /// Invite detail title
  ///
  /// In en, this message translates to:
  /// **'Invite Details'**
  String get inviteDetail;

  /// Scheduled status
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String scheduled(Object date);

  /// Failed to resend OTP message
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP'**
  String failedToResendOtp(Object error);

  /// Scheduling label
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get scheduling;

  /// Error saving message message
  ///
  /// In en, this message translates to:
  /// **'Error saving message'**
  String errorSavingMessage(Object error);

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Playtime approve button
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get playtimeApprove;

  /// Create your first session message
  ///
  /// In en, this message translates to:
  /// **'Create your first session'**
  String get createYourFirstSession;

  /// Game rejected message
  ///
  /// In en, this message translates to:
  /// **'Game rejected'**
  String get playtimeGameRejected;

  /// Failed to revoke access message
  ///
  /// In en, this message translates to:
  /// **'Failed to revoke access'**
  String failedToRevokeAccess(Object error);

  /// Recent games label
  ///
  /// In en, this message translates to:
  /// **'Recent Games'**
  String get recentGames;

  /// Customize message button
  ///
  /// In en, this message translates to:
  /// **'Customize Message'**
  String get customizeMessage;

  /// Failed to cancel invite message
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel invite'**
  String failedToCancelInvite(Object error);

  /// Error sending message message
  ///
  /// In en, this message translates to:
  /// **'Error sending message'**
  String errorSendingMessage(Object error);

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Error loading privacy requests message
  ///
  /// In en, this message translates to:
  /// **'Error loading privacy requests'**
  String errorLoadingPrivacyRequests(Object error);

  /// Connected children label
  ///
  /// In en, this message translates to:
  /// **'Connected Children'**
  String get connectedChildren;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Enter game name label
  ///
  /// In en, this message translates to:
  /// **'Enter game name'**
  String get playtimeEnterGameName;

  /// Please login for family features message
  ///
  /// In en, this message translates to:
  /// **'Please login to access family features'**
  String get pleaseLoginForFamilyFeatures;

  /// My invites title
  ///
  /// In en, this message translates to:
  /// **'My Invites'**
  String get myInvites;

  /// Create game button
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGame;

  /// Group name optional label
  ///
  /// In en, this message translates to:
  /// **'Group Name (Optional)'**
  String get groupNameOptional;

  /// No playtime sessions message
  ///
  /// In en, this message translates to:
  /// **'No playtime sessions found.'**
  String get playtimeNoSessions;

  /// Admin screen TBD message
  ///
  /// In en, this message translates to:
  /// **'Admin screen coming soon'**
  String get adminScreenTBD;

  /// Playtime parent dashboard title
  ///
  /// In en, this message translates to:
  /// **'Playtime Dashboard'**
  String get playtimeParentDashboardTitle;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Known group detected message
  ///
  /// In en, this message translates to:
  /// **'Known group detected'**
  String get knownGroupDetected;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Choose game label
  ///
  /// In en, this message translates to:
  /// **'Choose a game'**
  String get playtimeChooseGame;

  /// Manage permissions button
  ///
  /// In en, this message translates to:
  /// **'Manage Permissions'**
  String get managePermissions;

  /// Poll options label
  ///
  /// In en, this message translates to:
  /// **'Poll Options'**
  String get pollOptions;

  /// Clicked status
  ///
  /// In en, this message translates to:
  /// **'Clicked'**
  String clicked(Object count);

  /// Link label
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String link(Object link);

  /// Meeting ready message
  ///
  /// In en, this message translates to:
  /// **'Your meeting is ready! Join now'**
  String get meetingReadyMessage;

  /// Pending invites label
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvites;

  /// Status colon label
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String statusColon(Object status);
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
        'am',
        'ar',
        'bg',
        'bn',
        'bs',
        'ca',
        'cs',
        'cy',
        'da',
        'de',
        'en',
        'es',
        'et',
        'eu',
        'fa',
        'fi',
        'fo',
        'fr',
        'ga',
        'gl',
        'hi',
        'hr',
        'hu',
        'id',
        'is',
        'it',
        'ja',
        'ko',
        'lt',
        'lv',
        'mk',
        'ms',
        'mt',
        'nl',
        'no',
        'pl',
        'pt',
        'ro',
        'ru',
        'sk',
        'sl',
        'sq',
        'sr',
        'sv',
        'th',
        'tr',
        'ur',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'bn':
      return AppLocalizationsBn();
    case 'bs':
      return AppLocalizationsBs();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fo':
      return AppLocalizationsFo();
    case 'fr':
      return AppLocalizationsFr();
    case 'ga':
      return AppLocalizationsGa();
    case 'gl':
      return AppLocalizationsGl();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mk':
      return AppLocalizationsMk();
    case 'ms':
      return AppLocalizationsMs();
    case 'mt':
      return AppLocalizationsMt();
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
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
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
