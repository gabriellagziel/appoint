import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/user_profile.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/services/broadcast_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for admin broadcast service
final adminBroadcastServiceProvider = Provider<BroadcastService>((ref) => BroadcastService());

/// Provider for sending broadcast messages
final sendBroadcastMessageProvider = FutureProvider.family<void, AdminBroadcastMessage>((ref, message) async {
  final service = ref.read(adminBroadcastServiceProvider);
  await service.createBroadcastMessage(message);
});

/// Provider for getting messages for the current user
final userBroadcastMessagesProvider = FutureProvider<List<AdminBroadcastMessage>>((ref) async {
  final service = ref.read(adminBroadcastServiceProvider);
  final userProfile = await ref.read(userProfileProvider.future);
  
  if (userProfile == null) {
    throw Exception('User profile not found');
  }
  
  return service.getMessagesForUser(userProfile);
});

/// Provider for getting all broadcast messages (admin only)
final allBroadcastMessagesProvider = FutureProvider<List<AdminBroadcastMessage>>((ref) async {
  final service = ref.read(adminBroadcastServiceProvider);
  return service.getBroadcastMessages().first;
});

/// Provider for estimating target audience
final estimateTargetAudienceProvider = FutureProvider.family<int, BroadcastTargetingFilters>((ref, filters) async {
  final service = ref.read(adminBroadcastServiceProvider);
  return service.estimateTargetAudience(filters);
});

/// Provider for sending a specific broadcast message
final sendSpecificBroadcastMessageProvider = FutureProvider.family<void, String>((ref, messageId) async {
  final service = ref.read(adminBroadcastServiceProvider);
  await service.sendBroadcastMessage(messageId);
});

/// Provider for deleting a broadcast message
final deleteBroadcastMessageProvider = FutureProvider.family<void, String>((ref, messageId) async {
  final service = ref.read(adminBroadcastServiceProvider);
  await service.deleteBroadcastMessage(messageId);
});

/// Provider for updating message analytics
final updateMessageAnalyticsProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(adminBroadcastServiceProvider);
  final messageId = params['messageId'] as String;
  final openedCount = params['openedCount'] as int?;
  final clickedCount = params['clickedCount'] as int?;
  final pollResponses = params['pollResponses'] as Map<String, int>?;
  
  await service.updateMessageAnalytics(
    messageId,
    openedCount: openedCount,
    clickedCount: clickedCount,
    pollResponses: pollResponses,
  );
});

/// Provider for getting detailed message analytics
final messageAnalyticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, messageId) async {
  final service = ref.read(adminBroadcastServiceProvider);
  return service.getMessageAnalytics(messageId);
});

/// Provider for getting analytics summary
final analyticsSummaryProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(adminBroadcastServiceProvider);
  final startDate = params['startDate'] as DateTime?;
  final endDate = params['endDate'] as DateTime?;
  final limit = params['limit'] as int?;
  
  return service.getAnalyticsSummary(
    startDate: startDate,
    endDate: endDate,
    limit: limit,
  );
});

/// Provider for exporting analytics as CSV
final exportAnalyticsCSVProvider = FutureProvider.family<String, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(adminBroadcastServiceProvider);
  final startDate = params['startDate'] as DateTime?;
  final endDate = params['endDate'] as DateTime?;
  
  return service.exportAnalyticsCSV(
    startDate: startDate,
    endDate: endDate,
  );
});

/// Provider for real-time message analytics stream
final messageAnalyticsStreamProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, messageId) {
  final service = ref.read(adminBroadcastServiceProvider);
  return service.getMessageAnalyticsStream(messageId);
});

/// Provider for tracking message interactions
final trackMessageInteractionProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(adminBroadcastServiceProvider);
  final messageId = params['messageId'] as String;
  final userId = params['userId'] as String;
  final event = params['event'] as String;
  final additionalData = params['additionalData'] as Map<String, dynamic>?;
  
  await service.trackMessageInteraction(
    messageId,
    userId,
    event,
    additionalData: additionalData,
  );
});

/// Provider for processing scheduled messages
final processScheduledMessagesProvider = FutureProvider<void>((ref) async {
  final service = ref.read(adminBroadcastServiceProvider);
  await service.processScheduledMessages();
});

/// State notifier for managing broadcast message creation
class BroadcastMessageNotifier extends StateNotifier<BroadcastMessageState> {
  BroadcastMessageNotifier(this.ref) : super(const BroadcastMessageState());
  
  final Ref ref;
  
  Future<void> sendMessage(AdminBroadcastMessage message) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(adminBroadcastServiceProvider);
      await service.createBroadcastMessage(message);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> sendSpecificMessage(String messageId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(adminBroadcastServiceProvider);
      await service.sendBroadcastMessage(messageId);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> deleteMessage(String messageId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(adminBroadcastServiceProvider);
      await service.deleteBroadcastMessage(messageId);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void resetState() {
    state = const BroadcastMessageState();
  }
}

/// State for broadcast message operations
class BroadcastMessageState {
  const BroadcastMessageState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });
  
  final bool isLoading;
  final String? error;
  final bool success;
  
  BroadcastMessageState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return BroadcastMessageState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }
}

/// Provider for broadcast message state notifier
final broadcastMessageNotifierProvider = StateNotifierProvider<BroadcastMessageNotifier, BroadcastMessageState>(
  (ref) => BroadcastMessageNotifier(ref),
);