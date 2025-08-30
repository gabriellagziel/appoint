// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get home_title => 'מה אתה רוצה לעשות עכשיו?';

  @override
  String get qa_meeting => 'פגישה';

  @override
  String get qa_reminder => 'תזכורת';

  @override
  String get qa_group => 'קבוצה';

  @override
  String get qa_playtime => 'זמן משחק';

  @override
  String get prompt_who => 'עבור מי זה?';

  @override
  String get prompt_what => 'על מה?';

  @override
  String get prompt_when => 'מתי זה קורה?';

  @override
  String get prompt_where => 'איפה זה יהיה?';

  @override
  String get prompt_confirm => 'בדוק את הפרטים';
}
