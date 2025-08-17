import 'package:go_router/go_router.dart';
import 'features/home/home_entry_decider.dart';
import 'features/meeting_flow/meeting_flow.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (ctx, st) => const HomeEntryDecider(),
    ),
    GoRoute(
      path: '/flow',
      builder: (ctx, st) => const MeetingFlow(),
    ),
  ],
);
