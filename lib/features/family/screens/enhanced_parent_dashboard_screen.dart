import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/enhanced_family_provider.dart';
import 'package:appoint/models/enhanced_family_link.dart';
import 'package:appoint/models/supervision_level.dart';

class EnhancedParentDashboardScreen extends ConsumerStatefulWidget {
  const EnhancedParentDashboardScreen({super.key});

  @override
  ConsumerState<EnhancedParentDashboardScreen> createState() => _EnhancedParentDashboardScreenState();
}

class _EnhancedParentDashboardScreenState extends ConsumerState<EnhancedParentDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final familyLinksAsync = ref.watch(enhancedFamilyLinksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.parentDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddChildDialog(context),
            tooltip: l10n.addChild,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/parent/notifications'),
            tooltip: l10n.notifications,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/parent/settings'),
            tooltip: l10n.settings,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.dashboard), text: l10n.overview),
            Tab(icon: const Icon(Icons.child_care), text: l10n.children),
            Tab(icon: const Icon(Icons.schedule), text: l10n.activity),
            Tab(icon: const Icon(Icons.security), text: l10n.controls),
          ],
        ),
      ),
      body: familyLinksAsync.when(
        data: (familyLinks) => TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(context, l10n, familyLinks),
            _buildChildrenTab(context, l10n, familyLinks),
            _buildActivityTab(context, l10n, familyLinks),
            _buildControlsTab(context, l10n, familyLinks),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingData,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.refresh(enhancedFamilyLinksProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, AppLocalizations l10n, List<EnhancedFamilyLink> familyLinks) {
    final activeChildren = familyLinks.where((link) => link.status == 'active').toList();
    final pendingApprovals = familyLinks.where((link) => link.status == 'pending_approval').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  l10n.totalChildren,
                  activeChildren.length.toString(),
                  Icons.child_care,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.pendingApprovals,
                  pendingApprovals.toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        l10n.recentActivity,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...activeChildren.take(3).map((child) => _buildActivitySummaryItem(context, l10n, child)),
                  if (activeChildren.length > 3)
                    TextButton(
                      onPressed: () => _tabController.animateTo(2),
                      child: Text(l10n.viewAllActivity),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Children Quick Access
          Text(
            l10n.quickAccess,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...activeChildren.map((child) => _buildChildQuickAccessCard(context, l10n, child)),
        ],
      ),
    );
  }

  Widget _buildChildrenTab(BuildContext context, AppLocalizations l10n, List<EnhancedFamilyLink> familyLinks) {
    return Column(
      children: [
        // Child Selector
        if (familyLinks.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedChildId,
              decoration: InputDecoration(
                labelText: l10n.selectChild,
                border: const OutlineInputBorder(),
              ),
              items: familyLinks.map((child) => DropdownMenuItem(
                value: child.childId,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: child.childPhotoUrl != null 
                          ? NetworkImage(child.childPhotoUrl!) 
                          : null,
                      child: child.childPhotoUrl == null 
                          ? Text(child.childDisplayName[0].toUpperCase())
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(child.childDisplayName),
                          Text(
                            _getSupervisionLevelText(l10n, child.supervisionLevel),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedChildId = value;
                });
              },
            ),
          ),

        // Child Details
        Expanded(
          child: _selectedChildId != null
              ? _buildChildDetailsView(context, l10n, familyLinks.firstWhere((link) => link.childId == _selectedChildId))
              : _buildAllChildrenView(context, l10n, familyLinks),
        ),
      ],
    );
  }

  Widget _buildActivityTab(BuildContext context, AppLocalizations l10n, List<EnhancedFamilyLink> familyLinks) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'This Week'),
              Tab(text: 'This Month'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildActivityTimeframe(context, l10n, familyLinks, 'today'),
                _buildActivityTimeframe(context, l10n, familyLinks, 'week'),
                _buildActivityTimeframe(context, l10n, familyLinks, 'month'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsTab(BuildContext context, AppLocalizations l10n, List<EnhancedFamilyLink> familyLinks) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.globalControls,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          _buildGlobalControlCard(
            l10n.emergencyMode,
            l10n.emergencyModeDescription,
            Icons.emergency,
            Colors.red,
            false,
            (value) => _toggleEmergencyMode(value),
          ),
          
          _buildGlobalControlCard(
            l10n.familyLocation,
            l10n.familyLocationDescription,
            Icons.location_on,
            Colors.blue,
            true,
            (value) => _toggleFamilyLocation(value),
          ),

          const SizedBox(height: 24),
          Text(
            l10n.perChildControls,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          ...familyLinks.map((child) => _buildChildControlCard(context, l10n, child)),
        ],
      ),
    );
  }

  Widget _buildChildDetailsView(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor.withOpacity(0.1), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: child.childPhotoUrl != null ? NetworkImage(child.childPhotoUrl!) : null,
                  child: child.childPhotoUrl == null ? Text(child.childDisplayName[0].toUpperCase()) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.childDisplayName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.age}: ${child.childAge} • ${_getSupervisionLevelText(l10n, child.supervisionLevel)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      _buildSupervisionLevelChip(l10n, child.supervisionLevel),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editChildSettings(context, child),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Supervision Level Settings
          _buildSupervisionLevelSection(context, l10n, child),
          const SizedBox(height: 24),

          // Permissions Section
          _buildPermissionsSection(context, l10n, child),
          const SizedBox(height: 24),

          // Notifications Section
          _buildNotificationsSection(context, l10n, child),
          const SizedBox(height: 24),

          // Recent Activity
          _buildRecentActivitySection(context, l10n, child),
        ],
      ),
    );
  }

  Widget _buildAllChildrenView(BuildContext context, AppLocalizations l10n, List<EnhancedFamilyLink> familyLinks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: familyLinks.length,
      itemBuilder: (context, index) {
        final child = familyLinks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: child.childPhotoUrl != null ? NetworkImage(child.childPhotoUrl!) : null,
              child: child.childPhotoUrl == null ? Text(child.childDisplayName[0].toUpperCase()) : null,
            ),
            title: Text(child.childDisplayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.age}: ${child.childAge}'),
                const SizedBox(height: 4),
                _buildSupervisionLevelChip(l10n, child.supervisionLevel),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => _viewChildNotifications(context, child),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _editChildSettings(context, child),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _selectedChildId = child.childId;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildSupervisionLevelSection(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.supervisionLevel,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...SupervisionLevel.values.map((level) => RadioListTile<SupervisionLevel>(
              title: Text(_getSupervisionLevelText(l10n, level)),
              subtitle: Text(_getSupervisionLevelDescription(l10n, level)),
              value: level,
              groupValue: child.supervisionLevel,
              onChanged: child.childAge >= 16 || level != SupervisionLevel.free
                  ? (value) => _updateSupervisionLevel(child, value!)
                  : null,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.permissions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...child.permissions.entries.map((permission) => SwitchListTile(
              title: Text(_getPermissionDisplayName(l10n, permission.key)),
              subtitle: Text(_getPermissionDescription(l10n, permission.key)),
              value: permission.value,
              onChanged: (value) => _updatePermission(child, permission.key, value),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notifications,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...child.notificationSettings.entries.map((setting) => SwitchListTile(
              title: Text(_getNotificationDisplayName(l10n, setting.key)),
              subtitle: Text(_getNotificationDescription(l10n, setting.key)),
              value: setting.value,
              onChanged: child.supervisionLevel != SupervisionLevel.free
                  ? (value) => _updateNotificationSetting(child, setting.key, value)
                  : null,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentActivity,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => _viewFullActivity(context, child),
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // TODO: Implement activity list based on actual data
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.apps),
                title: Text('Playtime session'),
                subtitle: Text('2 hours ago'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySummaryItem(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: child.childPhotoUrl != null ? NetworkImage(child.childPhotoUrl!) : null,
            child: child.childPhotoUrl == null ? Text(child.childDisplayName[0]) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('${child.childDisplayName} used Playtime for 1.5 hours'),
          ),
          Text('2h ago', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildChildQuickAccessCard(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: child.childPhotoUrl != null ? NetworkImage(child.childPhotoUrl!) : null,
          child: child.childPhotoUrl == null ? Text(child.childDisplayName[0]) : null,
        ),
        title: Text(child.childDisplayName),
        subtitle: Text(_getSupervisionLevelText(l10n, child.supervisionLevel)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () => _viewChildLocation(context, child),
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () => _messageChild(context, child),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _selectedChildId = child.childId;
          });
          _tabController.animateTo(1);
        },
      ),
    );
  }

  Widget _buildSupervisionLevelChip(AppLocalizations l10n, SupervisionLevel level) {
    Color color;
    switch (level) {
      case SupervisionLevel.full:
        color = Colors.red;
        break;
      case SupervisionLevel.free:
        color = Colors.green;
        break;
      case SupervisionLevel.custom:
        color = Colors.orange;
        break;
    }

    return Chip(
      label: Text(
        _getSupervisionLevelText(l10n, level),
        style: TextStyle(color: color, fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color),
    );
  }

  // Action methods
  void _showAddChildDialog(BuildContext context) {
    // TODO: Implement add child dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Child'),
        content: const Text('This will open the child invitation flow.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/family/invite-child');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  String _getSupervisionLevelText(AppLocalizations l10n, SupervisionLevel level) {
    switch (level) {
      case SupervisionLevel.full:
        return l10n.fullParentalControl;
      case SupervisionLevel.free:
        return l10n.freeMode;
      case SupervisionLevel.custom:
        return l10n.customMode;
    }
  }

  String _getSupervisionLevelDescription(AppLocalizations l10n, SupervisionLevel level) {
    switch (level) {
      case SupervisionLevel.full:
        return l10n.fullParentalControlDescription;
      case SupervisionLevel.free:
        return l10n.freeModeDescription;
      case SupervisionLevel.custom:
        return l10n.customModeDescription;
    }
  }

  // TODO: Implement remaining methods
  Widget _buildActivityTimeframe(BuildContext context, AppLocalizations l10n, List<EnhancedFamilyLink> familyLinks, String timeframe) => const Center(child: Text('Activity data'));
  Widget _buildGlobalControlCard(String title, String description, IconData icon, Color color, bool value, Function(bool) onChanged) => const Card();
  Widget _buildChildControlCard(BuildContext context, AppLocalizations l10n, EnhancedFamilyLink child) => const Card();
  void _toggleEmergencyMode(bool value) {}
  void _toggleFamilyLocation(bool value) {}
  void _editChildSettings(BuildContext context, EnhancedFamilyLink child) {}
  void _viewChildNotifications(BuildContext context, EnhancedFamilyLink child) {}
  void _updateSupervisionLevel(EnhancedFamilyLink child, SupervisionLevel level) {}
  void _updatePermission(EnhancedFamilyLink child, String permission, bool value) {}
  void _updateNotificationSetting(EnhancedFamilyLink child, String setting, bool value) {}
  void _viewFullActivity(BuildContext context, EnhancedFamilyLink child) {}
  void _viewChildLocation(BuildContext context, EnhancedFamilyLink child) {}
  void _messageChild(BuildContext context, EnhancedFamilyLink child) {}
  String _getPermissionDisplayName(AppLocalizations l10n, String key) => key;
  String _getPermissionDescription(AppLocalizations l10n, String key) => '';
  String _getNotificationDisplayName(AppLocalizations l10n, String key) => key;
  String _getNotificationDescription(AppLocalizations l10n, String key) => '';
}