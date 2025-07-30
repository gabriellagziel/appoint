import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/user_type.dart';
import 'package:appoint/providers/user_provider.dart';
import 'package:appoint/features/studio_business/models/business_event.dart';
import 'package:appoint/features/studio_business/providers/business_profile_provider.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:appoint/widgets/business_header_widget.dart';

class BusinessDashboardScreen extends ConsumerWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isStudioUser = user?.userType == UserType.studio;
    final businessProfile = ref.watch(businessProfileProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (isStudioUser) ...[
              const AppLogo(size: 32, logoOnly: true),
              const SizedBox(width: 12),
            ],
            Text(isStudioUser ? 'Studio Dashboard' : 'Business Dashboard'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (businessProfile != null)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/business/profile'),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Business Profile',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context, isStudioUser),
            const SizedBox(height: 24),
            
            // Business Branding Preview Card
            if (businessProfile != null) ...[
              _buildBrandingPreviewCard(context, businessProfile),
              const SizedBox(height: 24),
            ],
            
            if (isStudioUser) ...[
              _buildStudioBookingsSection(context),
              const SizedBox(height: 24),
            ],
            _buildStatsGrid(context, isStudioUser),
            const SizedBox(height: 24),
            _buildQuickActions(context, isStudioUser),
            const SizedBox(height: 24),
            _buildRecentActivity(context, isStudioUser),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingPreviewCard(BuildContext context, businessProfile) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  color: Colors.purple.shade600,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Client View Preview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This is how your business appears to clients during booking:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            
            // Preview using the business header widget
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const BusinessHeaderWidget(
                showDescription: true,
                showServices: true,
                showHours: true,
                compact: false,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Branded Booking Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.branding_watermark,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Branded Booking Experience',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Show your branding on all client booking pages',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true, // For now, always enabled
                    onChanged: (value) {
                      // TODO: Implement branded booking toggle
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Branded booking is always enabled for verified businesses'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    activeColor: Colors.blue.shade600,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/business/profile'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Branding'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple.shade600,
                      side: BorderSide(color: Colors.purple.shade300),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement share business page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Public business page coming soon!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share Page'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, bool isStudioUser) => Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isStudioUser 
                ? 'Welcome to Your Studio Dashboard'
                : 'Welcome to Your Business Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isStudioUser
                ? 'Manage your studio bookings, clients, and content all in one place.'
                : 'Manage your appointments, clients, and business analytics all in one place.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );

  Widget _buildStudioBookingsSection(BuildContext context) {
    // TODO(username): Replace with real bookings from business service
    final upcomingBookings = <BusinessEvent>[];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Bookings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (upcomingBookings.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No upcoming bookings'),
                  ],
                ),
              )
            else
              ...upcomingBookings.map((event) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text(
                          '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} → ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',),
                      trailing: Text(event.type),
                    ),
                  ),),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isStudioUser) => GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          isStudioUser ? 'Studio Sessions' : 'Total Appointments',
          '24',
          isStudioUser ? Icons.videocam : Icons.calendar_today,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          isStudioUser ? 'Active Members' : 'Active Clients',
          '12',
          Icons.people,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Revenue This Month',
          r'$2,450',
          Icons.attach_money,
          Colors.orange,
        ),
        _buildStatCard(
          context,
          isStudioUser ? 'Pending Bookings' : 'Pending Requests',
          '3',
          Icons.pending,
          Colors.red,
        ),
      ],
    );

  Widget _buildStatCard(final BuildContext context, final String title,
      String value, final IconData icon, final Color color,) => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

  Widget _buildQuickActions(BuildContext context, bool isStudioUser) => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (isStudioUser)
              _buildStudioQuickActions(context)
            else
              _buildBusinessQuickActions(context),
          ],
        ),
      ),
    );

  Widget _buildBusinessQuickActions(BuildContext context) => Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'New Appointment',
                Icons.add_circle,
                Colors.blue,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Add Client',
                Icons.person_add,
                Colors.green,
                () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'View Calendar',
                Icons.calendar_month,
                Colors.orange,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Analytics',
                Icons.analytics,
                Colors.purple,
                () {},
              ),
            ),
          ],
        ),
      ],
    );

  Widget _buildStudioQuickActions(BuildContext context) => Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(
          context,
          'Calendar',
          Icons.calendar_today,
          Colors.blue,
          () => Navigator.pushNamed(context, '/business/calendar'),
        ),
        _buildActionButton(
          context,
          'Availability',
          Icons.access_time,
          Colors.green,
          () => Navigator.pushNamed(context, '/business/availability'),
        ),
        _buildActionButton(
          context,
          'Profile',
          Icons.person,
          Colors.orange,
          () => Navigator.pushNamed(context, '/business/profile'),
        ),
        _buildActionButton(
          context,
          'Studio Booking',
          Icons.videocam,
          Colors.purple,
          () => Navigator.pushNamed(context, '/studio/booking'),
        ),
      ],
    );

  Widget _buildActionButton(final BuildContext context, final String label,
      IconData icon, final Color color, final VoidCallback onTap,) => ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );

  Widget _buildRecentActivity(BuildContext context, bool isStudioUser) => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (isStudioUser) 
              _buildStudioRecentActivity(context)
            else
              _buildBusinessRecentActivity(context),
          ],
        ),
      ),
    );

  Widget _buildBusinessRecentActivity(BuildContext context) => Column(
      children: [
        _buildActivityItem(
          context,
          'New appointment booked',
          'John Doe - Haircut',
          '2 hours ago',
          Icons.calendar_today,
          Colors.blue,
        ),
        _buildActivityItem(
          context,
          'Client added',
          'Jane Smith',
          '4 hours ago',
          Icons.person_add,
          Colors.green,
        ),
        _buildActivityItem(
          context,
          'Payment received',
          r'$85.00 - Massage session',
          '6 hours ago',
          Icons.payment,
          Colors.orange,
        ),
        _buildActivityItem(
          context,
          'Appointment cancelled',
          'Mike Johnson - Consultation',
          '1 day ago',
          Icons.cancel,
          Colors.red,
        ),
      ],
    );

  Widget _buildStudioRecentActivity(BuildContext context) => Column(
      children: [
        _buildActivityItem(
          context,
          'Studio session booked',
          'Alice Cooper - Recording',
          '1 hour ago',
          Icons.videocam,
          Colors.blue,
        ),
        _buildActivityItem(
          context,
          'Equipment reserved',
          'Camera Setup A',
          '3 hours ago',
          Icons.camera_alt,
          Colors.green,
        ),
        _buildActivityItem(
          context,
          'Member joined',
          'Bob Wilson',
          '5 hours ago',
          Icons.person_add,
          Colors.orange,
        ),
        _buildActivityItem(
          context,
          'Session completed',
          'Sarah Davis - Photo Shoot',
          '1 day ago',
          Icons.check_circle,
          Colors.purple,
        ),
      ],
    );

  Widget _buildActivityItem(
      final BuildContext context,
      final String title,
      final String subtitle,
      final String time,
      final IconData icon,
      Color color,) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500]),
          ),
        ],
      ),
    );
}
