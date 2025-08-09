import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member_model.dart';

class FamilyDashboardScreen extends ConsumerStatefulWidget {
  const FamilyDashboardScreen({super.key});

  @override
  ConsumerState<FamilyDashboardScreen> createState() =>
      _FamilyDashboardScreenState();
}

class _FamilyDashboardScreenState extends ConsumerState<FamilyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load family members
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _showInviteDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Family Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Johnson Family',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '4 members • 2 parents • 2 children',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pending Approvals
            _buildPendingApprovalsSection(),
            const SizedBox(height: 24),

            // Family Members
            _buildFamilyMembersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingApprovalsSection() {
    // Mock pending approvals
    final pendingApprovals = [
      FamilyMember(
        id: '4',
        name: 'Alex Johnson',
        email: 'alex@example.com',
        role: FamilyRole.child,
        joinedAt: DateTime.now().subtract(const Duration(days: 15)),
        approvalStatus: ApprovalStatus.pending,
        invitedBy: '1',
      ),
    ];

    if (pendingApprovals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pending Approvals',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pendingApprovals.length,
            itemBuilder: (context, index) {
              final member = pendingApprovals[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: member.roleColor.withValues(alpha: 0.1),
                  child: Icon(member.roleIcon, color: member.roleColor),
                ),
                title: Text(member.name),
                subtitle: Text(member.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _approveMember(member.id),
                      child: const Text('Approve'),
                    ),
                    TextButton(
                      onPressed: () => _denyMember(member.id),
                      child: const Text('Deny',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyMembersSection() {
    // Mock family members
    final familyMembers = [
      FamilyMember(
        id: '1',
        name: 'Sarah Johnson',
        email: 'sarah@example.com',
        role: FamilyRole.parent,
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
        approvalStatus: ApprovalStatus.approved,
      ),
      FamilyMember(
        id: '2',
        name: 'Mike Johnson',
        email: 'mike@example.com',
        role: FamilyRole.parent,
        joinedAt: DateTime.now().subtract(const Duration(days: 25)),
        approvalStatus: ApprovalStatus.approved,
      ),
      FamilyMember(
        id: '3',
        name: 'Emma Johnson',
        email: 'emma@example.com',
        role: FamilyRole.child,
        joinedAt: DateTime.now().subtract(const Duration(days: 20)),
        approvalStatus: ApprovalStatus.approved,
      ),
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Family Members',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: familyMembers.length,
                itemBuilder: (context, index) {
                  final member = familyMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: member.roleColor.withValues(alpha: 0.1),
                      child: Icon(member.roleIcon, color: member.roleColor),
                    ),
                    title: Text(member.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.email),
                        Text(
                          member.roleDisplayName,
                          style: TextStyle(
                            color: member.roleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _handleMemberAction(value, member),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('View Details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.remove_circle, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Remove',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _showMemberDetails(member),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<FamilyRole>(
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: FamilyRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.name),
                );
              }).toList(),
              onChanged: (value) {
                // Handle role selection
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Send invitation
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invitation sent!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Send Invitation'),
          ),
        ],
      ),
    );
  }

  void _approveMember(String memberId) {
    // TODO: Approve member
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Member approved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _denyMember(String memberId) {
    // TODO: Deny member
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Member denied'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleMemberAction(String action, FamilyMember member) {
    switch (action) {
      case 'view':
        _showMemberDetails(member);
        break;
      case 'remove':
        _showRemoveConfirmation(member);
        break;
    }
  }

  void _showMemberDetails(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member.name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Email', member.email),
            _buildDetailRow('Role', member.roleDisplayName),
            _buildDetailRow('Status', member.statusDisplayName),
            _buildDetailRow('Joined',
                '${member.joinedAt.day}/${member.joinedAt.month}/${member.joinedAt.year}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmation(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text(
            'Are you sure you want to remove ${member.name} from the family?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Remove member
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member.name} removed from family'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}






