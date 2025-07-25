import 'package:appoint/models/reminder.dart';
import 'package:appoint/models/reminder_analytics.dart';
import 'package:appoint/services/reminder_service.dart';
import 'package:appoint/features/studio_business/providers/business_subscription_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core service provider
final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService();
});

// User's reminders stream
final userRemindersProvider = StreamProvider.family<List<Reminder>, ReminderQueryParams>(
  (ref, params) {
    final service = ref.watch(reminderServiceProvider);
    return service.getUserReminders(
      status: params.status,
      type: params.type,
      activeOnly: params.activeOnly,
      limit: params.limit,
    );
  },
);

// Active reminders only (most commonly used)
final activeRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  final service = ref.watch(reminderServiceProvider);
  return service.getUserReminders(activeOnly: true);
});

// Reminders by type
final remindersByTypeProvider = StreamProvider.family<List<Reminder>, ReminderType>(
  (ref, type) {
    final service = ref.watch(reminderServiceProvider);
    return service.getUserReminders(type: type, activeOnly: true);
  },
);

// Time-based reminders
final timeBasedRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersByTypeProvider(ReminderType.timeBased));
});

// Location-based reminders (with subscription check)
final locationBasedRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersByTypeProvider(ReminderType.locationBased));
});

// Meeting-related reminders
final meetingRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersByTypeProvider(ReminderType.meetingRelated));
});

// Feature access providers with subscription enforcement
final REDACTED_TOKEN = FutureProvider<bool>((ref) async {
  final service = ref.watch(reminderServiceProvider);
  return await service.canCreateLocationReminders();
});

final REDACTED_TOKEN = FutureProvider<ReminderAccessStatus>((ref) async {
  final canCreate = await ref.watch(REDACTED_TOKEN.future);
  final mapAccess = await ref.watch(mapAccessProvider.future);
  final currentPlan = ref.watch(currentPlanProvider);
  
  return ReminderAccessStatus(
    canCreateLocationReminders: canCreate,
    hasMapAccess: mapAccess,
    currentPlan: currentPlan?.name ?? 'free',
    needsUpgrade: !canCreate,
  );
});

// User statistics
final userReminderStatsProvider = FutureProvider.family<ReminderStats?, ReminderStatsParams>(
  (ref, params) async {
    final service = ref.watch(reminderServiceProvider);
    return await service.getUserStats(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  },
);

final weeklyReminderStatsProvider = FutureProvider<ReminderStats?>((ref) {
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final weekEnd = weekStart.add(const Duration(days: 6));
  
  return ref.watch(userReminderStatsProvider(ReminderStatsParams(
    startDate: weekStart,
    endDate: weekEnd,
  )).future);
});

final monthlyReminderStatsProvider = FutureProvider<ReminderStats?>((ref) {
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);
  final monthEnd = DateTime(now.year, now.month + 1, 0);
  
  return ref.watch(userReminderStatsProvider(ReminderStatsParams(
    startDate: monthStart,
    endDate: monthEnd,
  )).future);
});

// Reminder creation state notifier
final REDACTED_TOKEN = StateNotifierProvider<ReminderCreationNotifier, ReminderCreationState>(
  (ref) => ReminderCreationNotifier(ref.watch(reminderServiceProvider)),
);

class ReminderCreationNotifier extends StateNotifier<ReminderCreationState> {
  ReminderCreationNotifier(this._service) : super(const ReminderCreationState.initial());

  final ReminderService _service;

  Future<void> createReminder({
    required String title,
    required String description,
    required ReminderType type,
    DateTime? triggerTime,
    ReminderLocation? location,
    String? meetingId,
    String? eventId,
    ReminderPriority priority = ReminderPriority.medium,
    ReminderRecurrence? recurrence,
    List<String>? tags,
    bool notificationsEnabled = true,
    List<ReminderNotificationMethod>? notificationMethods,
  }) async {
    state = const ReminderCreationState.loading();
    
    try {
      final reminder = await _service.createReminder(
        title: title,
        description: description,
        type: type,
        triggerTime: triggerTime,
        location: location,
        meetingId: meetingId,
        eventId: eventId,
        priority: priority,
        recurrence: recurrence,
        tags: tags,
        notificationsEnabled: notificationsEnabled,
        notificationMethods: notificationMethods,
      );
      
      state = ReminderCreationState.success(reminder);
    } catch (e) {
      if (e is REDACTED_TOKEN) {
        state = ReminderCreationState.accessDenied(e.message);
      } else {
        state = ReminderCreationState.error(e.toString());
      }
    }
  }

