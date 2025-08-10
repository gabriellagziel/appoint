import 'package:go_router/go_router.dart';
import 'features/home/home_entry_decider.dart';
import 'features/meeting_flow/personal_mobile_flow.dart';
import 'features/meeting/create_flow/create_meeting_flow_screen.dart';
import 'features/reminders/create_reminder_screen.dart';
import 'features/reminders/reminders_dashboard.dart';

void _routerLoadedProof() =>
    print('[[ROUTER FILE LOADED]] appoint/lib/app_router.dart');

final router = (() {
  _routerLoadedProof();
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // Force /home to use HomeEntryDecider
      GoRoute(path: '/home', builder: (_, __) => const HomeEntryDecider()),
      // Direct link to the new flow
      GoRoute(path: '/flow', builder: (_, __) => const PersonalMobileFlow()),
      // New modular create meeting flow
      GoRoute(
        path: '/create/meeting',
        builder: (_, __) => const CreateMeetingFlowScreen(),
      ),
      // Reminders
      GoRoute(path: '/reminders', builder: (_, __) => const RemindersDashboard()),
      GoRoute(path: '/reminders/create', builder: (_, __) => const CreateReminderScreen()),
      // Root redirect safeguard
      GoRoute(path: '/', redirect: (_, __) => '/home'),
    ],
  );
})();
