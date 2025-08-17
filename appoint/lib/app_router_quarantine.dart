import 'package:go_router/go_router.dart';
import 'features/meeting_flow/personal_mobile_flow.dart';

final GoRouter quarantineRouter = GoRouter(
  initialLocation: '/flow-personal-test',
  routes: [
    GoRoute(
      path: '/flow-personal-test',
      builder: (_, __) => const PersonalMobileFlow(),
    ),
  ],
);
