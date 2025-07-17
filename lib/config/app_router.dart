import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:appoint/features/admin/admin_dashboard_screen.dart';
import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/features/ambassador_onboarding_screen.dart';
import 'package:appoint/features/auth/auth_wrapper.dart';
import 'package:appoint/features/auth/login_screen.dart';
import 'package:appoint/features/booking/booking_confirm_screen.dart';
import 'package:appoint/features/booking/booking_request_screen.dart';
import 'package:appoint/features/booking/screens/chat_booking_screen.dart';
import 'package:appoint/features/business/screens/business_dashboard_screen.dart'
    as business;
import 'package:appoint/features/calendar/google_integration_screen.dart';
import 'package:appoint/features/dashboard/dashboard_screen.dart';
import 'package:appoint/features/family/screens/family_dashboard_screen.dart';
import 'package:appoint/features/family/screens/invite_child_screen.dart';
import 'package:appoint/features/family/screens/permissions_screen.dart';
import 'package:appoint/features/family/widgets/invitation_modal.dart';
import 'package:appoint/features/invite/invite_detail_screen.dart';
import 'package:appoint/features/invite/invite_list_screen.dart';
import 'package:appoint/features/profile/user_profile_screen.dart';
import 'package:appoint/features/search/screens/search_screen.dart';
import 'package:appoint/features/studio_business/entry/studio_entry_screen.dart';
import 'package:appoint/features/studio_business/presentation/business_availability_screen.dart';
import 'package:appoint/features/studio_business/screens/analytics_screen.dart';
import 'package:appoint/features/studio_business/screens/appointment_requests_screen.dart';
import 'package:appoint/features/studio_business/screens/appointments_screen.dart'
    as studio_appointments;
import 'package:appoint/features/studio_business/screens/business_calendar_screen.dart';
import 'package:appoint/features/studio_business/screens/business_connect_screen.dart';
import 'package:appoint/features/studio_business/screens/business_dashboard_screen.dart';
import 'package:appoint/features/studio_business/screens/business_profile_screen.dart';
import 'package:appoint/features/studio_business/screens/clients_screen.dart'
    as studio_clients;
import 'package:appoint/features/studio_business/screens/external_meetings_screen.dart';
import 'package:appoint/features/studio_business/screens/invoices_screen.dart';
import 'package:appoint/features/studio_business/screens/messages_screen.dart';
import 'package:appoint/features/studio_business/screens/phone_booking_screen.dart';
import 'package:appoint/features/studio_business/screens/providers_screen.dart';
import 'package:appoint/features/studio_business/screens/rooms_screen.dart';
import 'package:appoint/features/studio_business/screens/settings_screen.dart';
import 'package:appoint/features/studio_business/screens/staff_availability_screen.dart';
import 'package:appoint/features/studio_business/screens/studio_booking_screen.dart'
    as studio_business;
