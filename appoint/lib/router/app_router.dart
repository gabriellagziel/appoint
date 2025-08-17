import 'dart:developer' as dev;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// kIsWeb/TargetPlatform are used in preview_flags's isMobilePlatform.
import '../config/preview_flags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/home/home_landing_screen.dart';
// import '../features/meeting_creation/meeting_flow_entry.dart';

// Minimal placeholders. Replace with your real screens when available.
class PersonalSetupScreen extends StatelessWidget {
  const PersonalSetupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            final p = await SharedPreferences.getInstance();
            await p.setBool('personalSetupComplete', true);
            if (context.mounted) context.go('/home');
          },
          child: const Text('Finish Setup'),
        ),
      ),
    );
  }
}

class MeetingCreateScreen extends StatelessWidget {
  const MeetingCreateScreen({super.key});
  @override
  Widget build(_) =>
      const Scaffold(body: Center(child: Text('Create Meeting')));
}

class ReminderCreateScreen extends StatelessWidget {
  const ReminderCreateScreen({super.key});
  @override
  Widget build(_) =>
      const Scaffold(body: Center(child: Text('Create Reminder')));
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  @override
  Widget build(_) => const Scaffold(body: Center(child: Text('Calendar')));
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});
  @override
  Widget build(_) => const Scaffold(body: Center(child: Text('Groups')));
}

Future<bool> _isSetupComplete() async {
  final p = await SharedPreferences.getInstance();
  return p.getBool('personalSetupComplete') ?? false;
}

// Cache the setup flag once and allow router refresh
final ValueNotifier<bool?> _setupDone = ValueNotifier<bool?>(null);

Future<void> initRouterGuards() async {
  _setupDone.value = await _isSetupComplete();
}

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/home',
  refreshListenable: _setupDone,
  routes: [
    GoRoute(
        path: '/setup',
        builder: (context, state) => const PersonalSetupScreen()),
    GoRoute(
        path: '/home',
        builder: (context, state) {
          const bool forceFlowAlways = bool.fromEnvironment(
            'FORCE_FLOW_ALWAYS',
            defaultValue: false,
          );
          final bool previewMobile = forceFlowAlways ||
              forceMobileFlow ||
              queryPreviewMobile ||
              isMobilePlatform();
          if (kIsWeb) {
            dev.log(
              '[ROUTER] /home -> previewMobile=$previewMobile '
              '(forceFlowAlways:$forceFlowAlways forceMobileFlow:$forceMobileFlow '
              'queryPreviewMobile:$queryPreviewMobile isMobile:${isMobilePlatform()})',
              name: 'router',
            );
            // ignore: avoid_print
            print('[ROUTER] /home decision: '
                '${previewMobile ? 'FLOW' : 'DASHBOARD'}');
          }
          // Legacy flow disabled during migration
          // if (previewMobile) {
          //   return const MeetingFlowEntry();
          // }
          return const HomeLandingScreen();
        }),
    GoRoute(
        path: '/meeting/create',
        builder: (context, state) => const MeetingCreateScreen()),
    GoRoute(
        path: '/reminders/create',
        builder: (context, state) => const ReminderCreateScreen()),
    GoRoute(
        path: '/calendar', builder: (context, state) => const CalendarScreen()),
    GoRoute(path: '/groups', builder: (context, state) => const GroupsScreen()),
    // Flow preview entry (mobile flow)
    // Legacy flow route disabled during migration
    // GoRoute(path: '/flow', builder: (context, state) => const MeetingFlowEntry()),
  ],
  // Guard only home/root; allow sub-pages to navigate
  redirect: (ctx, state) async {
    if (_setupDone.value == null) {
      _setupDone.value = await _isSetupComplete();
    }
    // Allow preview to skip setup
    if (previewSkipSetup || querySkipSetup) {
      _setupDone.value = true;
    }
    final done = _setupDone.value ?? false;
    final atSetup = state.matchedLocation == '/setup';
    final atHomeOrRoot =
        state.matchedLocation == '/home' || state.matchedLocation == '/';
    if (!done && !atSetup && atHomeOrRoot) return '/setup';
    if (done && atSetup) return '/home';
    return null;
  },
  errorBuilder: (ctx, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.uri}')),
  ),
);

Future<void> markSetupComplete() async {
  final p = await SharedPreferences.getInstance();
  await p.setBool('personalSetupComplete', true);
  _setupDone.value = true;
}
