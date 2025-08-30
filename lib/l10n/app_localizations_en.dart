// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home_title => 'What do you want to do now?';

  @override
  String get qa_meeting => 'Meeting';

  @override
  String get qa_reminder => 'Reminder';

  @override
  String get qa_group => 'Group';

  @override
  String get qa_playtime => 'Playtime';

  @override
  String get prompt_who => 'Who is this for?';

  @override
  String get prompt_what => 'What is it about?';

  @override
  String get prompt_when => 'When should it happen?';

  @override
  String get prompt_where => 'Where will it be?';

  @override
  String get prompt_confirm => 'Review your details';
}
