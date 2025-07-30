import 'package:appoint/models/family_link.dart';
import 'package:appoint/models/permission.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({
    required this.familyLink,
    super.key,
  });
  final FamilyLink familyLink;

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final permissionsAsync = ref.watch(permissionsProvider(familyLink.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Permissions - ${familyLink.childId}'),
      ),
      body: permissionsAsync.when(
        data: (permissions) => _buildPermissionsList(context, ref, permissions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) => Center(
          child: Text('Error loading permissions: $error'),
        ),
      ),
    );
  }

  Widget _buildPermissionsList(
    final BuildContext context,
    final WidgetRef ref,
    final List<Permission> permissions,
  ) =>
      ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: permissions.length,
        itemBuilder: (context, final index) {
          final permission = permissions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                _getAccessLevelIcon(permission.accessLevel),
                color: _getAccessLevelColor(permission.accessLevel),
              ),
              title: Text(_getCategoryDisplayName(permission.category)),
              subtitle: Text(_getCategoryDescription(permission.category)),
              trailing: _buildAccessLevelSelector(context, ref, permission),
            ),
          );
        },
      );

  Widget _buildAccessLevelSelector(
    final BuildContext context,
    final WidgetRef ref,
    final Permission permission,
  ) =>
      DropdownButton<String>(
        value: permission.accessLevel,
        onChanged: (String? newValue) {
          if (newValue != null) {
            _updatePermission(context, ref, permission, newValue);
          }
        },
        items: const [
          DropdownMenuItem(value: 'none', child: Text('None')),
          DropdownMenuItem(value: 'read', child: Text('Read Only')),
          DropdownMenuItem(value: 'write', child: Text('Read & Write')),
        ],
      );

  IconData _getAccessLevelIcon(String accessLevel) {
    switch (accessLevel) {
      case 'none':
        return Icons.cancel;
      case 'read':
        return Icons.visibility;
      case 'write':
        return Icons.edit;
      default:
        return Icons.help;
    }
  }

  Color _getAccessLevelColor(String accessLevel) {
    switch (accessLevel) {
      case 'none':
        return Colors.red;
      case 'read':
        return Colors.orange;
      case 'write':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'profile':
        return 'Profile Information';
      case 'activity':
        return 'Activity & Location';
      case 'messages':
        return 'Messages & Communication';
      case 'payments':
        return 'Payment Information';
      case 'bookings':
        return 'Booking History';
      default:
        return category;
    }
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'profile':
        return 'Access to personal information and settings';
      case 'activity':
        return 'View location and activity history';
      case 'messages':
        return 'Read and send messages on behalf of the child';
      case 'payments':
        return 'View and manage payment methods';
      case 'bookings':
        return 'View booking history and manage appointments';
      default:
        return 'Manage access to this category';
    }
  }

  Future<void> _updatePermission(
    final BuildContext context,
    final WidgetRef ref,
    final Permission permission,
    final String newValue,
  ) async {
    try {
      // Create updated permission with new access level
      final updatedPermission = Permission(
        id: permission.id,
        familyLinkId: permission.familyLinkId,
        category: permission.category,
        accessLevel: newValue,
      );

      // Call family service to update permission
      final familyService = ref.read(familyServiceProvider);
      await familyService.updatePermissions(
        familyLink.id,
        [updatedPermission],
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Permission ${permission.category} updated to $newValue'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh the permissions list
      ref.invalidate(permissionsProvider(familyLink.id));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update permission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
