import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../reminders/services/reminder_service.dart';
import '../../services/auth/auth_providers.dart';

enum Recurrence { none, daily, weekly }

class ReminderFormState {
  final String text;
  final DateTime? when;
  final Recurrence recurrence;
  final String notes;
  final bool notify;
  final List<String> targets;

  const ReminderFormState({
    this.text = '',
    this.when,
    this.recurrence = Recurrence.none,
    this.notes = '',
    this.notify = true,
    this.targets = const [],
  });

  ReminderFormState copyWith({
    String? text,
    DateTime? when,
    Recurrence? recurrence,
    String? notes,
    bool? notify,
    List<String>? targets,
  }) => ReminderFormState(
        text: text ?? this.text,
        when: when ?? this.when,
        recurrence: recurrence ?? this.recurrence,
        notes: notes ?? this.notes,
        notify: notify ?? this.notify,
        targets: targets ?? this.targets,
      );
}

class ReminderFormNotifier extends StateNotifier<ReminderFormState> {
  final ReminderService service;
  final Ref ref;
  ReminderFormNotifier(this.ref, this.service) : super(const ReminderFormState());

  void setText(String v) => state = state.copyWith(text: v);
  void setWhen(DateTime v) => state = state.copyWith(when: v);
  void setRecurrence(Recurrence r) => state = state.copyWith(recurrence: r);
  void setNotes(String v) => state = state.copyWith(notes: v);
  void setNotify(bool v) => state = state.copyWith(notify: v);

  Future<bool> save() async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return false;
    final targets = state.targets.isEmpty ? [uid] : state.targets;
    return service.createReminder({
      'text': state.text.trim(),
      'when': state.when?.toUtc(),
      'recurrence': state.recurrence.name,
      'notes': state.notes.trim(),
      'notify': state.notify,
      'ownerUid': uid,
      'targets': targets,
      'createdAt': DateTime.now().toUtc(),
      'done': false,
    });
  }
}

final reminderServiceProvider = Provider<ReminderService>((ref) => ReminderService());

final reminderFormProvider =
    StateNotifierProvider<ReminderFormNotifier, ReminderFormState>((ref) {
  final svc = ref.watch(reminderServiceProvider);
  return ReminderFormNotifier(ref, svc);
});

final remindersStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  final svc = ref.watch(reminderServiceProvider);
  if (uid == null) return const Stream.empty();
  if (Firebase.apps.isEmpty) return const Stream.empty();
  return svc.streamRemindersForUser(uid);
});