import 'package:appoint/features/studio/studio_booking_confirm_screen.dart';
import 'package:appoint/models/invite.dart';
import 'package:appoint/models/family_link.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/services/branch_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Enhanced features imports
import 'package:appoint/features/onboarding/onboarding_screen.dart';
import 'package:appoint/features/onboarding/enhanced_onboarding_screen.dart';
import 'package:appoint/features/messaging/screens/messages_list_screen.dart';
import 'package:appoint/features/messaging/screens/chat_screen.dart';
import 'package:appoint/features/subscriptions/screens/subscription_screen.dart';
import 'package:appoint/features/rewards/rewards_screen.dart';
import 'package:appoint/features/dashboard/enhanced_dashboard_screen.dart';
import 'package:appoint/features/notifications/enhanced_notifications_screen.dart';
import 'package:appoint/features/settings/enhanced_settings_screen.dart';
import 'package:appoint/features/calendar/enhanced_calendar_screen.dart';
import 'package:appoint/features/profile/enhanced_profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, final state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, final state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, final state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, final state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, final state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, final state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        name: 'adminDashboard',
        builder: (context, final state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/broadcast',
        name: 'adminBroadcast',
        builder: (context, final state) => const AdminBroadcastScreen(),
      ),

      GoRoute(
        path: '/family/invite',
        name: 'familyInvite',
        builder: (context, final state) => const InvitationModal(),
      ),
      GoRoute(
        path: '/dashboard/family',
        name: 'familyDashboard',
        builder: (context, final state) => const FamilyDashboardScreen(),
      ),
      GoRoute(
        path: '/family/invite-child',
        name: 'inviteChild',
        builder: (context, final state) => const InviteChildScreen(),
      ),
      GoRoute(
        path: '/family/permissions',
        name: 'permissions',
        builder: (context, final state) {
          final familyLink = state.extra as FamilyLink;
          return PermissionsScreen(familyLink: familyLink);
        },
      ),
      // Duplicate routes removed to prevent conflicts

      // Studio & Business Routes
      GoRoute(
        path: '/studio/booking',
        name: 'studioBooking',
        builder: (context, final state) =>
            const studio_business.StudioBookingScreen(),
      ),
      GoRoute(
        path: '/studio/calendar',
        name: 'studioCalendar',
        builder: (context, final state) => const BusinessCalendarScreen(),
      ),
      GoRoute(
        path: '/studio/profile',
        name: 'studioProfile',
        builder: (context, final state) => const BusinessProfileScreen(),
      ),
      GoRoute(
        path: '/business/connect',
        name: 'businessConnect',
        builder: (context, final state) => const BusinessConnectScreen(),
      ),
      GoRoute(
        path: '/dev/business-dashboard',
        name: 'devBusinessDashboard',
        builder: (context, final state) =>
            const business.BusinessDashboardScreen(),
      ),
      GoRoute(
        path: '/business/dashboard',
        name: 'businessDashboard',
        builder: (context, final state) =>
            const business.BusinessDashboardScreen(),
      ),
      GoRoute(
        path: '/business/profile',
        name: 'businessProfile',
        builder: (context, final state) => const BusinessProfileScreen(),
      ),
      GoRoute(
        path: '/business/phone-booking',
        name: 'phoneBooking',
        builder: (context, final state) => const PhoneBookingScreen(),
      ),
      GoRoute(
        path: '/business/clients',
        name: 'clients',
        builder: (context, final state) =>
            const studio_clients.ClientsScreen(),
      ),
      GoRoute(
        path: '/business/appointments',
        name: 'appointments',
        builder: (context, final state) =>
            const studio_appointments.AppointmentsScreen(),
      ),
      GoRoute(
        path: '/business/invoices',
        name: 'invoices',
        builder: (context, final state) => const InvoicesScreen(),
      ),
      GoRoute(
        path: '/business/messages',
        name: 'businessMessages',
        builder: (context, final state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/business/analytics',
        name: 'analytics',
        builder: (context, final state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/business/settings',
        name: 'businessSettings',
        builder: (context, final state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/business/rooms',
        name: 'rooms',
        builder: (context, final state) => const RoomsScreen(),
      ),
      GoRoute(
        path: '/business/providers',
        name: 'providers',
        builder: (context, final state) => const ProvidersScreen(),
      ),
      // Additional Business routes
      GoRoute(
        path: '/business/calendar',
        name: 'businessCalendar',
        builder: (context, final state) => const BusinessCalendarScreen(),
      ),
      GoRoute(
        path: '/business/availability',
        name: 'businessAvailability',
        builder: (context, final state) => const BusinessAvailabilityScreen(),
      ),

      // Standalone analytics route
      GoRoute(
        path: '/analytics',
        name: 'analyticsRoot',
        builder: (context, final state) => const AnalyticsScreen(),
      ),

      // Family root shortcut
      GoRoute(
        path: '/family',
        name: 'familyRoot',
        builder: (context, final state) => const FamilyDashboardScreen(),
      ),
      GoRoute(
        path: '/family/invite-child',
        name: 'inviteChild',
        builder: (context, final state) => const InviteChildScreen(),
      ),
      GoRoute(
        path: '/family/permissions',
        name: 'permissions',
        builder: (context, final state) {
          final familyLink = state.extra as FamilyLink;
          return PermissionsScreen(familyLink: familyLink);
        },
      ),
      GoRoute(
        path: '/google/calendar',
        name: 'googleCalendar',
        builder: (context, final state) =>
            const GoogleIntegrationScreen(),
      ),
      GoRoute(
        path: '/ambassador-dashboard',
        name: 'ambassadorDashboard',
        builder: (context, final state) =>
            AmbassadorDashboardScreen(
              notificationService: NotificationService(),
              branchService: BranchService(),
            ),
      ),
      GoRoute(
        path: '/ambassador-onboarding',
        name: 'ambassadorOnboarding',
        builder: (context, final state) =>
            const AmbassadorOnboardingScreen(),
      ),
      GoRoute(
        path: '/chat-booking',
        name: 'chatBooking',
        builder: (context, final state) => const ChatBookingScreen(),
      ),
      GoRoute(
        path: '/booking/request',
        name: 'bookingRequest',
        builder: (context, final state) => const BookingRequestScreen(),
      ),
      GoRoute(
        path: '/booking/details',
        name: 'bookingDetails',
        builder: (context, final state) => const BookingConfirmScreen(),
      ),
      GoRoute(
        path: '/invite/details',
        name: 'inviteDetails',
        builder: (context, final state) {
          final invite = state.extra! as Invite;
          return InviteDetailScreen(invite: invite);
        },
      ),
      GoRoute(
        path: '/invite/list',
        name: 'inviteList',
        builder: (context, final state) => const InviteListScreen(),
      ),

      // Studio nested routes
      GoRoute(
        path: '/studio',
        name: 'studio',
        builder: (context, final state) => const StudioEntryScreen(),
        routes: [
          GoRoute(
            path: 'availability',
            name: 'studioAvailability',
            builder: (context, final state) =>
                const BusinessAvailabilityScreen(),
          ),
          GoRoute(
            path: 'dashboard',
            name: 'studioDashboard',
            builder: (context, final state) =>
                const BusinessDashboardScreen(),
          ),
        ],
      ),

      // Deep link routes for WhatsApp Smart Share
      GoRoute(
        path: '/meeting/details',
        name: 'meetingDetails',
        builder: (context, final state) {
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
        builder: (context, final state) =>
            const StaffAvailabilityScreen(),
      ),
    ],
    errorBuilder: (context, final state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri.path}'),
      ),
    ),
  ),);

