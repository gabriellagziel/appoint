// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get playtimeSystemTest => 'Playtime System Test';

  @override
  String get playtimeSystemImplementationTest =>
      'Playtime System Implementation Test';

  @override
  String get playtimeGameModel => 'PlaytimeGame Model';

  @override
  String get playtimeSessionModel => 'PlaytimeSession Model';

  @override
  String get playtimeBackgroundModel => 'PlaytimeBackground Model';

  @override
  String get meetingWithPlaytimeSupport => 'Meeting with Playtime Support';

  @override
  String get playtimeServiceMethods => 'PlaytimeService Methods';

  @override
  String get riverpodProviders => 'Riverpod Providers';

  @override
  String get phase1ImplementationComplete =>
      '🎉 PHASE 1 Implementation Complete!';

  @override
  String get allCoreModelsCreated =>
      '✅ All core models created\n✅ Service layer implemented\n✅ Providers configured\n✅ MeetingType.playtime support added\n✅ Parent approval workflow ready\n✅ Safety features included';

  @override
  String get pwaSystemImplementation => 'PWA System Implementation';

  @override
  String get testPwaPrompt => 'Test PWA Prompt';

  @override
  String get simulateMeetingCreation => 'Simulate Meeting Creation';

  @override
  String get nextStepsPhase2 => '📋 Next Steps for PHASE 2';

  @override
  String get nextStepsPhase2Details =>
      '1. Create UI components\n2. Implement Firestore collections\n3. Add parent approval screens\n4. Build admin moderation tools\n5. Add real-time chat features\n6. Implement safety monitoring';
}
