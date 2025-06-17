import 'package:flutter/material.dart';

import '../features/studio/studio_booking_screen.dart';
import '../features/studio/studio_booking_confirm_screen.dart';
import '../features/booking/screens/chat_booking_screen.dart';
import '../features/family/widgets/invitation_modal.dart';
import '../features/family/screens/family_dashboard_screen.dart';
import '../features/family/screens/invite_child_screen.dart';
import '../features/family/screens/permissions_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/studio/booking':
        return MaterialPageRoute(
          builder: (_) => const StudioBookingScreen(),
          settings: settings,
        );
      case '/studio/confirm':
        return MaterialPageRoute(
          builder: (_) => const StudioBookingConfirmScreen(),
          settings: settings,
        );
      case '/chat-booking':
        return MaterialPageRoute(
          builder: (_) => const ChatBookingScreen(),
          settings: settings,
        );
      case '/family/invite':
        return MaterialPageRoute(
          builder: (_) => const InvitationModal(),
          settings: settings,
        );
      case '/dashboard/family':
        return MaterialPageRoute(
          builder: (_) => const FamilyDashboardScreen(),
          settings: settings,
        );
      case '/family/invite-child':
        return MaterialPageRoute(
          builder: (_) => const InviteChildScreen(),
          settings: settings,
        );
      case '/family/permissions':
        final familyLink = settings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (_) => PermissionsScreen(familyLink: familyLink),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
