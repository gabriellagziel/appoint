// ignore_for_file: use_build_context_synchronously
import 'package:appoint/models/studio_appointment.dart';
import 'package:appoint/providers/studio_appointments_provider.dart';
import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/widgets/app_scaffold.dart';
import 'package:appoint/widgets/empty_state.dart';
import 'package:appoint/widgets/error_state.dart';
import 'package:appoint/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  Future<void> _openEditor(
    final BuildContext context,
    final WidgetRef ref, {
    StudioAppointment? appt,
  }) async {
    final titleController = TextEditingController(text: appt?.title ?? '');
    final clientController = TextEditingController(text: appt?.client ?? '');
    final notesController = TextEditingController(text: appt?.notes ?? '');
    DateTime? time = appt?.time ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appt == null ? 'New Appointment' : 'Edit Appointment'),
        content: StatefulBuilder(
          builder: (context, final setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: clientController,
                  decoration: const InputDecoration(labelText: 'Client'),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      time == null
                          ? 'No time'
                          : '${time?.toLocal()}'.split('.').first,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: time ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              time ?? DateTime.now(),
                            ),
                          );
                          if (t != null) {
                            setState(() {
                              time = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                t.hour,
                                t.minute,
                              );
                            });
                          }
                        }
                      },
                      child: const Text('Pick Time'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAppt = StudioAppointment(
                id: appt?.id ?? '',
                title: titleController.text,
                time: time ?? DateTime.now(),
                client: clientController.text,
                notes: notesController.text,
              );
              if (appt == null) {
                ref.read(studioAppointmentsProvider.notifier).add(newAppt);
              } else {
                ref.read(studioAppointmentsProvider.notifier).update(newAppt);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final apptsAsync = ref.watch(studioAppointmentsProvider);
    return AppScaffold(
      title: 'Appointments',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, ref),
        child: const Icon(Icons.add, semanticLabel: 'add appointment'),
      ),
      body: apptsAsync.when(
        data: (appts) {
          if (appts.isEmpty) {
            return const EmptyState(
              title: 'No Appointments',
              description: 'Create your first appointment',
              icon: Icons.event_busy,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: appts.length,
            itemBuilder: (context, final index) {
              final appt = appts[index];
              return ListTile(
                title: Text(appt.title),
                subtitle: Text(
                  '${appt.client} – '
                          '${appt.time.toLocal()}'
                      .split('.')
                      .first,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, semanticLabel: 'edit'),
                      onPressed: () => _openEditor(context, ref, appt: appt),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, semanticLabel: 'delete'),
                      onPressed: () => ref
                          .read(studioAppointmentsProvider.notifier)
                          .delete(appt.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const LoadingState(),
        error: (e, final _) => ErrorState(
          title: 'Error',
          description: 'Error: $e',
        ),
      ),
    );
  }
}
