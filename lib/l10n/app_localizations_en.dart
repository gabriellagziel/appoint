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
  String get bookMeeting => 'Book a Meeting';

  @override
  String get selectStaff => 'Select Staff';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get noSlots => 'No slots available';

  @override
  String get next => 'Next';
}
