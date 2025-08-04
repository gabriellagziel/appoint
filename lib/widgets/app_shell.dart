import 'package:appoint/constants/app_branding.dart';
import 'package:appoint/providers/user_provider.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(body: child);
    }

    final items = user.businessMode
        ? businessMenuItems
        : user.isStudio
            ? studioMenuItems
            : user.isAdmin
                ? adminMenuItems
                : personalMenuItems;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLogo(size: 48, showText: false),
                  const SizedBox(height: 8),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppBranding.fullSlogan,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, final index) {
                  final item = items[index];
                  return ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.label),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      context.go(item.route);
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO(username): Implement this featurent logout
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.label,
    required this.icon,
    required this.route,
  });
  final String label;
  final IconData icon;
  final String route;
}

// Personal user menu items
final List<MenuItem> personalMenuItems = [
  const MenuItem(
    label: 'Home',
    icon: Icons.home,
    route: '/dashboard',
  ),
  const MenuItem(
    label: 'Discover',
    icon: Icons.search,
    route: '/discover',
  ),
  const MenuItem(
    label: 'Invitations',
    icon: Icons.inbox,
    route: '/invitations',
  ),
  const MenuItem(
    label: 'Calendar',
    icon: Icons.calendar_today,
    route: '/google/calendar',
  ),
  const MenuItem(
    label: 'Appointments',
    icon: Icons.schedule,
    route: '/booking/request',
  ),
  const MenuItem(
    label: 'Profile',
    icon: Icons.person,
    route: '/profile',
  ),
];

// Studio user menu items
final List<MenuItem> studioMenuItems = [
  const MenuItem(
    label: 'Studio Dashboard',
    icon: Icons.dashboard,
    route: '/studio/dashboard',
  ),
  const MenuItem(
    label: 'Studio Booking',
    icon: Icons.book_online,
    route: '/studio/booking',
  ),
  const MenuItem(
    label: 'Manage Availability',
    icon: Icons.settings_backup_restore,
    route: '/studio/staff-availability',
  ),
  const MenuItem(
    label: 'Studio Calendar',
    icon: Icons.calendar_today,
    route: '/studio/calendar',
  ),
  const MenuItem(
    label: 'Studio Profile',
    icon: Icons.business,
    route: '/studio/profile',
  ),
  const MenuItem(
    label: 'Profile',
    icon: Icons.person,
    route: '/profile',
  ),
];

// Business user menu items
final List<MenuItem> businessMenuItems = [
  const MenuItem(
    label: 'Business Dashboard',
    icon: Icons.dashboard,
    route: '/business/dashboard',
  ),
  const MenuItem(
    label: 'Clients',
    icon: Icons.people,
    route: '/business/clients',
  ),
  const MenuItem(
    label: 'Appointments',
    icon: Icons.schedule,
    route: '/business/appointments',
  ),
  const MenuItem(
    label: 'Invoices',
    icon: Icons.receipt,
    route: '/business/invoices',
  ),
  const MenuItem(
    label: 'Messages',
    icon: Icons.message,
    route: '/business/messages',
  ),
  const MenuItem(
    label: 'Analytics',
    icon: Icons.analytics,
    route: '/business/analytics',
  ),
  const MenuItem(
    label: 'Rooms',
    icon: Icons.meeting_room,
    route: '/business/rooms',
  ),
  const MenuItem(
    label: 'Providers',
    icon: Icons.person_add,
    route: '/business/providers',
  ),
  const MenuItem(
    label: 'Appointment Requests',
    icon: Icons.pending_actions,
    route: '/business/appointment-requests',
  ),
  const MenuItem(
    label: 'External Meetings',
    icon: Icons.video_call,
    route: '/business/external-meetings',
  ),
  const MenuItem(
    label: 'Business Profile',
    icon: Icons.business,
    route: '/business/profile',
  ),
  const MenuItem(
    label: 'Settings',
    icon: Icons.settings,
    route: '/business/settings',
  ),
];

// Admin user menu items
final List<MenuItem> adminMenuItems = [
  const MenuItem(
    label: 'Admin Dashboard',
    icon: Icons.admin_panel_settings,
    route: '/admin/dashboard',
  ),
  const MenuItem(
    label: 'Broadcast',
    icon: Icons.broadcast_on_personal,
    route: '/admin/broadcast',
  ),
  const MenuItem(
    label: 'Profile',
    icon: Icons.person,
    route: '/profile',
  ),
];
