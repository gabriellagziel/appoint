import 'package:flutter/material.dart';

import '../features/studio/studio_booking_screen.dart';
import '../features/studio/studio_booking_confirm_screen.dart';
import '../features/booking/screens/chat_booking_screen.dart';
import '../features/family/widgets/invitation_modal.dart';
import '../features/family/screens/family_dashboard_screen.dart';
import '../features/family/screens/invite_child_screen.dart';
import '../features/family/screens/permissions_screen.dart';
import '../features/invite/invite_detail_screen.dart';
import '../features/booking/booking_confirm_screen.dart';
import '../features/admin/admin_broadcast_screen.dart';
import '../models/invite.dart';

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
      case '/admin/broadcast':
        return MaterialPageRoute(
          builder: (_) => const AdminBroadcastScreen(),
          settings: settings,
        );
      // Deep link routes for WhatsApp Smart Share
      case '/meeting/details':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => MeetingDetailsScreen(
            meetingId: args['meetingId'] as String? ?? '',
            creatorId: args['creatorId'] as String?,
            contextId: args['contextId'] as String?,
            groupId: args['groupId'] as String?,
          ),
          settings: settings,
        );
      case '/invite/details':
        final invite = settings.arguments as Invite;
        return MaterialPageRoute(
          builder: (_) => InviteDetailScreen(invite: invite),
          settings: settings,
        );
      case '/booking/details':
        return MaterialPageRoute(
          builder: (_) => const BookingConfirmScreen(),
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

// Placeholder screen for meeting details (to be implemented)
class MeetingDetailsScreen extends StatelessWidget {
  final String meetingId;
  final String? creatorId;
  final String? contextId;
  final String? groupId;

  const MeetingDetailsScreen({
    Key? key,
    required this.meetingId,
    this.creatorId,
    this.contextId,
    this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meeting ID: $meetingId'),
            if (creatorId != null) Text('Creator: $creatorId'),
            if (contextId != null) Text('Context: $contextId'),
            if (groupId != null) Text('Group: $groupId'),
            const SizedBox(height: 24),
            const Text(
              'This is a placeholder screen for meeting details.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
