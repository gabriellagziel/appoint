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
import 'app_localizations_ha.dart';
import 'app_localizations_he.dart';
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
import 'app_localizations_uk.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
    Locale('bn', 'BD'),
    Locale('bs'),
    Locale('ca'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fo'),
    Locale('fr'),
    Locale('ga'),
    Locale('gl'),
    Locale('ha'),
    Locale('he'),
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
    Locale('pt', 'BR'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Home screen label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No sessions yet message
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessionsYet;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Prompt to choose play mode
  ///
  /// In en, this message translates to:
  /// **'Choose your play mode:'**
  String get playtimeLandingChooseMode;

  /// Sign up button label
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Schedule message button
  ///
  /// In en, this message translates to:
  /// **'Schedule Message'**
  String get scheduleMessage;

  /// Decline button label
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Admin broadcast title
  ///
  /// In en, this message translates to:
  /// **'Admin Broadcast'**
  String get adminBroadcast;

  /// Login button label
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

  /// Undo button label
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Opened count label
  ///
  /// In en, this message translates to:
  /// **'Opened: {count}'**
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

  /// Redo button label
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// Next button label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Cancel invite confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this invite?'**
  String get cancelInviteConfirmation;

  /// Created status with date
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String created(Object date);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Save Group for Recognition'**
  String get saveGroupForRecognition;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Live playtime scheduled!'**
  String get playtimeLiveScheduled;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to revoke access?'**
  String get revokeAccessConfirmation;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @errorLoadingFamilyLinks.
  ///
  /// In en, this message translates to:
  /// **'Error loading family links: {error}'**
  String errorLoadingFamilyLinks(Object error);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get playtimeCreate;

  /// No description provided for @failedToActionPrivacyRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to action privacy request {action}: {error}'**
  String failedToActionPrivacyRequest(Object action, Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'APP-OINT'**
  String get appTitle;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Virtual Play'**
  String get playtimeModeVirtual;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Enjoy live or virtual games with your friends!'**
  String get playtimeDescription;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Virtual playtime started!'**
  String get playtimeVirtualStarted;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create your first game'**
  String get createYourFirstGame;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Recipients: {count}'**
  String recipients(Object count);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Live Play'**
  String get playtimeModeLive;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Let\'s meet via Appoint!'**
  String get defaultShareMessage;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Playtime Hub'**
  String get playtimeHub;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create Live Session'**
  String get createLiveSession;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Invited: {date}'**
  String invited(Object date);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Content: {content}'**
  String content(Object content);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Meeting shared successfully'**
  String get meetingSharedSuccessfully;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Welcome to Playtime'**
  String get welcomeToPlaytime;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Virtual Play'**
  String get playtimeVirtual;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Staff screen coming soon'**
  String get staffScreenTBD;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Invite cancelled successfully'**
  String get inviteCancelledSuccessfully;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Compose Broadcast Message'**
  String get composeBroadcastMessage;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Send Now'**
  String get sendNow;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get noGamesYet;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Remove Child'**
  String get removeChild;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status(Object status);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create a Playtime Session'**
  String get playtimeCreateSession;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcomingSessions;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Live Play'**
  String get playtimeLive;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Error loading invites'**
  String get errorLoadingInvites;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Targeting Filters'**
  String get targetingFilters;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Pick Video'**
  String get pickVideo;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Game deleted'**
  String get playtimeGameDeleted;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Schedule for Later'**
  String get scheduleForLater;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Access revoked successfully'**
  String get accessRevokedSuccessfully;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String type(Object type);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Checking permissions...'**
  String get checkingPermissions;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get shareOnWhatsApp;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noBroadcastMessages;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Request Type: {type}'**
  String requestType(Object type);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInvite;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get createNew;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get playtimeReject;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Game approved'**
  String get playtimeGameApproved;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Family Dashboard'**
  String get familyDashboard;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get playtimeTitle;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccessfully;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Error checking permissions: {error}'**
  String errorCheckingPermissions(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Client screen coming soon'**
  String get clientScreenTBD;

  /// No description provided for @fcmToken.
  ///
  /// In en, this message translates to:
  /// **'FCM Token: {token}'**
  String fcmToken(Object token);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No profile found'**
  String get noProfileFound;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No family members yet'**
  String get noFamilyMembersYet;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Media (Optional)'**
  String get mediaOptional;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Message saved successfully'**
  String get messageSavedSuccessfully;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Scheduled for'**
  String get scheduledFor;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No permission for broadcast'**
  String get noPermissionForBroadcast;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Playtime Games – Admin'**
  String get playtimeAdminPanelTitle;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Invite Details'**
  String get inviteDetail;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Scheduled: {date}'**
  String scheduled(Object date);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP: {error}'**
  String failedToResendOtp(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get scheduling;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Error saving message: {error}'**
  String errorSavingMessage(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get playtimeApprove;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create your first session'**
  String get createYourFirstSession;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Game rejected'**
  String get playtimeGameRejected;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Failed to revoke access: {error}'**
  String failedToRevokeAccess(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Recent Games'**
  String get recentGames;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Customize Message'**
  String get customizeMessage;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel invite: {error}'**
  String failedToCancelInvite(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Error sending message: {error}'**
  String errorSendingMessage(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Error loading privacy requests: {error}'**
  String errorLoadingPrivacyRequests(Object error);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Connected Children'**
  String get connectedChildren;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Enter game name'**
  String get playtimeEnterGameName;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Please login to access family features'**
  String get pleaseLoginForFamilyFeatures;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'My Invites'**
  String get myInvites;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGame;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Group Name (Optional)'**
  String get groupNameOptional;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'No playtime sessions found.'**
  String get playtimeNoSessions;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Admin screen coming soon'**
  String get adminScreenTBD;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Playtime Dashboard'**
  String get playtimeParentDashboardTitle;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Known group detected'**
  String get knownGroupDetected;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Choose a game'**
  String get playtimeChooseGame;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Manage Permissions'**
  String get managePermissions;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Poll Options'**
  String get pollOptions;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Clicked: {count}'**
  String clicked(Object count);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Link: {link}'**
  String link(Object link);

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Your meeting is ready! Join now'**
  String get meetingReadyMessage;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvites;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusColon(Object status);

  /// No description provided for @pleaseLoginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your profile.'**
  String get pleaseLoginToViewProfile;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Admin Metrics'**
  String get adminMetrics;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @contentLibrary.
  ///
  /// In en, this message translates to:
  /// **'Content Library'**
  String get contentLibrary;

  /// Firebase Auth user-not-found error message
  ///
  /// In en, this message translates to:
  /// **'No account found with this email address.'**
  String get authErrorUserNotFound;

  /// Firebase Auth wrong-password error message
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get authErrorWrongPassword;

  /// Firebase Auth invalid-email error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// Firebase Auth user-disabled error message
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Please contact support.'**
  String get authErrorUserDisabled;

  /// Firebase Auth weak-password error message
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please choose a stronger password.'**
  String get authErrorWeakPassword;

  /// Firebase Auth email-already-in-use error message
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get authErrorEmailAlreadyInUse;

  /// Firebase Auth too-many-requests error message
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please try again later.'**
  String get authErrorTooManyRequests;

  /// Firebase Auth operation-not-allowed error message
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled. Please contact support.'**
  String get authErrorOperationNotAllowed;

  /// Firebase Auth invalid-credential error message
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get authErrorInvalidCredential;

  /// Firebase Auth account-exists-with-different-credential error message
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email using a different sign-in method.'**
  String get authErrorAccountExistsWithDifferentCredential;

  /// Firebase Auth credential-already-in-use error message
  ///
  /// In en, this message translates to:
  /// **'These credentials are already associated with another account.'**
  String get authErrorCredentialAlreadyInUse;

  /// Firebase Auth network-request-failed error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get authErrorNetworkRequestFailed;

  /// Title for social account conflict dialog
  ///
  /// In en, this message translates to:
  /// **'Account Already Exists'**
  String get socialAccountConflictTitle;

  /// Message for social account conflict dialog
  ///
  /// In en, this message translates to:
  /// **'An account with email {email} already exists using a different sign-in method. Would you like to link your accounts?'**
  String socialAccountConflictMessage(Object email);

  /// Button to link social accounts
  ///
  /// In en, this message translates to:
  /// **'Link Accounts'**
  String get linkAccounts;

  /// Button to sign in with existing method
  ///
  /// In en, this message translates to:
  /// **'Sign in with existing method'**
  String get signInWithExistingMethod;

  /// No description provided for @authErrorRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to perform this operation.'**
  String get authErrorRequiresRecentLogin;

  /// No description provided for @authErrorAppNotAuthorized.
  ///
  /// In en, this message translates to:
  /// **'This app is not authorized to use Firebase Authentication.'**
  String get authErrorAppNotAuthorized;

  /// No description provided for @authErrorInvalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid.'**
  String get authErrorInvalidVerificationCode;

  /// No description provided for @authErrorInvalidVerificationId.
  ///
  /// In en, this message translates to:
  /// **'The verification ID is invalid.'**
  String get authErrorInvalidVerificationId;

  /// No description provided for @authErrorMissingVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code.'**
  String get authErrorMissingVerificationCode;

  /// No description provided for @authErrorMissingVerificationId.
  ///
  /// In en, this message translates to:
  /// **'Missing verification ID.'**
  String get authErrorMissingVerificationId;

  /// No description provided for @authErrorInvalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'The phone number is invalid.'**
  String get authErrorInvalidPhoneNumber;

  /// No description provided for @authErrorMissingPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number.'**
  String get authErrorMissingPhoneNumber;

  /// No description provided for @authErrorQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'The SMS quota for this project has been exceeded. Please try again later.'**
  String get authErrorQuotaExceeded;

  /// No description provided for @authErrorCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'The verification code has expired. Please request a new one.'**
  String get authErrorCodeExpired;

  /// No description provided for @authErrorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get authErrorSessionExpired;

  /// No description provided for @authErrorMultiFactorAuthRequired.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication is required.'**
  String get authErrorMultiFactorAuthRequired;

  /// No description provided for @authErrorMultiFactorInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor information not found.'**
  String get authErrorMultiFactorInfoNotFound;

  /// No description provided for @authErrorMissingMultiFactorSession.
  ///
  /// In en, this message translates to:
  /// **'Missing multi-factor session.'**
  String get authErrorMissingMultiFactorSession;

  /// No description provided for @authErrorInvalidMultiFactorSession.
  ///
  /// In en, this message translates to:
  /// **'Invalid multi-factor session.'**
  String get authErrorInvalidMultiFactorSession;

  /// No description provided for @authErrorSecondFactorAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This second factor is already in use.'**
  String get authErrorSecondFactorAlreadyInUse;

  /// No description provided for @authErrorMaximumSecondFactorCountExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of second factors exceeded.'**
  String get authErrorMaximumSecondFactorCountExceeded;

  /// No description provided for @authErrorUnsupportedFirstFactor.
  ///
  /// In en, this message translates to:
  /// **'Unsupported first factor for multi-factor authentication.'**
  String get authErrorUnsupportedFirstFactor;

  /// No description provided for @authErrorEmailChangeNeedsVerification.
  ///
  /// In en, this message translates to:
  /// **'Email change requires verification.'**
  String get authErrorEmailChangeNeedsVerification;

  /// No description provided for @authErrorPhoneNumberAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already in use.'**
  String get authErrorPhoneNumberAlreadyExists;

  /// No description provided for @authErrorInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is invalid or too weak.'**
  String get authErrorInvalidPassword;

  /// No description provided for @authErrorInvalidIdToken.
  ///
  /// In en, this message translates to:
  /// **'The ID token is invalid.'**
  String get authErrorInvalidIdToken;

  /// No description provided for @authErrorIdTokenExpired.
  ///
  /// In en, this message translates to:
  /// **'The ID token has expired.'**
  String get authErrorIdTokenExpired;

  /// No description provided for @authErrorIdTokenRevoked.
  ///
  /// In en, this message translates to:
  /// **'The ID token has been revoked.'**
  String get authErrorIdTokenRevoked;

  /// No description provided for @authErrorInternalError.
  ///
  /// In en, this message translates to:
  /// **'An internal error occurred. Please try again.'**
  String get authErrorInternalError;

  /// No description provided for @authErrorInvalidArgument.
  ///
  /// In en, this message translates to:
  /// **'An invalid argument was provided.'**
  String get authErrorInvalidArgument;

  /// No description provided for @authErrorInvalidClaims.
  ///
  /// In en, this message translates to:
  /// **'Invalid custom claims provided.'**
  String get authErrorInvalidClaims;

  /// No description provided for @authErrorInvalidContinueUri.
  ///
  /// In en, this message translates to:
  /// **'The continue URL is invalid.'**
  String get authErrorInvalidContinueUri;

  /// No description provided for @authErrorInvalidCreationTime.
  ///
  /// In en, this message translates to:
  /// **'The creation time is invalid.'**
  String get authErrorInvalidCreationTime;

  /// No description provided for @authErrorInvalidDisabledField.
  ///
  /// In en, this message translates to:
  /// **'The disabled field value is invalid.'**
  String get authErrorInvalidDisabledField;

  /// No description provided for @authErrorInvalidDisplayName.
  ///
  /// In en, this message translates to:
  /// **'The display name is invalid.'**
  String get authErrorInvalidDisplayName;

  /// No description provided for @authErrorInvalidDynamicLinkDomain.
  ///
  /// In en, this message translates to:
  /// **'The dynamic link domain is invalid.'**
  String get authErrorInvalidDynamicLinkDomain;

  /// No description provided for @authErrorInvalidEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'The email verified value is invalid.'**
  String get authErrorInvalidEmailVerified;

  /// No description provided for @authErrorInvalidHashAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'The hash algorithm is invalid.'**
  String get authErrorInvalidHashAlgorithm;

  /// No description provided for @authErrorInvalidHashBlockSize.
  ///
  /// In en, this message translates to:
  /// **'The hash block size is invalid.'**
  String get authErrorInvalidHashBlockSize;

  /// No description provided for @authErrorInvalidHashDerivedKeyLength.
  ///
  /// In en, this message translates to:
  /// **'The hash derived key length is invalid.'**
  String get authErrorInvalidHashDerivedKeyLength;

  /// No description provided for @authErrorInvalidHashKey.
  ///
  /// In en, this message translates to:
  /// **'The hash key is invalid.'**
  String get authErrorInvalidHashKey;

  /// No description provided for @authErrorInvalidHashMemoryCost.
  ///
  /// In en, this message translates to:
  /// **'The hash memory cost is invalid.'**
  String get authErrorInvalidHashMemoryCost;

  /// No description provided for @authErrorInvalidHashParallelization.
  ///
  /// In en, this message translates to:
  /// **'The hash parallelization is invalid.'**
  String get authErrorInvalidHashParallelization;

  /// No description provided for @authErrorInvalidHashRounds.
  ///
  /// In en, this message translates to:
  /// **'The hash rounds value is invalid.'**
  String get authErrorInvalidHashRounds;

  /// No description provided for @authErrorInvalidHashSaltSeparator.
  ///
  /// In en, this message translates to:
  /// **'The hash salt separator is invalid.'**
  String get authErrorInvalidHashSaltSeparator;

  /// No description provided for @authErrorInvalidLastSignInTime.
  ///
  /// In en, this message translates to:
  /// **'The last sign-in time is invalid.'**
  String get authErrorInvalidLastSignInTime;

  /// No description provided for @authErrorInvalidPageToken.
  ///
  /// In en, this message translates to:
  /// **'The page token is invalid.'**
  String get authErrorInvalidPageToken;

  /// No description provided for @authErrorInvalidProviderData.
  ///
  /// In en, this message translates to:
  /// **'The provider data is invalid.'**
  String get authErrorInvalidProviderData;

  /// No description provided for @authErrorInvalidProviderId.
  ///
  /// In en, this message translates to:
  /// **'The provider ID is invalid.'**
  String get authErrorInvalidProviderId;

  /// No description provided for @authErrorInvalidSessionCookieDuration.
  ///
  /// In en, this message translates to:
  /// **'The session cookie duration is invalid.'**
  String get authErrorInvalidSessionCookieDuration;

  /// No description provided for @authErrorInvalidUid.
  ///
  /// In en, this message translates to:
  /// **'The UID is invalid.'**
  String get authErrorInvalidUid;

  /// No description provided for @authErrorInvalidUserImport.
  ///
  /// In en, this message translates to:
  /// **'The user import record is invalid.'**
  String get authErrorInvalidUserImport;

  /// No description provided for @authErrorMaximumUserCountExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum user import count exceeded.'**
  String get authErrorMaximumUserCountExceeded;

  /// No description provided for @authErrorMissingAndroidPkgName.
  ///
  /// In en, this message translates to:
  /// **'Missing Android package name.'**
  String get authErrorMissingAndroidPkgName;

  /// No description provided for @authErrorMissingContinueUri.
  ///
  /// In en, this message translates to:
  /// **'Missing continue URL.'**
  String get authErrorMissingContinueUri;

  /// No description provided for @authErrorMissingHashAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Missing hash algorithm.'**
  String get authErrorMissingHashAlgorithm;

  /// No description provided for @authErrorMissingIosBundleId.
  ///
  /// In en, this message translates to:
  /// **'Missing iOS bundle ID.'**
  String get authErrorMissingIosBundleId;

  /// No description provided for @authErrorMissingUid.
  ///
  /// In en, this message translates to:
  /// **'Missing UID.'**
  String get authErrorMissingUid;

  /// No description provided for @authErrorMissingOauthClientSecret.
  ///
  /// In en, this message translates to:
  /// **'Missing OAuth client secret.'**
  String get authErrorMissingOauthClientSecret;

  /// No description provided for @authErrorProjectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Firebase project not found.'**
  String get authErrorProjectNotFound;

  /// No description provided for @authErrorReservedClaims.
  ///
  /// In en, this message translates to:
  /// **'Reserved claims provided.'**
  String get authErrorReservedClaims;

  /// No description provided for @authErrorSessionCookieExpired.
  ///
  /// In en, this message translates to:
  /// **'Session cookie has expired.'**
  String get authErrorSessionCookieExpired;

  /// No description provided for @authErrorSessionCookieRevoked.
  ///
  /// In en, this message translates to:
  /// **'Session cookie has been revoked.'**
  String get authErrorSessionCookieRevoked;

  /// No description provided for @authErrorUidAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'The UID is already in use.'**
  String get authErrorUidAlreadyExists;

  /// No description provided for @authErrorUnauthorizedContinueUri.
  ///
  /// In en, this message translates to:
  /// **'The continue URL domain is not whitelisted.'**
  String get authErrorUnauthorizedContinueUri;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown authentication error occurred.'**
  String get authErrorUnknown;

  /// Localization key for: Checking permissions...
  ///
  /// In en, this message translates to:
  /// **'Checking permissions...'**
  String get checkingPermissions1;

  /// Localization key for: Payment Successful!
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// Localization key for: Business Availability
  ///
  /// In en, this message translates to:
  /// **'Business Availability'**
  String get businessAvailability;

  /// Localization key for: Send
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Localization key for: New notification: ${payload.title}
  ///
  /// In en, this message translates to:
  /// **'New notification: {payloadTitle}'**
  String newNotificationPayloadtitle(Object payloadTitle, Object title);

  /// Localization key for: Game List
  ///
  /// In en, this message translates to:
  /// **'Game List'**
  String get gameList;

  /// Localization key for: Delete Availability
  ///
  /// In en, this message translates to:
  /// **'Delete Availability'**
  String get deleteAvailability;

  /// Localization key for: Connect to Google Calendar
  ///
  /// In en, this message translates to:
  /// **'Connect to Google Calendar'**
  String get connectToGoogleCalendar;

  /// Localization key for: Admin Free Access
  ///
  /// In en, this message translates to:
  /// **'Admin Free Access'**
  String get adminFreeAccess;

  /// Localization key for: Email: ${profile.email}
  ///
  /// In en, this message translates to:
  /// **'Email: {profileEmail}'**
  String emailProfileemail(Object email, Object profileEmail);

  /// Localization key for: Calendar
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Localization key for: Upload
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload1;

  /// Localization key for: Resolved
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// Localization key for: Keep Subscription
  ///
  /// In en, this message translates to:
  /// **'Keep Subscription'**
  String get keepSubscription;

  /// Localization key for: Virtual session created! Inviting friends...
  ///
  /// In en, this message translates to:
  /// **'Virtual session created! Inviting friends...'**
  String get virtualSessionCreatedInvitingFriends;

  /// Localization key for: No events scheduled for today
  ///
  /// In en, this message translates to:
  /// **'No events scheduled for today'**
  String get noEventsScheduledForToday;

  /// Localization key for: Export Data
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Localization key for: Rewards
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// Localization key for: Time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Localization key for: User ${c.id}
  ///
  /// In en, this message translates to:
  /// **'User {id}'**
  String userCid(Object cid, Object id);

  /// Localization key for: No slots
  ///
  /// In en, this message translates to:
  /// **'No slots'**
  String get noSlots;

  /// Localization key for: Sign In
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Localization key for: Home Feed Screen
  ///
  /// In en, this message translates to:
  /// **'Home Feed Screen'**
  String get homeFeedScreen;

  /// Localization key for: Select Location
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// Localization key for: No tickets yet
  ///
  /// In en, this message translates to:
  /// **'No tickets yet'**
  String get noTicketsYet;

  /// Localization key for: Meeting shared successfully!
  ///
  /// In en, this message translates to:
  /// **'Meeting shared successfully!'**
  String get meetingSharedSuccessfully1;

  /// Localization key for: Studio Profile
  ///
  /// In en, this message translates to:
  /// **'Studio Profile'**
  String get studioProfile;

  /// Localization key for: Subscription unavailable
  ///
  /// In en, this message translates to:
  /// **'Subscription unavailable'**
  String get subscriptionUnavailable;

  /// Localization key for: Confirm Booking
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Localization key for: Failed to update permission: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to update permission: \$e'**
  String get failedToUpdatePermissionE;

  /// Localization key for: Reject
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Localization key for: Ambassador Status: ${ambassador.status}
  ///
  /// In en, this message translates to:
  /// **'Ambassador Status: {ambassadorStatus}'**
  String ambassadorStatusAmbassadorstatus(Object ambassadorStatus);

  /// Localization key for: No providers
  ///
  /// In en, this message translates to:
  /// **'No providers'**
  String get noProviders;

  /// Localization key for: Checking subscription...
  ///
  /// In en, this message translates to:
  /// **'Checking subscription...'**
  String get checkingSubscription;

  /// Localization key for: Error picking image: $e
  ///
  /// In en, this message translates to:
  /// **'Error picking image: \$e'**
  String errorPickingImageE(Object e);

  /// Localization key for: No content available yet
  ///
  /// In en, this message translates to:
  /// **'No content available yet'**
  String get noContentAvailableYet;

  /// Localization key for: Resolve
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// Localization key for: Error loading surveys: $error
  ///
  /// In en, this message translates to:
  /// **'Error loading surveys: \$error'**
  String get errorLoadingSurveysError;

  /// Localization key for: Error: ${log.errorMessage}
  ///
  /// In en, this message translates to:
  /// **'Error: {errorMessage}'**
  String errorLogerrormessage(Object errorMessage);

  /// Localization key for: Get help with your account
  ///
  /// In en, this message translates to:
  /// **'Get help with your account'**
  String get getHelpWithYourAccount;

  /// Localization key for: Pay
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// Localization key for: No organizations
  ///
  /// In en, this message translates to:
  /// **'No organizations'**
  String get noOrganizations;

  /// Localization key for: Meeting Details
  ///
  /// In en, this message translates to:
  /// **'Meeting Details'**
  String get meetingDetails;

  /// Localization key for: Error loading appointments
  ///
  /// In en, this message translates to:
  /// **'Error loading appointments'**
  String get errorLoadingAppointments;

  /// Localization key for: Changes saved successfully!
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully!'**
  String get changesSavedSuccessfully;

  /// Localization key for: Create New Invoice
  ///
  /// In en, this message translates to:
  /// **'Create New Invoice'**
  String get createNewInvoice;

  /// Localization key for: Profile not found.
  ///
  /// In en, this message translates to:
  /// **'Profile not found.'**
  String get profileNotFound;

  /// Localization key for: Error confirming payment: $e
  ///
  /// In en, this message translates to:
  /// **'Error confirming payment: \$e'**
  String errorConfirmingPaymentE(Object e);

  /// Localization key for: Invite Friends
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// Localization key for: Profile saved!
  ///
  /// In en, this message translates to:
  /// **'Profile saved!'**
  String get profileSaved;

  /// Localization key for: Receive booking notifications via email
  ///
  /// In en, this message translates to:
  /// **'Receive booking notifications via email'**
  String get receiveBookingNotificationsViaEmail;

  /// Localization key for: \$${value.toInt()}K
  ///
  /// In en, this message translates to:
  /// **'\\\${value}K'**
  String valuetointk(Object k, Object value);

  /// Localization key for: Delete Account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Localization key for: Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile1;

  /// Localization key for: Business Onboarding
  ///
  /// In en, this message translates to:
  /// **'Business Onboarding'**
  String get businessOnboarding;

  /// Localization key for: Add New Client
  ///
  /// In en, this message translates to:
  /// **'Add New Client'**
  String get addNewClient;

  /// Localization key for: Dark Mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Localization key for: Add Provider
  ///
  /// In en, this message translates to:
  /// **'Add Provider'**
  String get addProvider;

  /// Localization key for: No route defined for ${state.uri.path}
  ///
  /// In en, this message translates to:
  /// **'No route defined for {path}'**
  String noRouteDefinedForStateuripath(Object path);

  /// Localization key for: You will receive a confirmation email shortly.
  ///
  /// In en, this message translates to:
  /// **'You will receive a confirmation email shortly.'**
  String get youWillReceiveAConfirmationEmailShortly;

  /// Localization key for: Add Question
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// Localization key for: Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Localization key for: ${_branches.length} branches
  ///
  /// In en, this message translates to:
  /// **'{branchCount} branches'**
  String branchesLengthBranches(Object branchCount);

  /// Localization key for: Join
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// Localization key for: Business Subscription
  ///
  /// In en, this message translates to:
  /// **'Business Subscription'**
  String get businessSubscription;

  /// Localization key for: My Invites
  ///
  /// In en, this message translates to:
  /// **'My Invites'**
  String get myInvites1;

  /// Localization key for: Providers
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// Localization key for: Survey Management
  ///
  /// In en, this message translates to:
  /// **'Survey Management'**
  String get surveyManagement;

  /// Localization key for: Please enter a valid email or phone
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email or phone'**
  String get pleaseEnterAValidEmailOrPhone;

  /// Localization key for: No rooms found. Add your first room!
  ///
  /// In en, this message translates to:
  /// **'No rooms found. Add your first room!'**
  String get noRoomsFoundAddYourFirstRoom;

  /// Localization key for: Read our privacy policy
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readOurPrivacyPolicy;

  /// Localization key for: Could not open privacy policy
  ///
  /// In en, this message translates to:
  /// **'Could not open privacy policy'**
  String get couldNotOpenPrivacyPolicy;

  /// Localization key for: Refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh1;

  /// Localization key for: Room updated successfully!
  ///
  /// In en, this message translates to:
  /// **'Room updated successfully!'**
  String get roomUpdatedSuccessfully;

  /// Localization key for: Content Detail
  ///
  /// In en, this message translates to:
  /// **'Content Detail'**
  String get contentDetail;

  /// Localization key for: Cancel Subscription
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// Localization key for: Successfully registered as Ambassador!
  ///
  /// In en, this message translates to:
  /// **'Successfully registered as Ambassador!'**
  String get successfullyRegisteredAsAmbassador;

  /// Localization key for: Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save1;

  /// Localization key for: Copy
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy1;

  /// Localization key for: Failed to send invitation: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to send invitation: \$e'**
  String get failedToSendInvitationE;

  /// Localization key for: Survey Score
  ///
  /// In en, this message translates to:
  /// **'Survey Score'**
  String get surveyScore;

  /// Localization key for: User $userId
  ///
  /// In en, this message translates to:
  /// **'User \$userId'**
  String userUserid(Object userId);

  /// Localization key for: No appointments found.
  ///
  /// In en, this message translates to:
  /// **'No appointments found.'**
  String get noAppointmentsFound;

  /// Localization key for: Response Detail
  ///
  /// In en, this message translates to:
  /// **'Response Detail'**
  String get responseDetail;

  /// Localization key for: Business Verification Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Verification Screen - Coming Soon'**
  String get businessVerificationScreenComingSoon;

  /// Localization key for: Business profile activated successfully!
  ///
  /// In en, this message translates to:
  /// **'Business profile activated successfully!'**
  String get businessProfileActivatedSuccessfully;

  /// Localization key for: Failed to start Pro subscription: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to start Pro subscription: \$e'**
  String get failedToStartProSubscriptionE;

  /// Localization key for: Business Dashboard Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Dashboard Entry Screen - Coming Soon'**
  String get businessDashboardEntryScreenComingSoon;

  /// Localization key for: Content Filter
  ///
  /// In en, this message translates to:
  /// **'Content Filter'**
  String get contentFilter;

  /// Localization key for: Help & Support
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Localization key for: Edit Room
  ///
  /// In en, this message translates to:
  /// **'Edit Room'**
  String get editRoom;

  /// Localization key for: Appointment: ${appt.id}
  ///
  /// In en, this message translates to:
  /// **'Appointment: {appointmentId}'**
  String appointmentApptid(Object appointmentId);

  /// Localization key for: Device: ${log.deviceInfo}
  ///
  /// In en, this message translates to:
  /// **'Device: {deviceInfo}'**
  String deviceLogdeviceinfo(Object deviceInfo);

  /// Localization key for: Business CRM Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business CRM Entry Screen - Coming Soon'**
  String get businessCrmEntryScreenComingSoon;

  /// Localization key for: Admin Dashboard
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// Localization key for: ${org.memberIds.length} members
  ///
  /// In en, this message translates to:
  /// **'{memberCount} members'**
  String orgmemberidslengthMembers(Object memberCount);

  /// Localization key for: Error loading dashboard: $error
  ///
  /// In en, this message translates to:
  /// **'Error loading dashboard: \$error'**
  String get errorLoadingDashboardError;

  /// Localization key for: Game deleted successfully!
  ///
  /// In en, this message translates to:
  /// **'Game deleted successfully!'**
  String get gameDeletedSuccessfully;

  /// Localization key for: View responses - Coming soon!
  ///
  /// In en, this message translates to:
  /// **'View responses - Coming soon!'**
  String get viewResponsesComingSoon;

  /// Localization key for: Delete Provider
  ///
  /// In en, this message translates to:
  /// **'Delete Provider'**
  String get deleteProvider;

  /// Localization key for: Error loading rewards
  ///
  /// In en, this message translates to:
  /// **'Error loading rewards'**
  String get errorLoadingRewards;

  /// Localization key for: Failed to delete account: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: \$e'**
  String get failedToDeleteAccountE;

  /// Localization key for: Invited
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited1;

  /// Localization key for: No branches available
  ///
  /// In en, this message translates to:
  /// **'No branches available'**
  String get noBranchesAvailable;

  /// Localization key for: Error: $error
  ///
  /// In en, this message translates to:
  /// **'Error: \$error'**
  String get errorError;

  /// Localization key for: No events
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get noEvents;

  /// Localization key for: Game created successfully!
  ///
  /// In en, this message translates to:
  /// **'Game created successfully!'**
  String get gameCreatedSuccessfully;

  /// Localization key for: Add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add1;

  /// Localization key for: Creator: $creatorId
  ///
  /// In en, this message translates to:
  /// **'Creator: \$creatorId'**
  String get creatorCreatorid;

  /// Localization key for: ${event.startTime} - ${event.endTime}
  ///
  /// In en, this message translates to:
  /// **'{startTime} - {endTime}'**
  String eventstarttimeEventendtime(Object endTime, Object startTime);

  /// Localization key for: Allow Playtime
  ///
  /// In en, this message translates to:
  /// **'Allow Playtime'**
  String get allowPlaytime;

  /// Localization key for: Clients
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// Localization key for: No ambassador data available
  ///
  /// In en, this message translates to:
  /// **'No ambassador data available'**
  String get noAmbassadorDataAvailable;

  /// Localization key for: Background deleted successfully!
  ///
  /// In en, this message translates to:
  /// **'Background deleted successfully!'**
  String get backgroundDeletedSuccessfully;

  /// Localization key for: Error: ${snapshot.error}
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorSnapshoterror(Object error);

  /// Localization key for: No analytics data available yet.
  ///
  /// In en, this message translates to:
  /// **'No analytics data available yet.'**
  String get noAnalyticsDataAvailableYet;

  /// Localization key for: Error deleting slot: $e
  ///
  /// In en, this message translates to:
  /// **'Error deleting slot: \$e'**
  String errorDeletingSlotE(Object e);

  /// Localization key for: Business Phone Booking Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Phone Booking Entry Screen - Coming Soon'**
  String get businessPhoneBookingEntryScreenComingSoon;

  /// Localization key for: Verification
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// Localization key for: Copy Link
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// Localization key for: Dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard1;

  /// Localization key for: Manage Child Accounts
  ///
  /// In en, this message translates to:
  /// **'Manage Child Accounts'**
  String get manageChildAccounts;

  /// Localization key for: Grant Consent
  ///
  /// In en, this message translates to:
  /// **'Grant Consent'**
  String get grantConsent;

  /// Localization key for: My Profile
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile1;

  /// Localization key for: Submit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Localization key for: User: ${log.userEmail}
  ///
  /// In en, this message translates to:
  /// **'User: {userEmail}'**
  String userLoguseremail(Object userEmail);

  /// Localization key for: Email Notifications
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Localization key for: Ambassador Dashboard
  ///
  /// In en, this message translates to:
  /// **'Ambassador Dashboard'**
  String get ambassadorDashboard;

  /// Localization key for: Phone Booking
  ///
  /// In en, this message translates to:
  /// **'Phone Booking'**
  String get phoneBooking;

  /// Localization key for: Book via Chat
  ///
  /// In en, this message translates to:
  /// **'Book via Chat'**
  String get bookViaChat;

  /// Localization key for: Error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Localization key for: Business Profile
  ///
  /// In en, this message translates to:
  /// **'Business Profile'**
  String get businessProfile;

  /// Localization key for: Business Booking Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Booking Entry Screen - Coming Soon'**
  String get businessBookingEntryScreenComingSoon;

  /// Localization key for: Create New Survey
  ///
  /// In en, this message translates to:
  /// **'Create New Survey'**
  String get createNewSurvey;

  /// Localization key for: Background rejected
  ///
  /// In en, this message translates to:
  /// **'Background rejected'**
  String get backgroundRejected;

  /// Localization key for: No media selected
  ///
  /// In en, this message translates to:
  /// **'No media selected'**
  String get noMediaSelected;

  /// Localization key for: Sync to Google
  ///
  /// In en, this message translates to:
  /// **'Sync to Google'**
  String get syncToGoogle;

  /// Localization key for: Virtual Playtime
  ///
  /// In en, this message translates to:
  /// **'Virtual Playtime'**
  String get virtualPlaytime;

  /// Localization key for: Color Contrast Testing
  ///
  /// In en, this message translates to:
  /// **'Color Contrast Testing'**
  String get colorContrastTesting;

  /// Localization key for: Login failed: $e
  ///
  /// In en, this message translates to:
  /// **'Login failed: \$e'**
  String get loginFailedE;

  /// Localization key for: Invitation sent successfully!
  ///
  /// In en, this message translates to:
  /// **'Invitation sent successfully!'**
  String get invitationSentSuccessfully;

  /// Localization key for: Registering...
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registering;

  /// Localization key for: Status: ${appointment.status.name}
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusAppointmentstatusname(Object status);

  /// Localization key for: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home1;

  /// Localization key for: Error saving settings: $e
  ///
  /// In en, this message translates to:
  /// **'Error saving settings: \$e'**
  String get errorSavingSettingsE;

  /// Localization key for: App version and information
  ///
  /// In en, this message translates to:
  /// **'App version and information'**
  String get appVersionAndInformation;

  /// Localization key for: Business Subscription Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Subscription Entry Screen - Coming Soon'**
  String get businessSubscriptionEntryScreenComingSoon;

  /// Localization key for: ${e.key}: ${e.value}
  ///
  /// In en, this message translates to:
  /// **'{key}: {value}'**
  String ekeyEvalue(Object key, Object value);

  /// Localization key for: Your payment has been processed successfully.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been processed successfully.'**
  String get yourPaymentHasBeenProcessedSuccessfully;

  /// Localization key for: Error: $e
  ///
  /// In en, this message translates to:
  /// **'Error: \$e'**
  String get errorE;

  /// Localization key for: View All
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll1;

  /// Localization key for: Edit survey - Coming soon!
  ///
  /// In en, this message translates to:
  /// **'Edit survey - Coming soon!'**
  String get editSurveyComingSoon;

  /// Localization key for: Enter OTP
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// Localization key for: Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Localization key for: Automatically confirm new booking requests
  ///
  /// In en, this message translates to:
  /// **'Automatically confirm new booking requests'**
  String get automaticallyConfirmNewBookingRequests;

  /// Localization key for: Error picking video: $e
  ///
  /// In en, this message translates to:
  /// **'Error picking video: \$e'**
  String errorPickingVideoE(Object e);

  /// Localization key for: No route defined for ${settings.name}
  ///
  /// In en, this message translates to:
  /// **'No route defined for {settingsName}'**
  String noRouteDefinedForSettingsname(Object settingsName);

  /// Localization key for: Please sign in to upload a background
  ///
  /// In en, this message translates to:
  /// **'Please sign in to upload a background'**
  String get pleaseSignInToUploadABackground;

  /// Localization key for: ${log.targetType}: ${log.targetId}
  ///
  /// In en, this message translates to:
  /// **'{targetType}: {targetId}'**
  String logtargettypeLogtargetid(Object targetId, Object targetType);

  /// Localization key for: Staff Availability
  ///
  /// In en, this message translates to:
  /// **'Staff Availability'**
  String get staffAvailability;

  /// Localization key for: Live Playtime
  ///
  /// In en, this message translates to:
  /// **'Live Playtime'**
  String get livePlaytime;

  /// Localization key for: Auto-Confirm Bookings
  ///
  /// In en, this message translates to:
  /// **'Auto-Confirm Bookings'**
  String get autoconfirmBookings;

  /// Localization key for: Redirecting to Stripe checkout for Pro plan...
  ///
  /// In en, this message translates to:
  /// **'Redirecting to Stripe checkout for Pro plan...'**
  String get redirectingToStripeCheckoutForProPlan;

  /// Localization key for: Export as CSV
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportAsCsv;

  /// Localization key for: Delete functionality coming soon!
  ///
  /// In en, this message translates to:
  /// **'Delete functionality coming soon!'**
  String get deleteFunctionalityComingSoon;

  /// Localization key for: Edit Client
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClient;

  /// Localization key for: Are you sure you want to delete this message?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get areYouSureYouWantToDeleteThisMessage;

  /// Localization key for: Referrals: ${ambassador.referrals}
  ///
  /// In en, this message translates to:
  /// **'Referrals: {referrals}'**
  String referralsAmbassadorreferrals(Object referrals);

  /// Localization key for: Not authenticated
  ///
  /// In en, this message translates to:
  /// **'Not authenticated'**
  String get notAuthenticated;

  /// Localization key for: Privacy request sent to your parents!
  ///
  /// In en, this message translates to:
  /// **'Privacy request sent to your parents!'**
  String get privacyRequestSentToYourParents;

  /// Localization key for: Client deleted successfully!
  ///
  /// In en, this message translates to:
  /// **'Client deleted successfully!'**
  String get clientDeletedSuccessfully;

  /// Localization key for: Failed to cancel subscription
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel subscription'**
  String get failedToCancelSubscription;

  /// Localization key for: All Languages
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get allLanguages;

  /// Localization key for: Slot deleted successfully
  ///
  /// In en, this message translates to:
  /// **'Slot deleted successfully'**
  String get slotDeletedSuccessfully;

  /// Localization key for: Business Providers Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Providers Entry Screen - Coming Soon'**
  String get businessProvidersEntryScreenComingSoon;

  /// Localization key for: Parents must approve before children can join
  ///
  /// In en, this message translates to:
  /// **'Parents must approve before children can join'**
  String get parentsMustApproveBeforeChildrenCanJoin;

  /// Localization key for: Subscribe to Pro (€14.99/mo)
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Pro (€14.99/mo)'**
  String get subscribeToPro1499mo;

  /// Localization key for: Business Availability Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Availability Entry Screen - Coming Soon'**
  String get businessAvailabilityEntryScreenComingSoon;

  /// Localization key for: Appointments: ${list.length}
  ///
  /// In en, this message translates to:
  /// **'Appointments: {count}'**
  String appointmentsListlength(Object count);

  /// Localization key for: Clear Filters
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Localization key for: Submit Booking
  ///
  /// In en, this message translates to:
  /// **'Submit Booking'**
  String get submitBooking;

  /// Localization key for: Are you sure you want to cancel this appointment?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get areYouSureYouWantToCancelThisAppointment;

  /// Localization key for: No upcoming bookings
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get noUpcomingBookings;

  /// Localization key for: Go Back
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Localization key for: Setup
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// Localization key for: Invite Child
  ///
  /// In en, this message translates to:
  /// **'Invite Child'**
  String get inviteChild;

  /// Localization key for: Go to Dashboard
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// Localization key for: Ambassador Quota Dashboard
  ///
  /// In en, this message translates to:
  /// **'Ambassador Quota Dashboard'**
  String get ambassadorQuotaDashboard;

  /// Localization key for: Admin Settings
  ///
  /// In en, this message translates to:
  /// **'Admin Settings'**
  String get adminSettings;

  /// Localization key for: Referral Code
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// Localization key for: Admin: ${log.adminEmail}
  ///
  /// In en, this message translates to:
  /// **'Admin: {adminEmail}'**
  String adminLogadminemail(Object adminEmail);

  /// Localization key for: Date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Localization key for: Read Only
  ///
  /// In en, this message translates to:
  /// **'Read Only'**
  String get readOnly;

  /// Localization key for: Booking Request
  ///
  /// In en, this message translates to:
  /// **'Booking Request'**
  String get bookingRequest;

  /// Localization key for: • Advanced reporting
  ///
  /// In en, this message translates to:
  /// **'• Advanced reporting'**
  String get advancedReporting;

  /// Localization key for: Rooms
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// Localization key for: Copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Localization key for: Booking Confirmed
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get bookingConfirmed;

  /// Localization key for: Session approved!
  ///
  /// In en, this message translates to:
  /// **'Session approved!'**
  String get sessionApproved;

  /// Localization key for: Client added successfully!
  ///
  /// In en, this message translates to:
  /// **'Client added successfully!'**
  String get clientAddedSuccessfully;

  /// Localization key for: No notifications
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// Localization key for: Background approved!
  ///
  /// In en, this message translates to:
  /// **'Background approved!'**
  String get backgroundApproved;

  /// Localization key for: Family Support
  ///
  /// In en, this message translates to:
  /// **'Family Support'**
  String get familySupport;

  /// Localization key for: Deleting account...
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccount;

  /// Localization key for: Book Appointment
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// Localization key for: Receive push notifications for new bookings
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications for new bookings'**
  String get receivePushNotificationsForNewBookings;

  /// Localization key for: Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete1;

  /// Localization key for: Send Booking Invite
  ///
  /// In en, this message translates to:
  /// **'Send Booking Invite'**
  String get sendBookingInvite;

  /// Localization key for: Text
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// Localization key for: Manage Subscription
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// Localization key for: Requires Install Fallback
  ///
  /// In en, this message translates to:
  /// **'Requires Install Fallback'**
  String get requiresInstallFallback;

  /// Localization key for: Payment Confirmation
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmation'**
  String get paymentConfirmation;

  /// Localization key for: Promo applied! Your next bill is free.
  ///
  /// In en, this message translates to:
  /// **'Promo applied! Your next bill is free.'**
  String get promoAppliedYourNextBillIsFree;

  /// Localization key for: Invitee: ${args.inviteeId}
  ///
  /// In en, this message translates to:
  /// **'Invitee: {inviteeId}'**
  String inviteeArgsinviteeid(Object inviteeId);

  /// Localization key for: Error loading slots
  ///
  /// In en, this message translates to:
  /// **'Error loading slots'**
  String get errorLoadingSlots;

  /// Localization key for: Allow other users to find and join this game
  ///
  /// In en, this message translates to:
  /// **'Allow other users to find and join this game'**
  String get allowOtherUsersToFindAndJoinThisGame;

  /// Localization key for: Business Onboarding Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Onboarding Screen - Coming Soon'**
  String get businessOnboardingScreenComingSoon;

  /// Localization key for: Activate Business Profile
  ///
  /// In en, this message translates to:
  /// **'Activate Business Profile'**
  String get activateBusinessProfile;

  /// Localization key for: Content not found
  ///
  /// In en, this message translates to:
  /// **'Content not found'**
  String get contentNotFound;

  /// Localization key for: ${p.specialty}\n${p.contactInfo}
  ///
  /// In en, this message translates to:
  /// **'{specialty}\\n{contactInfo}'**
  String pspecialtynpcontactinfo(Object contactInfo, Object specialty);

  /// Localization key for: Rating
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Localization key for: Messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Localization key for: Error estimating recipients: $e
  ///
  /// In en, this message translates to:
  /// **'Error estimating recipients: \$e'**
  String errorEstimatingRecipientsE(Object e);

  /// Localization key for: Become an Ambassador
  ///
  /// In en, this message translates to:
  /// **'Become an Ambassador'**
  String get becomeAnAmbassador;

  /// Localization key for: Subscribe Now
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// Localization key for: Time: ${args.slot.format(context)}
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String timeArgsslotformatcontext(Object time);

  /// Localization key for: Share via WhatsApp
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get shareViaWhatsapp;

  /// Localization key for: Users
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users1;

  /// Localization key for: Share Link
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get shareLink;

  /// Localization key for: Are you sure you want to delete this provider?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this provider?'**
  String get areYouSureYouWantToDeleteThisProvider;

  /// Localization key for: Delete Appointment
  ///
  /// In en, this message translates to:
  /// **'Delete Appointment'**
  String get deleteAppointment;

  /// Localization key for: Toggle Availability
  ///
  /// In en, this message translates to:
  /// **'Toggle Availability'**
  String get toggleAvailability;

  /// Localization key for: Change Plan
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlan;

  /// Localization key for: Error loading staff
  ///
  /// In en, this message translates to:
  /// **'Error loading staff'**
  String get errorLoadingStaff;

  /// Localization key for: Error loading configuration: $e
  ///
  /// In en, this message translates to:
  /// **'Error loading configuration: \$e'**
  String errorLoadingConfigurationE(Object e);

  /// Localization key for: Update your business information
  ///
  /// In en, this message translates to:
  /// **'Update your business information'**
  String get updateYourBusinessInformation;

  /// Localization key for: No providers found. Add your first provider!
  ///
  /// In en, this message translates to:
  /// **'No providers found. Add your first provider!'**
  String get noProvidersFoundAddYourFirstProvider;

  /// Localization key for: Parent Dashboard
  ///
  /// In en, this message translates to:
  /// **'Parent Dashboard'**
  String get parentDashboard;

  /// Localization key for: Menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Localization key for: Studio Booking
  ///
  /// In en, this message translates to:
  /// **'Studio Booking'**
  String get studioBooking;

  /// Localization key for: About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about1;

  /// Localization key for: Multiple Choice
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get multipleChoice;

  /// Localization key for: Date: ${appointment.scheduledAt.toString()}
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateAppointmentscheduledattostring(Object date);

  /// Localization key for: Studio booking is only available on web
  ///
  /// In en, this message translates to:
  /// **'Studio booking is only available on web'**
  String get studioBookingIsOnlyAvailableOnWeb;

  /// Localization key for: Error loading branches: $e
  ///
  /// In en, this message translates to:
  /// **'Error loading branches: \$e'**
  String get errorLoadingBranchesE;

  /// Localization key for: \uD83D\uDCC5 ${booking.dateTime.toLocal()}
  ///
  /// In en, this message translates to:
  /// **'\\uD83D\\uDCC5 {dateTime}'**
  String ud83dudcc5Bookingdatetimetolocal(Object dateTime);

  /// Localization key for: Appointment: ${invite.appointmentId}
  ///
  /// In en, this message translates to:
  /// **'Appointment: {appointmentId}'**
  String appointmentInviteappointmentid(Object appointmentId);

  /// Localization key for: None
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Localization key for: Failed to update consent: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to update consent: \$e'**
  String get failedToUpdateConsentE;

  /// Localization key for: Welcome
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome1;

  /// Localization key for: Failed to create session: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to create session: \$e'**
  String get failedToCreateSessionE;

  /// Localization key for: Invite Contact
  ///
  /// In en, this message translates to:
  /// **'Invite Contact'**
  String get inviteContact;

  /// Localization key for: Survey Editor
  ///
  /// In en, this message translates to:
  /// **'Survey Editor'**
  String get surveyEditor;

  /// Localization key for: Failed to start Basic subscription: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to start Basic subscription: \$e'**
  String get failedToStartBasicSubscriptionE;

  /// Localization key for: My Schedule
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get mySchedule;

  /// Localization key for: Studio Dashboard
  ///
  /// In en, this message translates to:
  /// **'Studio Dashboard'**
  String get studioDashboard;

  /// Localization key for: Edit Profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Localization key for: Logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout1;

  /// Localization key for: Service: ${serviceId ?? "Not selected"}
  ///
  /// In en, this message translates to:
  /// **'Service: {service}'**
  String serviceServiceidNotSelected(Object service);

  /// Localization key for: Settings saved successfully!
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSavedSuccessfully;

  /// Localization key for: Link copied to clipboard!
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard!'**
  String get linkCopiedToClipboard;

  /// Localization key for: Accept
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept1;

  /// Localization key for: No available slots
  ///
  /// In en, this message translates to:
  /// **'No available slots'**
  String get noAvailableSlots;

  /// Localization key for: Make Game Public
  ///
  /// In en, this message translates to:
  /// **'Make Game Public'**
  String get makeGamePublic;

  /// Localization key for: Permission ${permission.category} updated to $newValue
  ///
  /// In en, this message translates to:
  /// **'Permission {category} updated to \$newValue'**
  String permissionPermissioncategoryUpdatedToNewvalue(Object category);

  /// Localization key for: Room deleted successfully!
  ///
  /// In en, this message translates to:
  /// **'Room deleted successfully!'**
  String get roomDeletedSuccessfully;

  /// Localization key for: Business Calendar
  ///
  /// In en, this message translates to:
  /// **'Business Calendar'**
  String get businessCalendar;

  /// Localization key for: Add Availability
  ///
  /// In en, this message translates to:
  /// **'Add Availability'**
  String get addAvailability;

  /// Localization key for: Ambassador Onboarding
  ///
  /// In en, this message translates to:
  /// **'Ambassador Onboarding'**
  String get ambassadorOnboarding;

  /// Localization key for: Phone: ${profileAsync.phone}
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String phoneProfileasyncphone(Object phone);

  /// Localization key for: Add New Room
  ///
  /// In en, this message translates to:
  /// **'Add New Room'**
  String get addNewRoom;

  /// Localization key for: Require Parent Approval
  ///
  /// In en, this message translates to:
  /// **'Require Parent Approval'**
  String get requireParentApproval;

  /// Localization key for: Closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// Localization key for: Export as PDF
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// Localization key for: Enable Vibration
  ///
  /// In en, this message translates to:
  /// **'Enable Vibration'**
  String get enableVibration;

  /// Localization key for: To: ${avail.end.format(context)}
  ///
  /// In en, this message translates to:
  /// **'To: {endTime}'**
  String toAvailendformatcontext(Object endTime);

  /// Localization key for: Your upgrade code: $upgradeCode
  ///
  /// In en, this message translates to:
  /// **'Your upgrade code: \$upgradeCode'**
  String yourUpgradeCodeUpgradecode(Object upgradeCode);

  /// Localization key for: Request Private Session
  ///
  /// In en, this message translates to:
  /// **'Request Private Session'**
  String get requestPrivateSession;

  /// Localization key for: Country
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Localization key for: Login Screen
  ///
  /// In en, this message translates to:
  /// **'Login Screen'**
  String get loginScreen;

  /// Localization key for: Staff: ${args.staff.displayName}
  ///
  /// In en, this message translates to:
  /// **'Staff: {staffName}'**
  String staffArgsstaffdisplayname(Object staffName);

  /// Localization key for: Revoke Consent
  ///
  /// In en, this message translates to:
  /// **'Revoke Consent'**
  String get revokeConsent;

  /// Localization key for: Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings1;

  /// Localization key for: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel1;

  /// Localization key for: Subscription activated successfully!
  ///
  /// In en, this message translates to:
  /// **'Subscription activated successfully!'**
  String get subscriptionActivatedSuccessfully;

  /// Localization key for: Activity: ${log.action}
  ///
  /// In en, this message translates to:
  /// **'Activity: {action}'**
  String activityLogaction(Object action);

  /// Localization key for: Broadcast
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// Localization key for: No events scheduled this week
  ///
  /// In en, this message translates to:
  /// **'No events scheduled this week'**
  String get noEventsScheduledThisWeek;

  /// Localization key for: Google Calendar
  ///
  /// In en, this message translates to:
  /// **'Google Calendar'**
  String get googleCalendar;

  /// Localization key for: Send Invite
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get sendInvite;

  /// Localization key for: Child Dashboard
  ///
  /// In en, this message translates to:
  /// **'Child Dashboard'**
  String get childDashboard;

  /// Localization key for: Failed to upload background: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to upload background: \$e'**
  String get failedToUploadBackgroundE;

  /// Localization key for: ${link.childId.substring(0, 8)}...
  ///
  /// In en, this message translates to:
  /// **'{linkId}...'**
  String linkchildidsubstring08(Object linkId);

  /// Localization key for: Target: ${log.targetType} - ${log.targetId}
  ///
  /// In en, this message translates to:
  /// **'Target: {targetType} - {targetId}'**
  String targetLogtargettypeLogtargetid(Object targetId, Object targetType);

  /// Localization key for: Context: $contextId
  ///
  /// In en, this message translates to:
  /// **'Context: \$contextId'**
  String get contextContextid;

  /// Localization key for: No appointments
  ///
  /// In en, this message translates to:
  /// **'No appointments'**
  String get noAppointments;

  /// Localization key for: • Unlimited bookings per week
  ///
  /// In en, this message translates to:
  /// **'• Unlimited bookings per week'**
  String get unlimitedBookingsPerWeek;

  /// Localization key for: Error Details: ${log.errorType}
  ///
  /// In en, this message translates to:
  /// **'Error Details: {errorType}'**
  String errorDetailsLogerrortype(Object errorType, Object logErrorType);

  /// Localization key for: Scheduled at: $scheduledAt
  ///
  /// In en, this message translates to:
  /// **'Scheduled at: \$scheduledAt'**
  String get scheduledAtScheduledat;

  /// Localization key for: Select Staff
  ///
  /// In en, this message translates to:
  /// **'Select Staff'**
  String get selectStaff;

  /// Localization key for: Subscription cancelled successfully
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled successfully'**
  String get subscriptionCancelledSuccessfully;

  /// Localization key for: Please log in to view your profile.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your profile.'**
  String get pleaseLogInToViewYourProfile;

  /// Localization key for: Cancel Appointment
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointment;

  /// Localization key for: Permissions - ${familyLink.childId}
  ///
  /// In en, this message translates to:
  /// **'Permissions - {childId}'**
  String permissionsFamilylinkchildid(Object childId);

  /// Localization key for: Business Signup
  ///
  /// In en, this message translates to:
  /// **'Business Signup'**
  String get businessSignup;

  /// Localization key for: Business Completion Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Completion Screen - Coming Soon'**
  String get businessCompletionScreenComingSoon;

  /// Localization key for: Create Game
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGame1;

  /// Localization key for: ${value.toInt()}
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String valuetoint(Object value);

  /// Localization key for: Please enter a promo code
  ///
  /// In en, this message translates to:
  /// **'Please enter a promo code'**
  String get pleaseEnterAPromoCode;

  /// Localization key for: Error loading availability: $e
  ///
  /// In en, this message translates to:
  /// **'Error loading availability: \$e'**
  String get errorLoadingAvailabilityE;

  /// Localization key for: Parental Controls
  ///
  /// In en, this message translates to:
  /// **'Parental Controls'**
  String get parentalControls;

  /// Localization key for: Edit Business Profile
  ///
  /// In en, this message translates to:
  /// **'Edit Business Profile'**
  String get editBusinessProfile;

  /// Localization key for: Child linked successfully!
  ///
  /// In en, this message translates to:
  /// **'Child linked successfully!'**
  String get childLinkedSuccessfully;

  /// Localization key for: Create
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Localization key for: No external meetings found.
  ///
  /// In en, this message translates to:
  /// **'No external meetings found.'**
  String get noExternalMeetingsFound;

  /// Localization key for: Staff: ${selection.staff.displayName}
  ///
  /// In en, this message translates to:
  /// **'Staff: {staffName}'**
  String staffSelectionstaffdisplayname(Object staffName);

  /// Localization key for: Please enter a valid email address
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// Localization key for: Scheduler Screen
  ///
  /// In en, this message translates to:
  /// **'Scheduler Screen'**
  String get schedulerScreen;

  /// Localization key for: Client updated successfully!
  ///
  /// In en, this message translates to:
  /// **'Client updated successfully!'**
  String get clientUpdatedSuccessfully;

  /// Localization key for: Survey Responses
  ///
  /// In en, this message translates to:
  /// **'Survey Responses'**
  String get surveyResponses;

  /// Localization key for: Sync to Outlook
  ///
  /// In en, this message translates to:
  /// **'Sync to Outlook'**
  String get syncToOutlook;

  /// Localization key for: Save Changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Localization key for: Pick Time
  ///
  /// In en, this message translates to:
  /// **'Pick Time'**
  String get pickTime;

  /// Localization key for: Registration failed: ${e.toString()}
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {error}'**
  String registrationFailedEtostring(Object error);

  /// Localization key for: Analytics
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Localization key for: Error loading events
  ///
  /// In en, this message translates to:
  /// **'Error loading events'**
  String get errorLoadingEvents;

  /// Localization key for: Error loading organizations
  ///
  /// In en, this message translates to:
  /// **'Error loading organizations'**
  String get errorLoadingOrganizations;

  /// Localization key for: Business Login Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Login Screen - Coming Soon'**
  String get businessLoginScreenComingSoon;

  /// Localization key for: Success
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success1;

  /// Localization key for: App Version: ${log.appVersion}
  ///
  /// In en, this message translates to:
  /// **'App Version: {appVersion}'**
  String appVersionLogappversion(Object appVersion);

  /// Localization key for: From: ${avail.start.format(context)}
  ///
  /// In en, this message translates to:
  /// **'From: {startTime}'**
  String fromAvailstartformatcontext(Object startTime);

  /// Localization key for: Read & Write
  ///
  /// In en, this message translates to:
  /// **'Read & Write'**
  String get readWrite;

  /// Localization key for: Redirecting to Stripe checkout for Basic plan...
  ///
  /// In en, this message translates to:
  /// **'Redirecting to Stripe checkout for Basic plan...'**
  String get redirectingToStripeCheckoutForBasicPlan;

  /// Localization key for: Error saving configuration: $e
  ///
  /// In en, this message translates to:
  /// **'Error saving configuration: \$e'**
  String get errorSavingConfigurationE;

  /// Localization key for: Pick Date
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// Localization key for: Chat Booking
  ///
  /// In en, this message translates to:
  /// **'Chat Booking'**
  String get chatBooking;

  /// Localization key for: No questions added
  ///
  /// In en, this message translates to:
  /// **'No questions added'**
  String get noQuestionsAdded;

  /// Localization key for: Severity: ${log.severity.name}
  ///
  /// In en, this message translates to:
  /// **'Severity: {severity}'**
  String severityLogseverityname(Object severity);

  /// Localization key for: Mark as Paid
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get markAsPaid;

  /// Localization key for: Type: Open Call
  ///
  /// In en, this message translates to:
  /// **'Type: Open Call'**
  String get typeOpenCall;

  /// Localization key for: Appointment ${appointment.id}
  ///
  /// In en, this message translates to:
  /// **'Appointment {appointmentId}'**
  String appointmentAppointmentid(Object appointmentId);

  /// Localization key for: Status: ${invite.status.name}
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusInvitestatusname(Object inviteStatusName, Object status);

  /// Localization key for: Business Login
  ///
  /// In en, this message translates to:
  /// **'Business Login'**
  String get businessLogin;

  /// Localization key for: Invoice created successfully!
  ///
  /// In en, this message translates to:
  /// **'Invoice created successfully!'**
  String get invoiceCreatedSuccessfully;

  /// Localization key for: No time series data available
  ///
  /// In en, this message translates to:
  /// **'No time series data available'**
  String get noTimeSeriesDataAvailable;

  /// Localization key for: Subscribe to ${widget.planName}
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {planName}'**
  String subscribeToWidgetplanname(Object planName);

  /// Localization key for: Timestamp: ${_formatDate(log.timestamp)}
  ///
  /// In en, this message translates to:
  /// **'Timestamp: {timestamp}'**
  String timestamp_formatdatelogtimestamp(Object timestamp);

  /// Localization key for: Failed to send privacy request: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to send privacy request: \$e'**
  String get failedToSendPrivacyRequestE;

  /// Localization key for: Choose Your Plan
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get chooseYourPlan;

  /// Localization key for: Playtime Management
  ///
  /// In en, this message translates to:
  /// **'Playtime Management'**
  String get playtimeManagement;

  /// Localization key for: Availability
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// Localization key for: Event created
  ///
  /// In en, this message translates to:
  /// **'Event created'**
  String get eventCreated;

  /// Localization key for: Subscribe to Basic (€4.99/mo)
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Basic (€4.99/mo)'**
  String get subscribeToBasic499mo;

  /// Localization key for: Completion
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// Localization key for: Support ticket submitted
  ///
  /// In en, this message translates to:
  /// **'Support ticket submitted'**
  String get supportTicketSubmitted;

  /// Localization key for: Monetization Settings
  ///
  /// In en, this message translates to:
  /// **'Monetization Settings'**
  String get monetizationSettings;

  /// Localization key for: No bookings found
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// Localization key for: Admin
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Localization key for: Delete Survey
  ///
  /// In en, this message translates to:
  /// **'Delete Survey'**
  String get deleteSurvey;

  /// Localization key for: Game approved successfully!
  ///
  /// In en, this message translates to:
  /// **'Game approved successfully!'**
  String get gameApprovedSuccessfully;

  /// Localization key for: Error loading permissions: $error
  ///
  /// In en, this message translates to:
  /// **'Error loading permissions: \$error'**
  String get errorLoadingPermissionsError;

  /// Localization key for: Referrals
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get referrals;

  /// Localization key for: CRM
  ///
  /// In en, this message translates to:
  /// **'CRM'**
  String get crm;

  /// Localization key for: Game rejected
  ///
  /// In en, this message translates to:
  /// **'Game rejected'**
  String get gameRejected;

  /// Localization key for: Appointments
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// Localization key for: Onboarding Screen
  ///
  /// In en, this message translates to:
  /// **'Onboarding Screen'**
  String get onboardingScreen;

  /// Localization key for: Welcome to your studio
  ///
  /// In en, this message translates to:
  /// **'Welcome to your studio'**
  String get welcomeToYourStudio;

  /// Localization key for: Update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Localization key for: Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry1;

  /// Localization key for: Booking
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// Localization key for: Parental Settings
  ///
  /// In en, this message translates to:
  /// **'Parental Settings'**
  String get parentalSettings;

  /// Localization key for: Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Localization key for: Delete Slot
  ///
  /// In en, this message translates to:
  /// **'Delete Slot'**
  String get deleteSlot;

  /// Localization key for: Organizations
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizations;

  /// Localization key for: Configuration saved successfully!
  ///
  /// In en, this message translates to:
  /// **'Configuration saved successfully!'**
  String get configurationSavedSuccessfully;

  /// Localization key for: Create New Game
  ///
  /// In en, this message translates to:
  /// **'Create New Game'**
  String get createNewGame;

  /// Localization key for: Next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next1;

  /// Localization key for: Background uploaded successfully!
  ///
  /// In en, this message translates to:
  /// **'Background uploaded successfully!'**
  String get backgroundUploadedSuccessfully;

  /// Localization key for: No appointment requests found.
  ///
  /// In en, this message translates to:
  /// **'No appointment requests found.'**
  String get noAppointmentRequestsFound;

  /// Localization key for: Please sign in to create a session
  ///
  /// In en, this message translates to:
  /// **'Please sign in to create a session'**
  String get pleaseSignInToCreateASession;

  /// Localization key for: Restrict mature content
  ///
  /// In en, this message translates to:
  /// **'Restrict mature content'**
  String get restrictMatureContent;

  /// Localization key for: Ambassadors
  ///
  /// In en, this message translates to:
  /// **'Ambassadors'**
  String get ambassadors;

  /// Localization key for: SMS Notifications
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// Localization key for: Payment was cancelled
  ///
  /// In en, this message translates to:
  /// **'Payment was cancelled'**
  String get paymentWasCancelled;

  /// Localization key for: Clear All
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Localization key for: View Details
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Localization key for: Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications1;

  /// Localization key for: Live session scheduled! Waiting for parent approval...
  ///
  /// In en, this message translates to:
  /// **'Live session scheduled! Waiting for parent approval...'**
  String get liveSessionScheduledWaitingForParentApproval;

  /// Localization key for: Failed to create game: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to create game: \$e'**
  String get failedToCreateGameE;

  /// Localization key for: No chart data available
  ///
  /// In en, this message translates to:
  /// **'No chart data available'**
  String get noChartDataAvailable;

  /// Localization key for: • Phone-based booking system
  ///
  /// In en, this message translates to:
  /// **'• Phone-based booking system'**
  String get phonebasedBookingSystem;

  /// Localization key for: Enable Notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications1;

  /// Localization key for: Invoices
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// Localization key for: Please activate your business profile to continue.
  ///
  /// In en, this message translates to:
  /// **'Please activate your business profile to continue.'**
  String get pleaseActivateYourBusinessProfileToContinue;

  /// Localization key for: Scheduled at: ${args.scheduledAt}
  ///
  /// In en, this message translates to:
  /// **'Scheduled at: {scheduledAt}'**
  String scheduledAtArgsscheduledat(Object scheduledAt);

  /// Localization key for: Duration: ${duration?.inMinutes ?? 0} minutes
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration} minutes'**
  String durationDurationinminutes0Minutes(Object duration);

  /// Localization key for: Try Again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Localization key for: Delete Background
  ///
  /// In en, this message translates to:
  /// **'Delete Background'**
  String get deleteBackground;

  /// Localization key for: Current Tier: ${tier.toUpperCase()}
  ///
  /// In en, this message translates to:
  /// **'Current Tier: {tier}'**
  String currentTierTiertouppercase(Object tier);

  /// Localization key for: I Do Not Consent
  ///
  /// In en, this message translates to:
  /// **'I Do Not Consent'**
  String get iDoNotConsent;

  /// Localization key for: No clients found. Add your first client!
  ///
  /// In en, this message translates to:
  /// **'No clients found. Add your first client!'**
  String get noClientsFoundAddYourFirstClient;

  /// Localization key for: Settings dialog will be implemented here.
  ///
  /// In en, this message translates to:
  /// **'Settings dialog will be implemented here.'**
  String get settingsDialogWillBeImplementedHere;

  /// Localization key for: Group: $groupId
  ///
  /// In en, this message translates to:
  /// **'Group: \$groupId'**
  String get groupGroupid;

  /// Localization key for: Appointment Requests
  ///
  /// In en, this message translates to:
  /// **'Appointment Requests'**
  String get appointmentRequests;

  /// Localization key for: Forward
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// Localization key for: Room added successfully!
  ///
  /// In en, this message translates to:
  /// **'Room added successfully!'**
  String get roomAddedSuccessfully;

  /// Localization key for: • $option
  ///
  /// In en, this message translates to:
  /// **'• \$option'**
  String get option;

  /// Localization key for: Response #${index + 1}
  ///
  /// In en, this message translates to:
  /// **'Response #{number}'**
  String responseIndex1(Object number);

  /// Localization key for: • CRM dashboard with analytics
  ///
  /// In en, this message translates to:
  /// **'• CRM dashboard with analytics'**
  String get crmDashboardWithAnalytics;

  /// Localization key for: Content Library
  ///
  /// In en, this message translates to:
  /// **'Content Library'**
  String get contentLibrary1;

  /// Localization key for: Reply
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// Localization key for: Subscription Management
  ///
  /// In en, this message translates to:
  /// **'Subscription Management'**
  String get subscriptionManagement;

  /// Localization key for: Monetization settings will be implemented here
  ///
  /// In en, this message translates to:
  /// **'Monetization settings will be implemented here'**
  String get monetizationSettingsWillBeImplementedHere;

  /// Localization key for: Failed to apply promo code: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to apply promo code: \$e'**
  String get failedToApplyPromoCodeE;

  /// Localization key for: Edit Provider
  ///
  /// In en, this message translates to:
  /// **'Edit Provider'**
  String get editProvider;

  /// Localization key for: Localization Contribution
  ///
  /// In en, this message translates to:
  /// **'Localization Contribution'**
  String get localizationContribution;

  /// Localization key for: Parental Consent
  ///
  /// In en, this message translates to:
  /// **'Parental Consent'**
  String get parentalConsent;

  /// Localization key for: Business Signup Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Signup Screen - Coming Soon'**
  String get businessSignupScreenComingSoon;

  /// Localization key for: Are you sure you want to delete this appointment?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment?'**
  String get areYouSureYouWantToDeleteThisAppointment;

  /// Localization key for: Sync Appointment
  ///
  /// In en, this message translates to:
  /// **'Sync Appointment'**
  String get syncAppointment;

  /// Localization key for: I Consent
  ///
  /// In en, this message translates to:
  /// **'I Consent'**
  String get iConsent;

  /// Localization key for: Session rejected
  ///
  /// In en, this message translates to:
  /// **'Session rejected'**
  String get sessionRejected;

  /// Localization key for: Business Setup Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Setup Screen - Coming Soon'**
  String get businessSetupScreenComingSoon;

  /// Localization key for: Edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit1;

  /// Localization key for: No events scheduled this month
  ///
  /// In en, this message translates to:
  /// **'No events scheduled this month'**
  String get noEventsScheduledThisMonth;

  /// Localization key for: Business Dashboard
  ///
  /// In en, this message translates to:
  /// **'Business Dashboard'**
  String get businessDashboard;

  /// Localization key for: No messages found.
  ///
  /// In en, this message translates to:
  /// **'No messages found.'**
  String get noMessagesFound;

  /// Localization key for: Staff: ${staffId ?? "Not selected"}
  ///
  /// In en, this message translates to:
  /// **'Staff: {staff}'**
  String staffStaffidNotSelected(Object staff);

  /// Localization key for: Manage Staff Availability
  ///
  /// In en, this message translates to:
  /// **'Manage Staff Availability'**
  String get manageStaffAvailability;

  /// Localization key for: No missing translations
  ///
  /// In en, this message translates to:
  /// **'No missing translations'**
  String get noMissingTranslations;

  /// Localization key for: Skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Localization key for: Meeting ID: $meetingId
  ///
  /// In en, this message translates to:
  /// **'Meeting ID: \$meetingId'**
  String meetingIdMeetingid(Object meetingId);

  /// Localization key for: No users
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get noUsers;

  /// Localization key for: Error loading referral code
  ///
  /// In en, this message translates to:
  /// **'Error loading referral code'**
  String get errorLoadingReferralCode;

  /// Localization key for: All Countries
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get allCountries;

  /// Localization key for: Delete Game
  ///
  /// In en, this message translates to:
  /// **'Delete Game'**
  String get deleteGame;

  /// Localization key for: • Staff management tools
  ///
  /// In en, this message translates to:
  /// **'• Staff management tools'**
  String get staffManagementTools;

  /// Localization key for: Delete Message
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deleteMessage;

  /// Localization key for: Receive booking notifications via SMS
  ///
  /// In en, this message translates to:
  /// **'Receive booking notifications via SMS'**
  String get receiveBookingNotificationsViaSms;

  /// Localization key for: Change Role
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// Localization key for: Error loading bookings: ${snapshot.error}
  ///
  /// In en, this message translates to:
  /// **'Error loading bookings: {error}'**
  String errorLoadingBookingsSnapshoterror(Object error);

  /// Localization key for: Opening customer portal...
  ///
  /// In en, this message translates to:
  /// **'Opening customer portal...'**
  String get openingCustomerPortal;

  /// Localization key for: Sign Out
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Localization key for: Name: ${profile.name}
  ///
  /// In en, this message translates to:
  /// **'Name: {name}'**
  String nameProfilename(Object name);

  /// Localization key for: Business Profile Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Profile Entry Screen - Coming Soon'**
  String get businessProfileEntryScreenComingSoon;

  /// Localization key for: Upgrade to Business
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Business'**
  String get upgradeToBusiness;

  /// Localization key for: Apply
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Localization key for: Error loading subscription: $error
  ///
  /// In en, this message translates to:
  /// **'Error loading subscription: \$error'**
  String errorLoadingSubscriptionError(Object error);

  /// Localization key for: Error loading users
  ///
  /// In en, this message translates to:
  /// **'Error loading users'**
  String get errorLoadingUsers;

  /// Localization key for: Verify
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Localization key for: Subscription
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// Localization key for: Delete My Account
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMyAccount;

  /// Localization key for: Business Appointments Entry Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Appointments Entry Screen - Coming Soon'**
  String get businessAppointmentsEntryScreenComingSoon;

  /// Localization key for: View Responses
  ///
  /// In en, this message translates to:
  /// **'View Responses'**
  String get viewResponses;

  /// Localization key for: Business Welcome Screen - Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Business Welcome Screen - Coming Soon'**
  String get businessWelcomeScreenComingSoon;

  /// Localization key for: Failed to open customer portal: $e
  ///
  /// In en, this message translates to:
  /// **'Failed to open customer portal: \$e'**
  String failedToOpenCustomerPortalE(Object e);

  /// Localization key for: Continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Localization key for: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close1;

  /// Localization key for: Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm1;

  /// Localization key for: External Meetings
  ///
  /// In en, this message translates to:
  /// **'External Meetings'**
  String get externalMeetings;

  /// Localization key for: Approve
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Localization key for: No invoices found. Create your first invoice!
  ///
  /// In en, this message translates to:
  /// **'No invoices found. Create your first invoice!'**
  String get noInvoicesFoundCreateYourFirstInvoice;

  /// Localization key for: Subscribe
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// Localization key for: Login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login1;

  /// Localization key for: Admin overview goes here
  ///
  /// In en, this message translates to:
  /// **'Admin overview goes here'**
  String get adminOverviewGoesHere;

  /// Localization key for: Loading checkout...
  ///
  /// In en, this message translates to:
  /// **'Loading checkout...'**
  String get loadingCheckout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['am', 'ar', 'bg', 'bn', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'en', 'es', 'et', 'eu', 'fa', 'fi', 'fo', 'fr', 'ga', 'gl', 'ha', 'he', 'hi', 'hr', 'hu', 'id', 'is', 'it', 'ja', 'ko', 'lt', 'lv', 'mk', 'ms', 'mt', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sq', 'sr', 'sv', 'th', 'tr', 'uk', 'ur', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return AppLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'bn': {
  switch (locale.countryCode) {
    case 'BD': return AppLocalizationsBnBd();
   }
  break;
   }
    case 'es': {
  switch (locale.countryCode) {
    case '419': return AppLocalizationsEs419();
   }
  break;
   }
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am': return AppLocalizationsAm();
    case 'ar': return AppLocalizationsAr();
    case 'bg': return AppLocalizationsBg();
    case 'bn': return AppLocalizationsBn();
    case 'bs': return AppLocalizationsBs();
    case 'ca': return AppLocalizationsCa();
    case 'cs': return AppLocalizationsCs();
    case 'cy': return AppLocalizationsCy();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'eu': return AppLocalizationsEu();
    case 'fa': return AppLocalizationsFa();
    case 'fi': return AppLocalizationsFi();
    case 'fo': return AppLocalizationsFo();
    case 'fr': return AppLocalizationsFr();
    case 'ga': return AppLocalizationsGa();
    case 'gl': return AppLocalizationsGl();
    case 'ha': return AppLocalizationsHa();
    case 'he': return AppLocalizationsHe();
    case 'hi': return AppLocalizationsHi();
    case 'hr': return AppLocalizationsHr();
    case 'hu': return AppLocalizationsHu();
    case 'id': return AppLocalizationsId();
    case 'is': return AppLocalizationsIs();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'lt': return AppLocalizationsLt();
    case 'lv': return AppLocalizationsLv();
    case 'mk': return AppLocalizationsMk();
    case 'ms': return AppLocalizationsMs();
    case 'mt': return AppLocalizationsMt();
    case 'nl': return AppLocalizationsNl();
    case 'no': return AppLocalizationsNo();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ro': return AppLocalizationsRo();
    case 'ru': return AppLocalizationsRu();
    case 'sk': return AppLocalizationsSk();
    case 'sl': return AppLocalizationsSl();
    case 'sq': return AppLocalizationsSq();
    case 'sr': return AppLocalizationsSr();
    case 'sv': return AppLocalizationsSv();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'ur': return AppLocalizationsUr();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
