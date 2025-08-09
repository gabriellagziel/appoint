import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/user_group.dart';
import '../../../../models/group_invite.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/group_providers.dart';

class GroupJoinScreen extends ConsumerStatefulWidget {
  final String inviteCode;

  const GroupJoinScreen({
    super.key,
    required this.inviteCode,
  });

  @override
  ConsumerState<GroupJoinScreen> createState() => _GroupJoinScreenState();
}

class _GroupJoinScreenState extends ConsumerState<GroupJoinScreen> {
  bool _isLoading = true;
  bool _isJoining = false;
  GroupInvite? _invite;
  UserGroup? _group;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInviteDetails();
  }

  Future<void> _loadInviteDetails() async {
    try {
      final service = ref.read(groupSharingServiceProvider);
      final invite = await service.getGroupInvite(widget.inviteCode);

      if (invite == null) {
        setState(() {
          _error = 'Invalid invite code';
          _isLoading = false;
        });
        return;
      }

      if (!invite.isValid) {
        setState(() {
          _error = 'This invite has expired or reached its usage limit';
          _isLoading = false;
        });
        return;
      }

      final group = await service.getGroupById(invite.groupId);

      setState(() {
        _invite = invite;
        _group = group;
        _isLoading = false;
      });

      // Auto-join if user is logged in
      final authState = ref.read(authStateProvider);
      if (authState != null && authState.user != null) {
        _joinGroup();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load invite details: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _joinGroup() async {
    final authState = ref.read(authStateProvider);
    if (authState == null || authState.user == null) {
      // Redirect to login
      context.go('/login?redirect=/group-invite/${widget.inviteCode}');
      return;
    }

    setState(() {
      _isJoining = true;
    });

    try {
      final service = ref.read(groupSharingServiceProvider);
      final group = await service.joinGroupFromCode(
          widget.inviteCode, authState.user!.uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${group.name}!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to group details or home
        context.go('/groups/${group.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to join group: $e';
          _isJoining = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _buildInviteDetails(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteDetails() {
    if (_group == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Group Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.group,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Group Name
          Text(
            _group!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Group Description
          if (_group!.description != null) ...[
            Text(
              _group!.description!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],

          // Member Count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${_group!.memberCount} members',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Join Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isJoining ? null : _joinGroup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isJoining
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Join Group',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Cancel Button
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