// Enhanced meeting details screen with Google Maps integration
class MeetingDetailsScreen extends StatefulWidget {
  const MeetingDetailsScreen({
    required this.meetingId, super.key,
    this.creatorId,
    this.contextId,
    this.groupId,
  });
  final String meetingId;
  final String? creatorId;
  final String? contextId;
  final String? groupId;

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  Map<String, dynamic>? meetingData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMeetingData();
  }

  Future<void> _loadMeetingData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Try to fetch from externalMeetings collection first
      final externalDoc = await FirebaseFirestore.instance
          .collection('externalMeetings')
          .doc(widget.meetingId)
          .get();

      if (externalDoc.exists) {
        setState(() {
          meetingData = externalDoc.data();
          isLoading = false;
        });
        return;
      }

      // If not found in externalMeetings, try appointments collection
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.meetingId)
          .get();

      if (appointmentDoc.exists) {
        setState(() {
          meetingData = appointmentDoc.data();
          isLoading = false;
        });
        return;
      }

      // If still not found, show error
      setState(() {
        error = 'Meeting not found';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading meeting: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meetingData?['title'] ?? 'Meeting Details'),
        actions: [
          if (meetingData != null)
            PopupMenuButton(
              itemBuilder: (context) => [
                if (meetingData!['link'] != null)
                  const PopupMenuItem(
                    value: 'join',
                    child: Row(
                      children: [
                        Icon(Icons.video_call, size: 16),
                        SizedBox(width: 8),
                        Text('Join Meeting'),
                      ],
                    ),
                  ),
                if (meetingData!['latitude'] != null && meetingData!['longitude'] != null)
                  const PopupMenuItem(
                    value: 'directions',
                    child: Row(
                      children: [
                        Icon(Icons.directions, size: 16),
                        SizedBox(width: 8),
                        Text('Get Directions'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 16),
                      SizedBox(width: 8),
                      Text('Share Meeting'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'join':
                    _joinMeeting(meetingData!['link']);
                    break;
                  case 'directions':
                    _openDirections(
                      meetingData!['latitude']?.toDouble(),
                      meetingData!['longitude']?.toDouble(),
                    );
                    break;
                  case 'share':
                    _shareMeeting();
                    break;
                }
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading meeting details...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(error!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadMeetingData,
              child: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    if (meetingData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('Meeting not found', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    return _buildMeetingDetails();
  }

  Widget _buildMeetingDetails() {
    final meeting = meetingData!;
    final hasLocation = meeting['latitude'] != null && meeting['longitude'] != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meeting title and basic info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: hasLocation ? Colors.green : Colors.blue,
                        child: Icon(
                          hasLocation ? Icons.location_on : Icons.video_call,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meeting['title'] ?? 'Meeting',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (meeting['description'] != null)
                              Text(
                                meeting['description'],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.calendar_today, 'Date', meeting['date']),
                  _buildInfoRow(Icons.access_time, 'Time', meeting['time']),
                  if (meeting['duration'] != null)
                    _buildInfoRow(Icons.timer, 'Duration', '${meeting['duration']} minutes'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Meeting link section
          if (meeting['link'] != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meeting Link',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              meeting['link'],
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _joinMeeting(meeting['link']),
                        icon: const Icon(Icons.video_call),
                        label: const Text('Join Meeting'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Location section with Google Maps
          if (hasLocation || meeting['address'] != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (meeting['address'] != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(meeting['address']),
                            ),
                          ],
                        ),
                      ),
                    if (hasLocation) ...[
                      const SizedBox(height: 12),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                meeting['latitude'].toDouble(),
                                meeting['longitude'].toDouble(),
                              ),
                              zoom: 16,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId(widget.meetingId),
                                position: LatLng(
                                  meeting['latitude'].toDouble(),
                                  meeting['longitude'].toDouble(),
                                ),
                                infoWindow: InfoWindow(
                                  title: meeting['title'] ?? 'Meeting Location',
                                  snippet: meeting['address'],
                                ),
                              ),
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openDirections(
                            meeting['latitude']?.toDouble(),
                            meeting['longitude']?.toDouble(),
                          ),
                          icon: const Icon(Icons.directions),
                          label: const Text('Get Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Additional information
          if (meeting['notes'] != null || widget.creatorId != null || widget.groupId != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (meeting['notes'] != null)
                      _buildInfoRow(Icons.note, 'Notes', meeting['notes']),
                    if (widget.creatorId != null)
                      _buildInfoRow(Icons.person, 'Creator', widget.creatorId!),
                    if (widget.groupId != null)
                      _buildInfoRow(Icons.group, 'Group', widget.groupId!),
                    _buildInfoRow(Icons.fingerprint, 'Meeting ID', widget.meetingId),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _joinMeeting(String? link) async {
    if (link == null) return;
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open meeting link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openDirections(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) return;
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open directions'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _shareMeeting() {
    final meeting = meetingData!;
    final meetingInfo = '''
Meeting: ${meeting['title'] ?? 'Meeting'}
Date: ${meeting['date'] ?? 'TBD'}
Time: ${meeting['time'] ?? 'TBD'}
${meeting['link'] != null ? 'Link: ${meeting['link']}' : ''}
${meeting['address'] != null ? 'Location: ${meeting['address']}' : ''}
''';

    // Copy to clipboard (simplified implementation)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meeting details copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
