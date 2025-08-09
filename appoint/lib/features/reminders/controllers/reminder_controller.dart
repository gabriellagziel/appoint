import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reminder_model.dart';

class ReminderController extends StateNotifier<List<Reminder>> {
  ReminderController() : super([]);

  // Load reminders (mock data for now)
  Future<void> loadReminders() async {
    // TODO: Load from Firebase
    await Future.delayed(const Duration(seconds: 1));

    final mockReminders = [
      Reminder(
        id: '1',
        title: 'Take medicine',
        description: 'Remember to take blood pressure medication',
        dueDate: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'user1',
        priority: ReminderPriority.high,
        tags: ['health', 'medicine'],
      ),
      Reminder(
        id: '2',
        title: 'Pick up groceries',
        description: 'Milk, bread, eggs, and vegetables',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        createdBy: 'user1',
        priority: ReminderPriority.medium,
        checklistItems: ['Milk', 'Bread', 'Eggs', 'Vegetables'],
        tags: ['shopping', 'groceries'],
      ),
      Reminder(
        id: '3',
        title: 'Call mom',
        description: 'Weekly check-in call',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        createdBy: 'user1',
        priority: ReminderPriority.low,
        recurrence: ReminderRecurrence.weekly,
        tags: ['family', 'call'],
      ),
    ];

    state = mockReminders;
  }

  // Create new reminder
  Future<bool> createReminder({
    required String title,
    String? description,
    required DateTime dueDate,
    required String createdBy,
    String? assignedTo,
    ReminderPriority priority = ReminderPriority.medium,
    ReminderRecurrence recurrence = ReminderRecurrence.none,
    int? customRecurrenceDays,
    List<String> checklistItems = const [],
    List<String> tags = const [],
    bool isFamilyReminder = false,
  }) async {
    try {
      final reminder = Reminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        dueDate: dueDate,
        createdAt: DateTime.now(),
        createdBy: createdBy,
        assignedTo: assignedTo,
        priority: priority,
        recurrence: recurrence,
        customRecurrenceDays: customRecurrenceDays,
        checklistItems: checklistItems,
        tags: tags,
        isFamilyReminder: isFamilyReminder,
      );

      // TODO: Save to Firebase
      await Future.delayed(const Duration(seconds: 1));

      state = [...state, reminder];
      return true;
    } catch (e) {
      print('Error creating reminder: $e');
      return false;
    }
  }

  // Mark reminder as complete
  Future<bool> markComplete(String reminderId) async {
    try {
      final updatedReminders = state.map((reminder) {
        if (reminder.id == reminderId) {
          return reminder.copyWith(status: ReminderStatus.completed);
        }
        return reminder;
      }).toList();

      // TODO: Update in Firebase
      await Future.delayed(const Duration(seconds: 1));

      state = updatedReminders;
      return true;
    } catch (e) {
      print('Error marking reminder complete: $e');
      return false;
    }
  }

  // Delete reminder
  Future<bool> deleteReminder(String reminderId) async {
    try {
      final updatedReminders =
          state.where((reminder) => reminder.id != reminderId).toList();

      // TODO: Delete from Firebase
      await Future.delayed(const Duration(seconds: 1));

      state = updatedReminders;
      return true;
    } catch (e) {
      print('Error deleting reminder: $e');
      return false;
    }
  }

  // Update reminder
  Future<bool> updateReminder(Reminder updatedReminder) async {
    try {
      final updatedReminders = state.map((reminder) {
        if (reminder.id == updatedReminder.id) {
          return updatedReminder;
        }
        return reminder;
      }).toList();

      // TODO: Update in Firebase
      await Future.delayed(const Duration(seconds: 1));

      state = updatedReminders;
      return true;
    } catch (e) {
      print('Error updating reminder: $e');
      return false;
    }
  }

  // Get reminders by status
  List<Reminder> getRemindersByStatus(ReminderStatus status) {
    return state.where((reminder) => reminder.status == status).toList();
  }

  // Get today's reminders
  List<Reminder> getTodayReminders() {
    return state
        .where((reminder) =>
            reminder.isToday && reminder.status == ReminderStatus.pending)
        .toList();
  }

  // Get overdue reminders
  List<Reminder> getOverdueReminders() {
    return state.where((reminder) => reminder.isOverdue).toList();
  }

  // Get upcoming reminders
  List<Reminder> getUpcomingReminders() {
    return state
        .where((reminder) =>
            reminder.isUpcoming && reminder.status == ReminderStatus.pending)
        .toList();
  }

  // Get reminders by assigned user
  List<Reminder> getRemindersByUser(String? userId) {
    return state.where((reminder) => reminder.assignedTo == userId).toList();
  }

  // Get family reminders
  List<Reminder> getFamilyReminders() {
    return state.where((reminder) => reminder.isFamilyReminder).toList();
  }
}

// Riverpod providers
final reminderControllerProvider =
    StateNotifierProvider<ReminderController, List<Reminder>>((ref) {
  return ReminderController();
});

final todayRemindersProvider = Provider<List<Reminder>>((ref) {
  final controller = ref.watch(reminderControllerProvider.notifier);
  return controller.getTodayReminders();
});

final overdueRemindersProvider = Provider<List<Reminder>>((ref) {
  final controller = ref.watch(reminderControllerProvider.notifier);
  return controller.getOverdueReminders();
});

final upcomingRemindersProvider = Provider<List<Reminder>>((ref) {
  final controller = ref.watch(reminderControllerProvider.notifier);
  return controller.getUpcomingReminders();
});






