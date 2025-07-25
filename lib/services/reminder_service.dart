import 'dart:async';
import 'dart:io';

import 'package:appoint/models/reminder.dart';
import 'package:appoint/models/reminder_analytics.dart';
import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  ReminderService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    BusinessSubscriptionService? subscriptionService,
    NotificationService? notificationService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _subscriptionService = subscriptionService ?? BusinessSubscriptionService(),
        _notificationService = notificationService ?? NotificationService();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final BusinessSubscriptionService _subscriptionService;
  final NotificationService _notificationService;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Collection references
  CollectionReference get _remindersCollection => _firestore.collection('reminders');
  CollectionReference get _analyticsCollection => _firestore.collection('reminder_analytics');
  CollectionReference get _statsCollection => _firestore.collection('reminder_stats');

  User? get _currentUser => _auth.currentUser;

  /// Initialize the reminder service
  Future<void> initialize() async {
    await _notificationService.initialize();
    await _setupLocalNotifications();
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      // Handle notification tap - mark reminder as triggered
      await _trackAnalyticsEvent(
        reminderId: payload,
        eventType: ReminderAnalyticsEvent.notificationOpened,
        eventData: {'notificationId': response.id},
      );
    }
  }

  /// Create a new reminder with business plan enforcement
  Future<Reminder> createReminder({
    required String title,
    String? description,
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
    if (_currentUser == null) {
      throw Exception('User must be authenticated to create reminders');
    }

    // Enforce business plan restrictions for location-based reminders
    if (type.requiresMapAccess) {
      final canUseMap = await _subscriptionService.canLoadMap();
      if (!canUseMap) {
        await _trackAnalyticsEvent(
          reminderId: 'pending',
          eventType: ReminderAnalyticsEvent.mapAccessDenied,
          eventData: {
            'reminderType': type.name,
            'userPlan': await _getCurrentUserPlan(),
          },
        );
        throw ReminderLocationAccessDeniedException(
          'Location-based reminders require a Professional plan or higher. Upgrade to unlock map-based reminders.',
        );
      }
      
      // Record map usage
      await _subscriptionService.recordMapUsage();
    }

    // Validate location data if provided
    if (location != null && type == ReminderType.locationBased) {
      await _validateLocationPermissions();
    }

    final now = DateTime.now();
    final reminderId = _remindersCollection.doc().id;

    final reminder = Reminder(
      id: reminderId,
      userId: _currentUser!.uid,
      title: title,
      description: description,
      type: type,
      status: ReminderStatus.active,
      createdAt: now,
      updatedAt: now,
      triggerTime: triggerTime,
      location: location,
      meetingId: meetingId,
      eventId: eventId,
      priority: priority,
      recurrence: recurrence,
      tags: tags,
      isCompleted: false,
      notificationsEnabled: notificationsEnabled,
      notificationMethods: notificationMethods ?? [ReminderNotificationMethod.local],
      snoozeCount: 0,
    );

    // Save to Firestore
    await _remindersCollection.doc(reminderId).set(reminder.toJson());

    // Schedule notifications
    if (notificationsEnabled) {
      await _scheduleNotifications(reminder);
    }

    // Set up geofencing for location-based reminders
    if (type == ReminderType.locationBased && location != null) {
      await _setupGeofencing(reminder);
    }

    // Track analytics
    await _trackAnalyticsEvent(
      reminderId: reminderId,
      eventType: ReminderAnalyticsEvent.reminderCreated,
      eventData: {
        'reminderType': type.name,
        'hasTriggerTime': triggerTime != null,
        'hasLocation': location != null,
        'priority': priority?.name,
        'userPlan': await _getCurrentUserPlan(),
      },
    );

    return reminder;
  }

  /// Get user's reminders with filtering and sorting
  Stream<List<Reminder>> getUserReminders({
    ReminderStatus? status,
    ReminderType? type,
    bool activeOnly = false,
    int? limit,
  }) {
    if (_currentUser == null) {
      return Stream.value([]);
    }

    Query query = _remindersCollection.where('userId', isEqualTo: _currentUser!.uid);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    if (activeOnly) {
      query = query.where('status', whereIn: [
        ReminderStatus.active.name,
        ReminderStatus.snoozed.name,
      ]);
    }

    query = query.orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Reminder.fromFirestore(doc)).toList());
  }

  /// Update a reminder
  Future<void> updateReminder(String reminderId, Map<String, dynamic> updates) async {
    if (_currentUser == null) return;

    updates['updatedAt'] = DateTime.now().toIso8601String();
    await _remindersCollection.doc(reminderId).update(updates);
  }

  /// Complete a reminder
  Future<void> completeReminder(String reminderId) async {
    final now = DateTime.now();
    await updateReminder(reminderId, {
      'status': ReminderStatus.completed.name,
      'isCompleted': true,
      'completedAt': now.toIso8601String(),
    });

    await _trackAnalyticsEvent(
      reminderId: reminderId,
      eventType: ReminderAnalyticsEvent.reminderCompleted,
      eventData: {'completedAt': now.toIso8601String()},
    );

    // Cancel scheduled notifications
    await _cancelNotifications(reminderId);
  }

  /// Snooze a reminder
  Future<void> snoozeReminder(String reminderId, Duration snoozeDuration) async {
    final snoozeUntil = DateTime.now().add(snoozeDuration);
    
    // Get current reminder to increment snooze count
    final reminderDoc = await _remindersCollection.doc(reminderId).get();
    if (!reminderDoc.exists) return;
    
    final currentSnoozeCount = (reminderDoc.data() as Map<String, dynamic>)['snoozeCount'] ?? 0;

    await updateReminder(reminderId, {
      'status': ReminderStatus.snoozed.name,
      'snoozedUntil': snoozeUntil.toIso8601String(),
      'snoozeCount': currentSnoozeCount + 1,
    });

    await _trackAnalyticsEvent(
      reminderId: reminderId,
      eventType: ReminderAnalyticsEvent.reminderSnoozed,
      eventData: {
        'snoozeDuration': snoozeDuration.inMinutes,
        'snoozeCount': currentSnoozeCount + 1,
      },
    );

    // Reschedule notification
    final reminder = Reminder.fromFirestore(reminderDoc);
    await _rescheduleNotification(reminder, snoozeUntil);
  }

  /// Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    await _remindersCollection.doc(reminderId).delete();
    await _cancelNotifications(reminderId);

    await _trackAnalyticsEvent(
      reminderId: reminderId,
      eventType: ReminderAnalyticsEvent.reminderDeleted,
    );
  }

  /// Check if user can create location-based reminders
  Future<bool> canCreateLocationReminders() async {
    return await _subscriptionService.canLoadMap();
  }

  /// Get user's subscription plan for reminder restrictions
  Future<String> _getCurrentUserPlan() async {
    final subscription = await _subscriptionService.getCurrentSubscription();
    return subscription?.plan.name ?? 'free';
  }

  /// Validate location permissions
  Future<void> _validateLocationPermissions() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      final result = await Permission.location.request();
      if (!result.isGranted) {
        throw Exception('Location permission is required for location-based reminders');
      }
    }
  }

  /// Schedule notifications for a reminder
  Future<void> _scheduleNotifications(Reminder reminder) async {
    if (!reminder.notificationsEnabled || reminder.triggerTime == null) return;

    final notificationId = reminder.id.hashCode;
    final triggerTime = reminder.triggerTime!;

    // Schedule local notification
    if (reminder.notificationMethods?.contains(ReminderNotificationMethod.local) ?? false) {
      await _localNotifications.zonedSchedule(
        notificationId,
        reminder.title,
        reminder.description,
        tz.TZDateTime.from(triggerTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders_channel',
            'Reminders',
            channelDescription: 'Notifications for reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: reminder.id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    // Track notification scheduled
    await _trackAnalyticsEvent(
      reminderId: reminder.id,
      eventType: ReminderAnalyticsEvent.notificationDelivered,
      eventData: {'scheduledFor': triggerTime.toIso8601String()},
    );
  }

  /// Cancel notifications for a reminder
  Future<void> _cancelNotifications(String reminderId) async {
    final notificationId = reminderId.hashCode;
    await _localNotifications.cancel(notificationId);
  }

  /// Reschedule notification after snooze
  Future<void> _rescheduleNotification(Reminder reminder, DateTime newTime) async {
    await _cancelNotifications(reminder.id);
    
    final updatedReminder = reminder.copyWith(triggerTime: newTime);
    await _scheduleNotifications(updatedReminder);
  }

  /// Setup geofencing for location-based reminders
  Future<void> _setupGeofencing(Reminder reminder) async {
    if (reminder.location == null) return;

    // This would integrate with a geofencing service
    // For now, we'll track that geofencing was set up
    await _trackAnalyticsEvent(
      reminderId: reminder.id,
      eventType: ReminderAnalyticsEvent.locationReminderGeofenceEntered,
      eventData: {
        'latitude': reminder.location!.latitude,
        'longitude': reminder.location!.longitude,
        'radius': reminder.location!.radius ?? 100,
      },
    );
  }

  /// Track analytics events
  Future<void> _trackAnalyticsEvent({
    required String reminderId,
    required ReminderAnalyticsEvent eventType,
    Map<String, dynamic>? eventData,
  }) async {
    if (_currentUser == null) return;

    final analytics = ReminderAnalytics(
      id: _analyticsCollection.doc().id,
      userId: _currentUser!.uid,
      reminderId: reminderId,
      eventType: eventType,
      timestamp: DateTime.now(),
      eventData: eventData,
      deviceInfo: Platform.operatingSystem,
    );

    await _analyticsCollection.add(analytics.toJson());
  }

  /// Get user's reminder statistics
  Future<ReminderStats?> getUserStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_currentUser == null) return null;

    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = endDate ?? DateTime.now();

    final statsDoc = await _statsCollection
        .where('userId', isEqualTo: _currentUser!.uid)
        .where('periodStart', isEqualTo: start.toIso8601String())
        .where('periodEnd', isEqualTo: end.toIso8601String())
        .limit(1)
        .get();

    if (statsDoc.docs.isNotEmpty) {
      return ReminderStats.fromJson(statsDoc.docs.first.data() as Map<String, dynamic>);
    }

    // Generate stats if not cached
    return await _generateUserStats(start, end);
  }

  /// Generate user statistics
  Future<ReminderStats> _generateUserStats(DateTime startDate, DateTime endDate) async {
    if (_currentUser == null) {
      throw Exception('User must be authenticated');
    }

    final remindersQuery = await _remindersCollection
        .where('userId', isEqualTo: _currentUser!.uid)
        .where('createdAt', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('createdAt', isLessThanOrEqualTo: endDate.toIso8601String())
        .get();

    final reminders = remindersQuery.docs
        .map((doc) => Reminder.fromFirestore(doc))
        .toList();

    final totalReminders = reminders.length;
    final completedReminders = reminders.where((r) => r.isCompleted).length;
    final snoozedReminders = reminders.where((r) => r.status == ReminderStatus.snoozed).length;
    final locationBasedReminders = reminders.where((r) => r.type == ReminderType.locationBased).length;
    final timeBasedReminders = reminders.where((r) => r.type == ReminderType.timeBased).length;
    final meetingRelatedReminders = reminders.where((r) => r.type == ReminderType.meetingRelated).length;

    final completionRate = totalReminders > 0 ? completedReminders / totalReminders : 0.0;

    // Calculate average completion time
    final completedWithTime = reminders.where((r) => r.isCompleted && r.completedAt != null);
    Duration averageCompletionTime = Duration.zero;
    if (completedWithTime.isNotEmpty) {
      final totalTime = completedWithTime.fold<Duration>(
        Duration.zero,
        (total, reminder) => total + reminder.completedAt!.difference(reminder.createdAt),
      );
      averageCompletionTime = Duration(
        milliseconds: totalTime.inMilliseconds ~/ completedWithTime.length,
      );
    }

    final stats = ReminderStats(
      userId: _currentUser!.uid,
      periodStart: startDate,
      periodEnd: endDate,
      totalReminders: totalReminders,
      completedReminders: completedReminders,
      missedReminders: totalReminders - completedReminders - snoozedReminders,
      snoozedReminders: snoozedReminders,
      locationBasedReminders: locationBasedReminders,
      timeBasedReminders: timeBasedReminders,
      meetingRelatedReminders: meetingRelatedReminders,
      completionRate: completionRate,
      averageCompletionTime: averageCompletionTime,
      remindersByPriority: _groupRemindersByPriority(reminders),
      remindersByType: _groupRemindersByType(reminders),
      remindersByStatus: _groupRemindersByStatus(reminders),
    );

    // Cache the stats
    await _statsCollection.add(stats.toJson());

    return stats;
  }

  Map<String, int> _groupRemindersByPriority(List<Reminder> reminders) {
    final Map<String, int> grouped = {};
    for (final reminder in reminders) {
      final priority = reminder.priority?.name ?? 'medium';
      grouped[priority] = (grouped[priority] ?? 0) + 1;
    }
    return grouped;
  }

  Map<String, int> _groupRemindersByType(List<Reminder> reminders) {
    final Map<String, int> grouped = {};
    for (final reminder in reminders) {
      final type = reminder.type.name;
      grouped[type] = (grouped[type] ?? 0) + 1;
    }
    return grouped;
  }

  Map<String, int> _groupRemindersByStatus(List<Reminder> reminders) {
    final Map<String, int> grouped = {};
    for (final reminder in reminders) {
      final status = reminder.status.name;
      grouped[status] = (grouped[status] ?? 0) + 1;
    }
    return grouped;
  }
}

/// Exception thrown when user tries to access location-based features without proper subscription
class ReminderLocationAccessDeniedException implements Exception {
  const ReminderLocationAccessDeniedException(this.message);
  final String message;

  @override
  String toString() => 'ReminderLocationAccessDeniedException: $message';
}