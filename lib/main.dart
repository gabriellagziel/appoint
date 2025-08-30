import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'flows/meeting_flow.dart';
import 'l10n/app_localizations.dart';
import 'ui/conversational_shell.dart';
import 'ui/quick_actions.dart';

void main() => runApp(const AppOintApp());

class AppOintApp extends StatefulWidget {
  const AppOintApp({super.key});
  @override
  State<AppOintApp> createState() => _AppOintAppState();
}

class _AppOintAppState extends State<AppOintApp> {
  late String _localeCode;
  late TextDirection _dir;
  AppStrings? _t;

  String _detectLang() {
    if (kIsWeb) {
      final uri = Uri.base;
      final qp = uri.queryParameters;
      final forced = qp['lang'];
      if (forced != null && forced.isNotEmpty) return forced;
    }
    return ui.PlatformDispatcher.instance.locale.languageCode; // e.g., "en"
  }

  TextDirection _detectDir(String lang) =>
      (lang == 'he' || lang == 'ar') ? TextDirection.rtl : TextDirection.ltr;

  bool _isV2() {
    if (!kIsWeb) return true; // in apps use new by default
    return Uri.base.queryParameters['v2'] == '1';
  }

  @override
  void initState() {
    super.initState();
    final lang = _detectLang();
    _localeCode = lang;
    _dir = _detectDir(lang);
    _loadStrings();
  }

  Future<void> _loadStrings() async {
    _t = await AppStrings.load(_localeCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = _t;
    final isV2 = _isV2();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text(t?.t('home_title') ?? '...')),
        body: t == null
            ? const Center(child: CircularProgressIndicator())
            : isV2
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: QuickActions(
                            onPick: (flow) {
                              if (flow == 'meeting') {
                                final engine = createMeetingFlow(
                                  tWho: t.t('prompt_who'),
                                  tWhat: t.t('prompt_what'),
                                  tWhen: t.t('prompt_when'),
                                  tWhere: t.t('prompt_where'),
                                  tConfirm: t.t('prompt_confirm'),
                                );
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                    appBar:
                                        AppBar(title: Text(t.t('qa_meeting'))),
                                    body: ConversationalShell(
                                        engine: engine, textDirection: _dir),
                                  ),
                                ));
                              }
                            },
                            tMeeting: t.t('qa_meeting'),
                            tReminder: t.t('qa_reminder'),
                            tGroup: t.t('qa_group'),
                            tPlaytime: t.t('qa_playtime'),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                        'Legacy version - add ?v2=1 to URL for new version'),
                  ),
      ),
    );
  }
}
