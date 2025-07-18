import 'dart:async';
import 'package:appoint/services/broadcast_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to handle scheduled broadcast message processing
class BroadcastSchedulerService {
  static final BroadcastSchedulerService _instance = BroadcastSchedulerService._();
  static BroadcastSchedulerService get instance => _instance;
  
  BroadcastSchedulerService._();

  late final BroadcastService _broadcastService;
  Timer? _schedulerTimer;
  bool _isRunning = false;

  /// Initialize the scheduler with broadcast service
  void initialize(BroadcastService broadcastService) {
    _broadcastService = broadcastService;
  }

  /// Start the scheduler to process messages every minute
  void startScheduler({Duration interval = const Duration(minutes: 1)}) {
    if (_isRunning) return;
    
    _isRunning = true;
    final _schedulerTimer = Timer.periodic(interval, (_) async {
      await _processScheduledMessages();
    });
  }

  /// Stop the scheduler
  void stopScheduler() {
    _schedulerTimer?.cancel();
    _schedulerTimer = null;
    _isRunning = false;
  }

  /// Process scheduled messages that are ready to be sent
  Future<void> _processScheduledMessages() async {
    try {
      await _broadcastService.processScheduledMessages();
    } catch (e) {
      // Log error but don't crash the scheduler
      print('Error processing scheduled messages: $e');
    }
  }

  /// Check if scheduler is running
  bool get isRunning => _isRunning;

  /// Manually trigger scheduled message processing
  Future<void> processNow() async {
    await _processScheduledMessages();
  }

  /// Schedule a one-time message processing at a specific time
  void scheduleOneTime(DateTime scheduledTime, String messageId) {
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      // If the time has passed, process immediately
      _processScheduledMessages();
      return;
    }

    final delay = scheduledTime.difference(now);
    Timer(delay, () async {
      try {
        await _broadcastService.sendBroadcastMessage(messageId);
      } catch (e) {
        print('Error sending scheduled message $messageId: $e');
      }
    });
  }
}

/// Provider for the broadcast scheduler service
final broadcastSchedulerServiceProvider = Provider<BroadcastSchedulerService>(
  (ref) {
    final service = BroadcastSchedulerService.instance;
    final broadcastService = ref.read(adminBroadcastServiceProvider);
    service.initialize(broadcastService);
    return service;
  },
);