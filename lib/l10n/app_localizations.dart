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

  /// Firebase Auth REDACTED_TOKEN error message
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email using a different sign-in method.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid.'**
  String get REDACTED_TOKEN;

  /// No description provided for @authErrorInvalidVerificationId.
  ///
  /// In en, this message translates to:
  /// **'The verification ID is invalid.'**
  String get authErrorInvalidVerificationId;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication is required.'**
  String get REDACTED_TOKEN;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor information not found.'**
  String get REDACTED_TOKEN;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Missing multi-factor session.'**
  String get REDACTED_TOKEN;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Invalid multi-factor session.'**
  String get REDACTED_TOKEN;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'This second factor is already in use.'**
  String get REDACTED_TOKEN;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of second factors exceeded.'**
  String get REDACTED_TOKEN;

  /// No description provided for @authErrorUnsupportedFirstFactor.
  ///
  /// In en, this message translates to:
  /// **'Unsupported first factor for multi-factor authentication.'**
  String get authErrorUnsupportedFirstFactor;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Email change requires verification.'**
  String get REDACTED_TOKEN;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already in use.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The dynamic link domain is invalid.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The hash derived key length is invalid.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The hash parallelization is invalid.'**
  String get REDACTED_TOKEN;

  /// No description provided for @authErrorInvalidHashRounds.
  ///
  /// In en, this message translates to:
  /// **'The hash rounds value is invalid.'**
  String get authErrorInvalidHashRounds;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The hash salt separator is invalid.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The session cookie duration is invalid.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Maximum user import count exceeded.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Missing OAuth client secret.'**
  String get REDACTED_TOKEN;

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

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'The continue URL domain is not whitelisted.'**
  String get REDACTED_TOKEN;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown authentication error occurred.'**
  String get authErrorUnknown;
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
        'ha',
        'he',
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
        'uk',
        'ur',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'bn':
      {
        switch (locale.countryCode) {
          case 'BD':
            return AppLocalizationsBnBd();
        }
        break;
      }
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

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
    case 'ha':
      return AppLocalizationsHa();
    case 'he':
      return AppLocalizationsHe();
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
    case 'uk':
      return AppLocalizationsUk();
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
