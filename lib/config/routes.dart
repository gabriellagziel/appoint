import 'package:flutter/material.dart';

import '../features/studio/studio_booking_screen.dart';
import '../features/studio/studio_booking_confirm_screen.dart';
import '../features/minor_parent/select_minor_screen.dart';
import '../features/minor_parent/verify_parent_screen.dart';

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
      case '/select-minor':
        return MaterialPageRoute(
          builder: (_) => const SelectMinorScreen(),
          settings: settings,
        );
      case '/verify-parent':
        return MaterialPageRoute(
          builder: (_) => const VerifyParentScreen(),
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
