import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showInviteDialog(context),
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
            _buildPendingApprovalsSection(context),
            const SizedBox(height: 24),

            // Family Members
            _buildFamilyMembersSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingApprovalsSection(BuildContext context) {
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
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              child: const Icon(Icons.child_care, color: Colors.green),
            ),
            title: const Text('Alex Johnson'),
            subtitle: const Text('alex@example.com'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => _approveMember(context),
                  child: const Text('Approve'),
                ),
                TextButton(
                  onPressed: () => _denyMember(context),
                  child:
                      const Text('Deny', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyMembersSection(BuildContext context) {
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
              child: ListView(
                children: [
                  _buildMemberTile(
                      context,
                      'Sarah Johnson',
                      'sarah@example.com',
                      'Parent',
                      Colors.blue,
                      Icons.family_restroom),
                  _buildMemberTile(context, 'Mike Johnson', 'mike@example.com',
                      'Parent', Colors.blue, Icons.family_restroom),
                  _buildMemberTile(context, 'Emma Johnson', 'emma@example.com',
                      'Child', Colors.green, Icons.child_care),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, String name, String email,
      String role, Color color, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(email),
          Text(
            role,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleMemberAction(context, value, name),
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
                Text('Remove', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
      onTap: () => _showMemberDetails(context, name, email, role),
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'parent', child: Text('Parent')),
                DropdownMenuItem(value: 'child', child: Text('Child')),
                DropdownMenuItem(value: 'spouse', child: Text('Spouse')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
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

  void _approveMember(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Member approved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _denyMember(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Member denied'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleMemberAction(
      BuildContext context, String action, String memberName) {
    switch (action) {
      case 'view':
        _showMemberDetails(context, memberName, 'email@example.com', 'Role');
        break;
      case 'remove':
        _showRemoveConfirmation(context, memberName);
        break;
    }
  }

  void _showMemberDetails(
      BuildContext context, String name, String email, String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Email', email),
            _buildDetailRow('Role', role),
            _buildDetailRow('Status', 'Active'),
            _buildDetailRow('Joined', '15 days ago'),
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

  void _showRemoveConfirmation(BuildContext context, String memberName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text(
            'Are you sure you want to remove $memberName from the family?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$memberName removed from family'),
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
