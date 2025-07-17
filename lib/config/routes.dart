import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:appoint/features/admin/ui/admin_dashboard_screen.dart';
import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/features/ambassador_onboarding_screen.dart';
import 'package:appoint/features/auth/home_screen.dart';
import 'package:appoint/features/booking/booking_confirm_screen.dart';
import 'package:appoint/features/booking/booking_request_screen.dart';
import 'package:appoint/features/booking/screens/chat_booking_screen.dart';
import 'package:appoint/features/calendar/google_integration_screen.dart';
import 'package:appoint/features/child/ui/child_dashboard_screen.dart';
import 'package:appoint/features/child/ui/parental_control_screen.dart';
import 'package:appoint/features/common/ui/error_screen.dart';
import 'package:appoint/features/common/ui/unsupported_screen.dart';
import 'package:appoint/features/dashboard/dashboard_screen.dart';
import 'package:appoint/features/family/screens/family_dashboard_screen.dart';
import 'package:appoint/features/family/screens/invite_child_screen.dart';
import 'package:appoint/features/family/screens/permissions_screen.dart';
import 'package:appoint/features/family/ui/parental_consent_prompt.dart';
import 'package:appoint/features/family/ui/parental_settings_screen.dart';
import 'package:appoint/features/family/widgets/invitation_modal.dart';
import 'package:appoint/features/family_support/screens/family_support_screen.dart';
import 'package:appoint/features/invite/invite_detail_screen.dart';
import 'package:appoint/features/invite/invite_list_screen.dart';
import 'package:appoint/features/personal_app/ui/content_detail_screen.dart';
import 'package:appoint/features/personal_app/ui/edit_profile_screen.dart';
import 'package:appoint/features/personal_app/ui/notifications_screen.dart';
import 'package:appoint/features/personal_app/ui/profile_screen.dart';
import 'package:appoint/features/personal_app/ui/search_screen.dart';
import 'package:appoint/features/personal_app/ui/settings_screen.dart';
import 'package:appoint/features/personal_scheduler/screens/personal_scheduler_screen.dart';
import 'package:appoint/features/profile/ui/edit_profile_screen.dart'
    as profile_edit;
import 'package:appoint/features/referral/referral_screen.dart';
import 'package:appoint/features/rewards/rewards_screen.dart';
import 'package:appoint/features/studio/studio_booking_confirm_screen.dart';
import 'package:appoint/features/studio/studio_booking_screen.dart';
import 'package:appoint/features/studio/ui/appointments_screen.dart';
import 'package:appoint/features/studio/ui/content_library_screen.dart';
import 'package:appoint/features/studio/ui/providers_screen.dart';
import 'package:appoint/features/studio/ui/staff_screen.dart';
import 'package:appoint/features/studio/ui/studio_dashboard_screen.dart';
import 'package:appoint/features/studio_business/entry/business_entry_screen.dart';
import 'package:appoint/features/studio_business/screens/business_dashboard_screen.dart';
import 'package:appoint/features/studio_business/screens/business_profile_screen.dart';
import 'package:appoint/features/studio_profile/studio_profile_screen.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/widgets/animations/fade_slide_page_route.dart';
import 'package:flutter/material.dart';

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
      case '/studio/appointments':
        return MaterialPageRoute(
          builder: (_) => const AppointmentsScreen(),
          settings: settings,
        );
      case '/studio/staff':
        final staffId = settings.arguments as String? ?? 'default';
        return MaterialPageRoute(
          builder: (_) => StaffScreen(staffId: staffId),
          settings: settings,
        );
      case '/studio/providers':
        return MaterialPageRoute(
          builder: (_) => const ProvidersScreen(),
          settings: settings,
        );
      case '/chat-booking':
        return MaterialPageRoute(
          builder: (_) => const ChatBookingScreen(),
          settings: settings,
        );
      case '/booking/request':
        return FadeSlidePageRoute(
          page: const BookingRequestScreen(),
          settings: settings,
          direction: AxisDirection.up,
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
      case '/child/dashboard':
        return MaterialPageRoute(
          builder: (_) => const ChildDashboardScreen(),
          settings: settings,
        );
      case '/child/controls':
        return MaterialPageRoute(
          builder: (_) => const ParentalControlScreen(),
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
      case '/family/support':
        return MaterialPageRoute(
          builder: (_) => const FamilySupportScreen(),
          settings: settings,
        );
      case '/personal/scheduler':
        return MaterialPageRoute(
          builder: (_) => const PersonalSchedulerScreen(),
          settings: settings,
        );
      case '/admin/broadcast':
        return MaterialPageRoute(
          builder: (_) => const AdminBroadcastScreen(),
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
        final invite = settings.arguments! as Invite;
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
      case '/business':
        return MaterialPageRoute(
          builder: (_) => const BusinessEntryScreen(),
          settings: settings,
        );
      case '/business/profile':
        return MaterialPageRoute(
          builder: (_) => const BusinessProfileScreen(),
          settings: settings,
        );
      case '/studio/profile':
        final studioId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => StudioProfileScreen(studioId: studioId),
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
      case '/rewards':
        return MaterialPageRoute(
          builder: (_) => const RewardsScreen(),
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
      case '/unsupported':
        return MaterialPageRoute(
          builder: (_) => const UnsupportedScreen(),
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
  const MeetingDetailsScreen({
    required this.meetingId,
    super.key,
    this.creatorId,
    this.contextId,
    this.groupId,
  });
  final String meetingId;
  final String? creatorId;
  final String? contextId;
  final String? groupId;

  @override
  Widget build(BuildContext context) => Scaffold(
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
