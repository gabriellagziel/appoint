import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @playtimeSystemTest.
  ///
  /// In en, this message translates to:
  /// **'Playtime System Test'**
  String get playtimeSystemTest;

  /// No description provided for @REDACTED_TOKEN.
  ///
  /// In en, this message translates to:
  /// **'Playtime System Implementation Test'**
  String get REDACTED_TOKEN;

  /// No description provided for @playtimeGameModel.
  ///
  /// In en, this message translates to:
  /// **'PlaytimeGame Model'**
  String get playtimeGameModel;

  /// No description provided for @playtimeSessionModel.
  ///
  /// In en, this message translates to:
  /// **'PlaytimeSession Model'**
  String get playtimeSessionModel;

  /// No description provided for @playtimeBackgroundModel.
  ///
  /// In en, this message translates to:
  /// **'PlaytimeBackground Model'**
  String get playtimeBackgroundModel;

  /// No description provided for @meetingWithPlaytimeSupport.
  ///
  /// In en, this message translates to:
  /// **'Meeting with Playtime Support'**
  String get meetingWithPlaytimeSupport;

  /// No description provided for @playtimeServiceMethods.
  ///
  /// In en, this message translates to:
  /// **'PlaytimeService Methods'**
  String get playtimeServiceMethods;

  /// No description provided for @riverpodProviders.
  ///
  /// In en, this message translates to:
  /// **'Riverpod Providers'**
  String get riverpodProviders;

  /// No description provided for @phase1ImplementationComplete.
  ///
  /// In en, this message translates to:
  /// **'🎉 PHASE 1 Implementation Complete!'**
  String get phase1ImplementationComplete;

  /// No description provided for @allCoreModelsCreated.
  ///
  /// In en, this message translates to:
  /// **'✅ All core models created\n✅ Service layer implemented\n✅ Providers configured\n✅ MeetingType.playtime support added\n✅ Parent approval workflow ready\n✅ Safety features included'**
  String get allCoreModelsCreated;

  /// No description provided for @pwaSystemImplementation.
  ///
  /// In en, this message translates to:
  /// **'PWA System Implementation'**
  String get pwaSystemImplementation;

  /// No description provided for @testPwaPrompt.
  ///
  /// In en, this message translates to:
  /// **'Test PWA Prompt'**
  String get testPwaPrompt;

  /// No description provided for @simulateMeetingCreation.
  ///
  /// In en, this message translates to:
  /// **'Simulate Meeting Creation'**
  String get simulateMeetingCreation;

  /// No description provided for @nextStepsPhase2.
  ///
  /// In en, this message translates to:
  /// **'📋 Next Steps for PHASE 2'**
  String get nextStepsPhase2;

  /// No description provided for @nextStepsPhase2Details.
  ///
  /// In en, this message translates to:
  /// **'1. Create UI components\n2. Implement Firestore collections\n3. Add parent approval screens\n4. Build admin moderation tools\n5. Add real-time chat features\n6. Implement safety monitoring'**
  String get nextStepsPhase2Details;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
