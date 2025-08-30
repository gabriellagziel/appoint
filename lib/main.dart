import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'flows/meeting_flow.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final isV2 = _isV2();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('What do you want to do now?')),
        body: isV2
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
                              tWho: 'Who is this for?',
                              tWhat: 'What is it about?',
                              tWhen: 'When should it happen?',
                              tWhere: 'Where will it be?',
                              tConfirm: 'Review your details',
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => Scaffold(
                                appBar: AppBar(title: const Text('Meeting')),
                                body: ConversationalShell(
                                    engine: engine, textDirection: _dir),
                              ),
                            ));
                          }
                        },
                        tMeeting: 'Meeting',
                        tReminder: 'Reminder',
                        tGroup: 'Group',
                        tPlaytime: 'Playtime',
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

