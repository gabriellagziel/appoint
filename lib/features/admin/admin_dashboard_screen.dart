import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/widgets/admin_guard.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:appoint/features/admin/admin_users_screen.dart';
import 'package:appoint/features/admin/admin_orgs_screen.dart';
import 'package:appoint/features/admin/widgets/admin_overview_tab.dart';
import 'package:appoint/features/admin/widgets/admin_errors_tab.dart';
import 'package:appoint/features/admin/widgets/admin_activity_tab.dart';
import 'package:appoint/features/admin/widgets/admin_monetization_tab.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AdminGuard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.adminScreenTBD ?? 'Admin Dashboard'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            Semantics(
              label: 'Refresh dashboard data',
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(adminDashboardStatsProvider);
                  ref.invalidate(errorLogsProvider);
                  ref.invalidate(activityLogsProvider);
                },
              ),
            ),
            Semantics(
              label: 'Open admin settings',
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettingsDialog(),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.error), text: 'Errors'),
              Tab(icon: Icon(Icons.history), text: 'Activity'),
              Tab(icon: Icon(Icons.monetization_on), text: 'Monetization'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const AdminOverviewTab(),
            const AdminErrorsTab(),
            const AdminActivityTab(),
            const AdminMonetizationTab(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
        drawer: _buildDrawer(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    switch (_selectedIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (final context) => const AdminBroadcastScreen(),
            ),
          ),
          child: const Icon(Icons.broadcast_on_personal),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: _selectedIndex == 0,
            onTap: () {
              _tabController.animateTo(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.broadcast_on_personal),
            title: const Text('Broadcast'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => const AdminBroadcastScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Users'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => const AdminUsersScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Organizations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => const AdminOrgsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Admin Settings'),
        content: const Text('Settings dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
