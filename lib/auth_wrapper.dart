import 'package:flutter/material.dart';

// Import scaffolded screens so the named routes referenced below exist when
// the Navigator tries to push them. These imports are only for registration and
// are not used directly in this file.
// ignore: unused_import
import 'features/personal_app/login_screen.dart';
// ignore: unused_import
import 'features/personal_app/onboarding_screen.dart';
// ignore: unused_import
import 'features/personal_app/home_feed_screen.dart';
// ignore: unused_import
import 'features/scheduler/scheduler_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    // ignore: dead_code
    if (isLoggedIn) {
      Navigator.pushNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, '/login');
    }
    return const SizedBox.shrink();
  }
}
