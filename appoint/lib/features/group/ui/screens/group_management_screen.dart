import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../services/group_sharing_service.dart';
import '../../../../models/user_group.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/group_providers.dart';
import '../widgets/group_card.dart';
import '../widgets/group_empty_state.dart';

class GroupManagementScreen extends ConsumerWidget {
  const GroupManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState == null || authState.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Groups')),
        body: const Center(
          child: Text('Please log in to view your groups'),
        ),
      );
    }

    final userGroupsAsync = ref.watch(userGroupsProvider(authState.user!.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            onPressed: () => _showCreateGroupDialog(context, ref),
            icon: const Icon(Icons.add),
            tooltip: 'Create New Group',
          ),
        ],
      ),
      body: userGroupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return GroupEmptyState(
              onCreateGroup: () => _showCreateGroupDialog(context, ref),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userGroupsProvider(authState.user!.uid));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GroupCard(
                    group: group,
                    currentUserId: authState.user!.uid,
                    onTap: () => context.go('/groups/${group.id}'),
                  ),
                );
              },
            ),
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
                'Failed to load groups',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(userGroupsProvider(authState.user!.uid)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    if (authState == null || authState.user == null) return;

    showDialog(
      context: context,
      builder: (context) => CreateGroupDialog(
        userId: authState.user!.uid,
        onGroupCreated: (group) {
          ref.invalidate(userGroupsProvider(authState.user!.uid));
          Navigator.of(context).pop();
          context.go('/groups/${group.id}');
        },
      ),
    );
  }
}

class CreateGroupDialog extends StatefulWidget {
  final String userId;
  final Function(UserGroup) onGroupCreated;

  const CreateGroupDialog({
    super.key,
    required this.userId,
    required this.onGroupCreated,
  });

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final service = GroupSharingService();
      final inviteCode = await service.createGroupInvite(
        widget.userId,
        groupName: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      final group = await service.getGroupById(inviteCode);
      if (group != null) {
        widget.onGroupCreated(group);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Group'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                hintText: 'Enter group name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter group description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createGroup,
          child: _isCreating
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
