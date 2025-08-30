// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get home_title => 'Cosa vuoi fare adesso?';

  @override
  String get qa_meeting => 'Riunione';

  @override
  String get qa_reminder => 'Promemoria';

  @override
  String get qa_group => 'Gruppo';

  @override
  String get qa_playtime => 'Gioco';

  @override
  String get prompt_who => 'Per chi è?';

  @override
  String get prompt_what => 'Di cosa si tratta?';

  @override
  String get prompt_when => 'Quando deve avvenire?';

  @override
  String get prompt_where => 'Dove sarà?';

  @override
  String get prompt_confirm => 'Rivedi i dettagli';
}
