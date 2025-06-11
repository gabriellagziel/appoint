import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'features/studio/studio_booking_screen.dart';
import 'features/studio/studio_confirm_screen.dart';
import 'features/calendar/calendar_sync_screen.dart';
import 'features/calendar/calendar_view_screen.dart';
import 'features/notifications/notification_settings_screen.dart';
import 'features/notifications/notification_list_screen.dart';
import 'providers/notification_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final container = ProviderContainer();
  await container.read(notificationServiceProvider).initialize(onMessage: (msg) {
    final notifier = container.read(notificationsProvider.notifier);
    notifier.state = [...notifier.state, msg];
  });
  final token = await container.read(notificationServiceProvider).getToken();
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && token != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({'fcmToken': token}, SetOptions(merge: true));
  }
  runApp(UncontrolledProviderScope(container: container, child: const App()));
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
        '/studio/booking': (context) => const StudioBookingScreen(),
        '/studio/confirm': (context) => const StudioConfirmScreen(),
        '/calendar/sync': (context) => const CalendarSyncScreen(),
        '/calendar/view': (context) => const CalendarViewScreen(),
        '/notifications/settings': (context) =>
            const NotificationSettingsScreen(),
        '/notifications/list': (context) => const NotificationListScreen(),
      },
    );
  }
}
