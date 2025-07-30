/// Routing configuration. Verified conflict-free.
import 'package:flutter/material.dart';

import '../features/auth/home_screen.dart';
import '../features/studio/studio_booking_screen.dart';
import '../features/studio/studio_booking_confirm_screen.dart';
import '../features/studio/ui/content_library_screen.dart';
import '../features/studio/ui/studio_dashboard_screen.dart';
import '../features/booking/screens/chat_booking_screen.dart';
import '../features/booking/booking_request_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/personal_app/ui/profile_screen.dart';
import '../features/personal_app/ui/edit_profile_screen.dart';
import '../features/profile/ui/edit_profile_screen.dart' as profile_edit;
import '../features/personal_app/ui/settings_screen.dart';
import '../features/admin/ui/admin_dashboard_screen.dart';
import '../features/family/widgets/invitation_modal.dart';
import '../features/family/screens/family_dashboard_screen.dart';
import '../features/family/screens/invite_child_screen.dart';
import '../features/family/screens/permissions_screen.dart';
import '../features/family/ui/parental_consent_prompt.dart';
import '../features/family/ui/parental_settings_screen.dart';
import '../features/invite/invite_detail_screen.dart';
import '../features/booking/booking_confirm_screen.dart';
import '../features/admin/admin_broadcast_screen.dart';
import '../features/admin/admin_demo_panel_screen.dart';
import '../features/calendar/google_integration_screen.dart';
import '../features/ambassador_dashboard_screen.dart';
import '../features/ambassador_onboarding_screen.dart';
import '../models/invite.dart';
import 'package:appoint/features/studio_business/screens/business_dashboard_screen.dart';
import 'package:appoint/features/studio_business/screens/business_profile_screen.dart';
import '../features/invite/invite_list_screen.dart';
import '../features/personal_app/ui/search_screen.dart';
import '../features/personal_app/ui/content_detail_screen.dart';
import '../features/personal_app/ui/notifications_screen.dart';
import '../features/common/ui/error_screen.dart';
import '../features/referral/referral_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
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
      case '/studio/dashboard':
        return MaterialPageRoute(
          builder: (_) => const StudioDashboardScreen(),
          settings: settings,
        );
      case '/studio/library':
        return MaterialPageRoute(
          builder: (_) => const ContentLibraryScreen(),
          settings: settings,
        );
      case '/chat-booking':
        return MaterialPageRoute(
          builder: (_) => const ChatBookingScreen(),
          settings: settings,
        );
      case '/booking/request':
        return MaterialPageRoute(
          builder: (_) => const BookingRequestScreen(),
          settings: settings,
        );
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case '/profile/edit':
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
          settings: settings,
        );
      case '/edit-profile':
        return MaterialPageRoute(
          builder: (_) => const profile_edit.EditProfileScreen(),
          settings: settings,
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case '/admin/dashboard':
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
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
      case '/parental-consent':
        return MaterialPageRoute(
          builder: (_) => const ParentalConsentPrompt(),
          settings: settings,
        );
      case '/parental-settings':
        return MaterialPageRoute(
          builder: (_) => const ParentalSettingsScreen(),
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
      case '/admin/demo-panel':
        return MaterialPageRoute(
          builder: (_) => const AdminDemoPanelScreen(),
          settings: settings,
        );
      case '/google/calendar':
        return MaterialPageRoute(
          builder: (_) => const GoogleIntegrationScreen(),
          settings: settings,
        );
      case '/ambassador-dashboard':
        return MaterialPageRoute(
          builder: (_) => const AmbassadorDashboardScreen(),
          settings: settings,
        );
      case '/ambassador-onboarding':
        return MaterialPageRoute(
          builder: (_) => const AmbassadorOnboardingScreen(),
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
      case '/business/dashboard':
        return MaterialPageRoute(
          builder: (_) => const BusinessDashboardScreen(),
          settings: settings,
        );
      case '/business/profile':
        return MaterialPageRoute(
          builder: (_) => const BusinessProfileScreen(),
          settings: settings,
        );
      case '/invite/list':
        return MaterialPageRoute(
          builder: (_) => const InviteListScreen(),
          settings: settings,
        );
      case '/referral':
        return MaterialPageRoute(
          builder: (_) => const ReferralScreen(),
          settings: settings,
        );
      case '/content/:id':
        final id = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ContentDetailScreen(contentId: id),
          settings: settings,
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );
      case '/error':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message: args['message'] as String? ?? 'An error occurred',
            onTryAgain: args['onTryAgain'] as VoidCallback? ?? () {},
          ),
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
