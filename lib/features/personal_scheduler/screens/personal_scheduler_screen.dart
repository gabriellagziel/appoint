import 'package:appoint/models/personal_appointment.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/personal_scheduler_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class PersonalSchedulerScreen extends ConsumerStatefulWidget {
  const PersonalSchedulerScreen({super.key});

  @override
  ConsumerState<PersonalSchedulerScreen> createState() =>
      _PersonalSchedulerScreenState();
}

class _PersonalSchedulerScreenState
    extends ConsumerState<PersonalSchedulerScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final apptsAsync = ref.watch(personalAppointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Schedule')),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: _focusedDay,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (d) => setState(() => _focusedDay = d),
          ),
          Expanded(
            child: apptsAsync.when(
              data: (appts) {
                final dayAppts = appts
                    .where((a) =>
                        a.startTime.year == _focusedDay.year &&
                        a.startTime.month == _focusedDay.month &&
                        a.startTime.day == _focusedDay.day,)
                    .toList();
                if (dayAppts.isEmpty) {
                  return const Center(child: Text('No appointments'));
                }
                return ListView(
                  children: dayAppts
                      .map(
                        (a) => ListTile(
                          title: Text(a.title),
                          subtitle: Text(
                              '${a.startTime.hour.toString().padLeft(2, '0')}:${a.startTime.minute.toString().padLeft(2, '0')} - '
                              '${a.endTime.hour.toString().padLeft(2, '0')}:${a.endTime.minute.toString().padLeft(2, '0')}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(a.id),
                          ),
                          onTap: () => _edit(a),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, final _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _add() async {
    final newAppt = await _showEditDialog();
    if (newAppt != null) {
      await ref.read(REDACTED_TOKEN).addAppointment(newAppt);
    }
  }

  Future<void> _edit(PersonalAppointment appt) async {
    final updated = await _showEditDialog(existing: appt);
    if (updated != null) {
      await ref
          .read(REDACTED_TOKEN)
          .updateAppointment(updated);
    }
  }

  Future<void> _delete(String id) async {
    await ref.read(REDACTED_TOKEN).deleteAppointment(id);
  }

  Future<PersonalAppointment?> _showEditDialog(
      {PersonalAppointment? existing,}) {
    final titleCtrl = TextEditingController(text: existing?.title);
    final descCtrl = TextEditingController(text: existing?.description);
    var start = existing?.startTime ?? _focusedDay;
    var end =
        existing?.endTime ?? _focusedDay.add(const Duration(hours: 1));

    return showDialog<PersonalAppointment>(
      context: context,
      builder: (context) => AlertDialog(
          title:
              Text(existing == null ? 'New Appointment' : 'Edit Appointment'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: start,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (d != null) {
                            setState(() {
                              start = DateTime(d.year, d.month, d.day,
                                  start.hour, start.minute,);
                              end = start.add(const Duration(hours: 1));
                            });
                          }
                        },
                        child: Text(
                            'Date: ${start.year}-${start.month}-${start.day}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(start),
                          );
                          if (t != null) {
                            setState(() {
                              start = DateTime(start.year, start.month,
                                  start.day, t.hour, t.minute,);
                              end = start.add(const Duration(hours: 1));
                            });
                          }
                        },
                        child: Text(
                            'Start: ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String id = existing?.id ?? const Uuid().v4();
                final userId =
                    existing?.userId ?? ref.read(authProvider).currentUser!.uid;
                final appt = PersonalAppointment(
                  id: id,
                  userId: userId,
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  startTime: start,
                  endTime: end,
                );
                Navigator.pop(context, appt);
              },
              child: const Text('Save'),
            ),
          ],
        ),
    );
  }
}
