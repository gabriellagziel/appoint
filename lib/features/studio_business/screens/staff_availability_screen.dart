import 'package:appoint/providers/studio_business_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffAvailabilityScreen extends ConsumerWidget {
  const StaffAvailabilityScreen({super.key});
  static const routeName = '/studio/staff-availability';

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final avail = ref.watch(staffAvailabilityProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Availability'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAvailabilityDialog(context, ref),
            tooltip: 'Add Availability',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(staffAvailabilityProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: avail.when(
        data: (snap) {
          if (snap.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No availability slots configured',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add availability slots to start accepting bookings',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddAvailabilityDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Availability'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snap.docs.length,
            itemBuilder: (context, final index) {
              final doc = snap.docs[index];
              final data = doc.data();
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.schedule, color: Colors.white),
                  ),
                  title: Text(
                    data['profileId'] ?? 'Staff Member',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Slots: ${data['availableSlots'] ?? 'N/A'}',
                      ),
                      if (data['timeRange'] != null)
                        Text('Time: ${data['timeRange']}'),
                      if (data['daysOfWeek'] != null)
                        Text('Days: ${data['daysOfWeek']}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditAvailabilityDialog(context, ref, doc);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, ref, doc.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading availability: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(staffAvailabilityProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAvailabilityDialog(
    BuildContext context,
    final WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => const _AvailabilityDialog(),
    );
  }

  void _showEditAvailabilityDialog(
    final BuildContext context,
    WidgetRef ref,
    final DocumentSnapshot doc,
  ) {
    showDialog(
      context: context,
      builder: (context) => _AvailabilityDialog(editDoc: doc),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    final WidgetRef ref,
    final String docId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Availability'),
        content: const Text(
          'Are you sure you want to delete this availability slot?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO(username): Implement this featurent delete functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete functionality coming soon!'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityDialog extends StatefulWidget {
  const _AvailabilityDialog({this.editDoc});
  final DocumentSnapshot? editDoc;

  @override
  State<_AvailabilityDialog> createState() => _AvailabilityDialogState();
}

class _AvailabilityDialogState extends State<_AvailabilityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _profileController = TextEditingController();
  final _slotsController = TextEditingController();
  final _timeRangeController = TextEditingController();
  final _daysController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editDoc != null) {
      final data = widget.editDoc!.data()! as Map<String, dynamic>;
      _profileController.text = data['profileId'] ?? '';
      _slotsController.text = data['availableSlots']?.toString() ?? '';
      _timeRangeController.text = data['timeRange'] ?? '';
      _daysController.text = data['daysOfWeek'] ?? '';
    }
  }

  @override
  void dispose() {
    _profileController.dispose();
    _slotsController.dispose();
    _timeRangeController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          widget.editDoc != null ? 'Edit Availability' : 'Add Availability',
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _profileController,
                decoration: const InputDecoration(
                  labelText: 'Staff Member/Profile ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a staff member or profile ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _slotsController,
                decoration: const InputDecoration(
                  labelText: 'Available Slots',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 10',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter available slots';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeRangeController,
                decoration: const InputDecoration(
                  labelText: 'Time Range',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 9:00 AM - 5:00 PM',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _daysController,
                decoration: const InputDecoration(
                  labelText: 'Days of Week',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Monday, Tuesday, Wednesday',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO(username): Implement this featurent save functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.editDoc != null
                          ? 'Edit functionality coming soon!'
                          : 'Add functionality coming soon!',
                    ),
                  ),
                );
              }
            },
            child: Text(widget.editDoc != null ? 'Update' : 'Add'),
          ),
        ],
      );
}