  void reset() {
    state = const ReminderCreationState.initial();
  }
}

// Reminder action notifiers
final reminderActionNotifierProvider = StateNotifierProvider<ReminderActionNotifier, AsyncValue<void>>(
  (ref) => ReminderActionNotifier(ref.watch(reminderServiceProvider)),
);

class ReminderActionNotifier extends StateNotifier<AsyncValue<void>> {
  ReminderActionNotifier(this._service) : super(const AsyncValue.data(null));

  final ReminderService _service;

  Future<void> completeReminder(String reminderId) async {
    state = const AsyncValue.loading();
    try {
      await _service.completeReminder(reminderId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> snoozeReminder(String reminderId, Duration duration) async {
    state = const AsyncValue.loading();
    try {
      await _service.snoozeReminder(reminderId, duration);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteReminder(reminderId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Helper classes for provider parameters
class ReminderQueryParams {
  const ReminderQueryParams({
    this.status,
    this.type,
    this.activeOnly = false,
    this.limit,
  });

  final ReminderStatus? status;
  final ReminderType? type;
  final bool activeOnly;
  final int? limit;
}

class ReminderStatsParams {
  const ReminderStatsParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}

class ReminderAccessStatus {
  const ReminderAccessStatus({
    required this.canCreateLocationReminders,
    required this.hasMapAccess,
    required this.currentPlan,
    required this.needsUpgrade,
  });

  final bool canCreateLocationReminders;
  final bool hasMapAccess;
  final String currentPlan;
  final bool needsUpgrade;
}

// Reminder creation state
abstract class ReminderCreationState {
  const ReminderCreationState();

  const factory ReminderCreationState.initial() = _Initial;
  const factory ReminderCreationState.loading() = _Loading;
  const factory ReminderCreationState.success(Reminder reminder) = _Success;
  const factory ReminderCreationState.error(String message) = _Error;
  const factory ReminderCreationState.accessDenied(String message) = _AccessDenied;
}

class _Initial extends ReminderCreationState {
  const _Initial();
}

class _Loading extends ReminderCreationState {
  const _Loading();
}

class _Success extends ReminderCreationState {
  const _Success(this.reminder);
  final Reminder reminder;
}

class _Error extends ReminderCreationState {
  const _Error(this.message);
  final String message;
}

class _AccessDenied extends ReminderCreationState {
  const _AccessDenied(this.message);
  final String message;
}

// Extensions for convenience
extension ReminderCreationStateExtension on ReminderCreationState {
  bool get isInitial => this is _Initial;
  bool get isLoading => this is _Loading;
  bool get isSuccess => this is _Success;
  bool get isError => this is _Error;
  bool get isAccessDenied => this is _AccessDenied;

  Reminder? get reminder => this is _Success ? (this as _Success).reminder : null;
  String? get errorMessage => this is _Error ? (this as _Error).message : null;
  String? get accessDeniedMessage => this is _AccessDenied ? (this as _AccessDenied).message : null;
}

// Computed providers for UI convenience
final overdueRemindersProvider = Provider<AsyncValue<List<Reminder>>>((ref) {
  return ref.watch(activeRemindersProvider).whenData((reminders) {
    final now = DateTime.now();
    return reminders.where((reminder) {
      if (reminder.triggerTime == null) return false;
      return reminder.triggerTime!.isBefore(now) && 
             reminder.status == ReminderStatus.active;
    }).toList();
  });
});

final todayRemindersProvider = Provider<AsyncValue<List<Reminder>>>((ref) {
  return ref.watch(activeRemindersProvider).whenData((reminders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return reminders.where((reminder) {
      if (reminder.triggerTime == null) return false;
      return reminder.triggerTime!.isAfter(today) && 
             reminder.triggerTime!.isBefore(tomorrow);
    }).toList();
  });
});

final upcomingRemindersProvider = Provider<AsyncValue<List<Reminder>>>((ref) {
  return ref.watch(activeRemindersProvider).whenData((reminders) {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return reminders.where((reminder) {
      if (reminder.triggerTime == null) return false;
      return reminder.triggerTime!.isAfter(now) && 
             reminder.triggerTime!.isBefore(nextWeek);
    }).toList()
      ..sort((a, b) => a.triggerTime!.compareTo(b.triggerTime!));
  });
});