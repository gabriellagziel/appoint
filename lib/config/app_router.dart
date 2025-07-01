import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/features/auth/auth_wrapper.dart';
import 'package:appoint/features/auth/login_screen.dart';
import 'package:appoint/features/studio_business/entry/studio_entry_screen.dart';
import 'package:appoint/features/studio_business/screens/business_calendar_screen.dart';
import 'package:appoint/features/studio_business/presentation/business_availability_screen.dart';
import 'package:appoint/features/studio_business/screens/business_dashboard_screen.dart';
import 'package:appoint/features/studio_business/screens/studio_booking_screen.dart'
    as studio_business;
import 'package:appoint/features/studio_business/screens/business_profile_screen.dart';
import 'package:appoint/features/studio_business/screens/business_connect_screen.dart';
import 'package:appoint/features/studio_business/screens/phone_booking_screen.dart';
import 'package:appoint/features/studio_business/screens/clients_screen.dart'
    as studio_clients;
import 'package:appoint/features/studio_business/screens/appointments_screen.dart'
    as studio_appointments;
import 'package:appoint/features/studio_business/screens/invoices_screen.dart';
import 'package:appoint/features/studio_business/screens/messages_screen.dart';
import 'package:appoint/features/studio_business/screens/analytics_screen.dart';
import 'package:appoint/features/studio_business/screens/settings_screen.dart';
import 'package:appoint/features/studio_business/screens/rooms_screen.dart';
import 'package:appoint/features/studio_business/screens/providers_screen.dart';
import 'package:appoint/features/studio_business/screens/appointment_requests_screen.dart';
import 'package:appoint/features/studio_business/screens/external_meetings_screen.dart';
import 'package:appoint/features/booking/screens/chat_booking_screen.dart';
import 'package:appoint/features/booking/booking_request_screen.dart';
import 'package:appoint/features/dashboard/dashboard_screen.dart';
import 'package:appoint/features/profile/user_profile_screen.dart';
import 'package:appoint/features/admin/admin_dashboard_screen.dart';
import 'package:appoint/features/family/widgets/invitation_modal.dart';
import 'package:appoint/features/family/screens/family_dashboard_screen.dart';
import 'package:appoint/features/family/screens/invite_child_screen.dart';
import 'package:appoint/features/family/screens/permissions_screen.dart';
import 'package:appoint/features/invite/invite_detail_screen.dart';
import 'package:appoint/features/booking/booking_confirm_screen.dart';
import 'package:appoint/features/admin/admin_broadcast_screen.dart';

import 'package:appoint/features/calendar/google_integration_screen.dart';
import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/features/ambassador_onboarding_screen.dart';
import 'package:appoint/features/invite/invite_list_screen.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/features/studio_business/screens/staff_availability_screen.dart';
import 'package:appoint/features/business/screens/business_dashboard_screen.dart'
    as business;

final routerProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (final context, final state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (final context, final state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (final context, final state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (final context, final state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        name: 'adminDashboard',
        builder: (final context, final state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/broadcast',
        name: 'adminBroadcast',
        builder: (final context, final state) => const AdminBroadcastScreen(),
      ),

      GoRoute(
        path: '/family/invite',
        name: 'familyInvite',
        builder: (final context, final state) => const InvitationModal(),
      ),
      GoRoute(
        path: '/dashboard/family',
        name: 'familyDashboard',
        builder: (final context, final state) => const FamilyDashboardScreen(),
      ),
      GoRoute(
        path: '/family/invite-child',
        name: 'inviteChild',
        builder: (final context, final state) => const InviteChildScreen(),
      ),
      GoRoute(
        path: '/family/permissions',
        name: 'permissions',
        builder: (final context, final state) {
          final familyLink = state.extra as dynamic;
          return PermissionsScreen(familyLink: familyLink);
        },
      ),
      GoRoute(
        path: '/google/calendar',
        name: 'googleCalendar',
        builder: (final context, final state) => const GoogleIntegrationScreen(),
      ),
      GoRoute(
        path: '/ambassador-dashboard',
        name: 'ambassadorDashboard',
        builder: (final context, final state) => const AmbassadorDashboardScreen(),
      ),
      GoRoute(
        path: '/ambassador-onboarding',
        name: 'ambassadorOnboarding',
        builder: (final context, final state) => const AmbassadorOnboardingScreen(),
      ),
      GoRoute(
        path: '/chat-booking',
        name: 'chatBooking',
        builder: (final context, final state) => const ChatBookingScreen(),
      ),
      GoRoute(
        path: '/booking/request',
        name: 'bookingRequest',
        builder: (final context, final state) => const BookingRequestScreen(),
      ),
      GoRoute(
        path: '/booking/details',
        name: 'bookingDetails',
        builder: (final context, final state) => const BookingConfirmScreen(),
      ),
      GoRoute(
        path: '/invite/details',
        name: 'inviteDetails',
        builder: (final context, final state) {
          final invite = state.extra as Invite;
          return InviteDetailScreen(invite: invite);
        },
      ),
      GoRoute(
        path: '/invite/list',
        name: 'inviteList',
        builder: (final context, final state) => const InviteListScreen(),
      ),

      // Studio & Business Routes
      GoRoute(
        path: '/studio/booking',
        name: 'studioBooking',
        builder: (final context, final state) =>
            const studio_business.StudioBookingScreen(),
      ),
      GoRoute(
        path: '/studio/calendar',
        name: 'studioCalendar',
        builder: (final context, final state) => const BusinessCalendarScreen(),
      ),
      GoRoute(
        path: '/studio/profile',
        name: 'studioProfile',
        builder: (final context, final state) => const BusinessProfileScreen(),
      ),
      GoRoute(
        path: '/business/connect',
        name: 'businessConnect',
        builder: (final context, final state) => const BusinessConnectScreen(),
      ),
      GoRoute(
        path: '/business/dashboard',
        name: 'businessDashboard',
        builder: (final context, final state) => const business.BusinessDashboardScreen(),
      ),
      GoRoute(
        path: '/business/profile',
        name: 'businessProfile',
        builder: (final context, final state) => const BusinessProfileScreen(),
      ),
      GoRoute(
        path: '/business/phone-booking',
        name: 'phoneBooking',
        builder: (final context, final state) => const PhoneBookingScreen(),
      ),
      GoRoute(
        path: '/business/clients',
        name: 'clients',
        builder: (final context, final state) => const studio_clients.ClientsScreen(),
      ),
      GoRoute(
        path: '/business/appointments',
        name: 'appointments',
        builder: (final context, final state) =>
            const studio_appointments.AppointmentsScreen(),
      ),
      GoRoute(
        path: '/business/invoices',
        name: 'invoices',
        builder: (final context, final state) => const InvoicesScreen(),
      ),
      GoRoute(
        path: '/business/messages',
        name: 'messages',
        builder: (final context, final state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/business/analytics',
        name: 'analytics',
        builder: (final context, final state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/business/settings',
        name: 'settings',
        builder: (final context, final state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/business/rooms',
        name: 'rooms',
        builder: (final context, final state) => const RoomsScreen(),
      ),
      GoRoute(
        path: '/business/providers',
        name: 'providers',
        builder: (final context, final state) => const ProvidersScreen(),
      ),
      GoRoute(
        path: '/business/appointment-requests',
        name: 'appointmentRequests',
        builder: (final context, final state) => const AppointmentRequestsScreen(),
      ),
      GoRoute(
        path: '/business/external-meetings',
        name: 'externalMeetings',
        builder: (final context, final state) => const ExternalMeetingsScreen(),
      ),
      GoRoute(
        path: '/studio/confirm',
        name: 'studioConfirm',
        builder: (final context, final state) =>
            const studio_business.StudioBookingConfirmScreen(),
      ),

      // Studio nested routes
      GoRoute(
        path: '/studio',
        name: 'studio',
        builder: (final context, final state) => const StudioEntryScreen(),
        routes: [
          GoRoute(
            path: 'availability',
            name: 'studioAvailability',
            builder: (final context, final state) => const BusinessAvailabilityScreen(),
          ),
          GoRoute(
            path: 'dashboard',
            name: 'studioDashboard',
            builder: (final context, final state) => const BusinessDashboardScreen(),
          ),
        ],
      ),

      // Deep link routes for WhatsApp Smart Share
      GoRoute(
        path: '/meeting/details',
        name: 'meetingDetails',
        builder: (final context, final state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return MeetingDetailsScreen(
            meetingId: args['meetingId'] as String? ?? '',
            creatorId: args['creatorId'] as String?,
            contextId: args['contextId'] as String?,
            groupId: args['groupId'] as String?,
          );
        },
      ),

      GoRoute(
        path: '/studio/staff-availability',
        name: 'studioStaffAvailability',
        builder: (final context, final state) => StaffAvailabilityScreen(),
      ),
    ],
    errorBuilder: (final context, final state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri.path}'),
      ),
    ),
  );
});

// Placeholder screen for meeting details (to be implemented)
class MeetingDetailsScreen extends StatelessWidget {
  final String meetingId;
  final String? creatorId;
  final String? contextId;
  final String? groupId;

  const MeetingDetailsScreen({
    final Key? key,
    required this.meetingId,
    this.creatorId,
    this.contextId,
    this.groupId,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
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
              onPressed: () => context.pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
