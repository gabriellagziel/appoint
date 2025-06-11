import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'features/auth/auth_wrapper.dart';
import 'features/booking/booking_request_screen.dart';
import 'features/booking/booking_confirm_screen.dart';
import 'features/invite/invite_request_screen.dart';
import 'features/invite/invite_list_screen.dart';
import 'features/invite/invite_detail_screen.dart';
import 'features/profile/user_profile_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/admin/admin_dashboard_screen.dart';
import 'features/admin/admin_users_screen.dart';
import 'features/admin/admin_orgs_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/booking/request': (context) => const BookingRequestScreen(),
        '/booking/confirm': (context) => const BookingConfirmScreen(),
        '/invite/request': (context) => const InviteRequestScreen(),
        '/invite/list': (context) => const InviteListScreen(),
        '/invite/detail': (context) => const InviteDetailScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/admin/users': (context) => const AdminUsersScreen(),
        '/admin/orgs': (context) => const AdminOrgsScreen(),
      },
    );
  }
}
