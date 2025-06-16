import 'package:flutter/material.dart';

import '../features/studio/studio_booking_screen.dart';
import '../features/studio/studio_booking_confirm_screen.dart';

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
