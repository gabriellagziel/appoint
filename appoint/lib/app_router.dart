import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'features/home/home_entry_decider.dart';
import 'features/meeting_flow/personal_mobile_flow.dart';
import 'features/meeting/screens/meeting_details_screen.dart';
import 'features/meeting/create_flow/create_meeting_flow_screen.dart';
import 'features/reminders/create_reminder_screen.dart';
import 'features/reminders/reminders_dashboard.dart';
import 'features/settings/screens/notification_settings_screen.dart';
import 'features/group/ui/screens/group_join_screen.dart';
import 'features/group/ui/screens/group_details_screen.dart';

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
      // Meeting details (real page)
      GoRoute(
        path: '/meeting/:id',
        builder: (context, state) => MeetingDetailsScreen(
          meetingId: state.pathParameters['id']!,
          // isGuest can also be resolved inside the screen; leaving null ensures internal check
        ),
      ),
      // Reminders
      GoRoute(
          path: '/reminders', builder: (_, __) => const RemindersDashboard()),
      // Group invite join
      GoRoute(
        path: '/group-invite/:code',
        builder: (context, state) => GroupJoinScreen(
          inviteCode: state.pathParameters['code']!,
        ),
      ),
      GoRoute(
        path: '/groups/:id',
        builder: (context, state) => GroupDetailsScreen(
          groupId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
          path: '/reminders/create',
          builder: (_, __) => const CreateReminderScreen()),
      // Groups (placeholder)
      GoRoute(
        path: '/groups',
        builder: (_, __) => const Scaffold(
          body: Center(child: Text('Groups')),
        ),
      ),
      // Settings
      GoRoute(
          path: '/settings/notifications',
          builder: (_, __) => const NotificationSettingsScreen()),
      // Root redirect safeguard
      GoRoute(path: '/', redirect: (_, __) => '/home'),
    ],
  );
})();
