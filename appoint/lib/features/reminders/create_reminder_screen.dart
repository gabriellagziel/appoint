import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class CreateReminderScreen extends ConsumerWidget {
  const CreateReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(reminderFormProvider);
    final notifier = ref.read(reminderFormProvider.notifier);
    final textCtrl = TextEditingController(text: form.text);
    final notesCtrl = TextEditingController(text: form.notes);

    Future<void> pickDateTime() async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        firstDate: now.subtract(const Duration(days: 1)),
        lastDate: now.add(const Duration(days: 365)),
        initialDate: form.when ?? now,
      );
      if (date == null) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            form.when ?? now.add(const Duration(hours: 1))),
      );
      if (time == null) return;
      final dt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      notifier.setWhen(dt);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textCtrl,
              decoration: const InputDecoration(labelText: 'Reminder text'),
              onChanged: notifier.setText,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child:
                    Text(form.when?.toLocal().toString() ?? 'No time selected'),
              ),
              TextButton(
                  onPressed: pickDateTime, child: const Text('Pick time')),
            ]),
            const SizedBox(height: 12),
            DropdownButton<Recurrence>(
              value: form.recurrence,
              onChanged: (r) => notifier.setRecurrence(r ?? Recurrence.none),
              items: Recurrence.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              onChanged: notifier.setNotes,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Notifications are in-app only (no SMS).',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final ok = await notifier.save();
                  if (!context.mounted) return;
                  if (ok) {
                    Navigator.of(context).pop(true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Failed to save reminder')));
                  }
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
