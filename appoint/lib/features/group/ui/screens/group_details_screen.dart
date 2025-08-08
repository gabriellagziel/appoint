import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../services/group_sharing_service.dart';
import '../../../../models/user_group.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/group_providers.dart';
import '../../../group_admin/ui/group_members_tab.dart';
import '../../../group_admin/ui/group_admin_tab.dart';
import '../../../group_admin/ui/group_policy_tab.dart';
import '../../../group_admin/ui/group_votes_tab.dart';
import '../../../group_admin/ui/group_audit_tab.dart';

class GroupDetailsScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends ConsumerState<GroupDetailsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late TabController _tabController;

  Future<void> _leaveGroup() async {
    final authState = ref.read(authStateProvider);
    if (authState == null || authState.user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(groupSharingServiceProvider);
      await service.leaveGroup(widget.groupId, authState.user!.uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully left the group'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/groups');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to leave group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupProvider(widget.groupId));
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: groupAsync.when(
          data: (group) => Text(group?.name ?? 'Group Details'),
          loading: () => const Text('Group Details'),
          error: (_, __) => const Text('Group Details'),
        ),
        bottom: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'Members'),
            Tab(text: 'Admin'),
            Tab(text: 'Policy'),
            Tab(text: 'Votes'),
            Tab(text: 'Audit'),
          ],
        ),
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Share functionality coming soon')),
                );
              },
              icon: const Icon(Icons.share),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupAsync.when(
              data: (group) {
                if (group == null) {
                  return const Center(child: Text('Group not found'));
                }

                final isAdmin = group.admins.contains(authState?.user?.uid);
                final isMember = group.members.contains(authState?.user?.uid);

                if (!isMember) {
                  return const Center(
                    child: Text('You are not a member of this group'),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    GroupMembersTab(groupId: widget.groupId),
                    GroupAdminTab(groupId: widget.groupId),
                    GroupPolicyTab(groupId: widget.groupId),
                    GroupVotesTab(groupId: widget.groupId),
                    GroupAuditTab(groupId: widget.groupId),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load group details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.refresh(groupProvider(widget.groupId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
