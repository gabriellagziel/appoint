import 'dart:io';
import 'package:appoint/models/enhanced_chat_message.dart';
import 'package:appoint/services/api/api_client.dart';

class MessagingApiService {
  MessagingApiService._();
  static final MessagingApiService _instance = MessagingApiService._();
  static MessagingApiService get instance => _instance;

  // Get chat history
  Future<List<EnhancedChatMessage>> getChatHistory({
    required String chatId,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        queryParameters: queryParams,
      );

      final messages = response['messages'] as List;
      return messages
          .map((message) => EnhancedChatMessage.fromJson(message))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Send a message
  Future<EnhancedChatMessage> sendMessage({
    required String chatId,
    required String content,
    String? messageType,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        data: {
          'content': content,
          'messageType': messageType ?? 'text',
          'metadata': metadata,
        },
      );

      return EnhancedChatMessage.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get user's chats
  Future<List<Map<String, dynamic>>> getUserChats({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats',
        queryParameters: queryParams,
      );

      return (response['chats'] as List)
          .map((chat) => chat as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create a new chat
  Future<Map<String, dynamic>> createChat({
    required String participantId,
    String? initialMessage,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats',
        data: {
          'participantId': participantId,
          'initialMessage': initialMessage,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get chat details
  Future<Map<String, dynamic>> getChat(String chatId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update chat status
  Future<void> updateChatStatus({
    required String chatId,
    required String status,
  }) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId',
        data: {
          'status': status,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Send file message
  Future<EnhancedChatMessage> sendFileMessage({
    required String chatId,
    required String filePath,
    required String fileName,
    String? messageType,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Create form data for file upload
      final formData = {
        'file': await File(filePath).readAsBytes(),
        'fileName': fileName,
        'messageType': messageType ?? 'file',
        'metadata': metadata,
      };

      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$chatId/messages/file',
        data: formData,
      );

      return EnhancedChatMessage.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/messages/read',
        data: {
          'messageIds': messageIds,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Delete a message
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get unread message count
  Future<int> getUnreadMessageCount() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/unread-count',
      );

      return response['count'] as int;
    } catch (e) {
      rethrow;
    }
  }

  // Search messages
  Future<List<EnhancedChatMessage>> searchMessages({
    required String query,
    String? chatId,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'query': query,
      };
      if (chatId != null) queryParams['chatId'] = chatId;
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/messages/search',
        queryParameters: queryParams,
      );

      final messages = response['messages'] as List;
      return messages
          .map((message) => EnhancedChatMessage.fromJson(message))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get message statistics
  Future<Map<String, dynamic>> getMessageStats({
    String? chatId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (chatId != null) queryParams['chatId'] = chatId;
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/messages/stats',
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get chat participants
  Future<List<Map<String, dynamic>>> getChatParticipants(String chatId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/participants',
      );

      return (response['participants'] as List)
          .map((participant) => participant as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add participant to chat
  Future<void> addChatParticipant({
    required String chatId,
    required String participantId,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$chatId/participants',
        data: {
          'participantId': participantId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Remove participant from chat
  Future<void> removeChatParticipant({
    required String chatId,
    required String participantId,
  }) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/chats/$chatId/participants/$participantId',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get chat settings
  Future<Map<String, dynamic>> getChatSettings(String chatId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/settings',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update chat settings
  Future<void> updateChatSettings({
    required String chatId,
    required Map<String, dynamic> settings,
  }) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/settings',
        data: settings,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get message by ID
  Future<EnhancedChatMessage> getMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId',
      );

      return EnhancedChatMessage.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Edit a message
  Future<EnhancedChatMessage> editMessage({
    required String chatId,
    required String messageId,
    required String newContent,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId',
        data: {
          'content': newContent,
        },
      );

      return EnhancedChatMessage.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // React to a message
  Future<void> reactToMessage({
    required String chatId,
    required String messageId,
    required String reaction,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/reactions',
        data: {
          'reaction': reaction,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Remove reaction from message
  Future<void> removeMessageReaction({
    required String chatId,
    required String messageId,
    required String reaction,
  }) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/reactions/$reaction',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get message reactions
  Future<Map<String, List<String>>> getMessageReactions({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/reactions',
      );

      final reactions = response['reactions'] as Map<String, dynamic>;
      return reactions
          .map((key, value) => MapEntry(key, List<String>.from(value)));
    } catch (e) {
      rethrow;
    }
  }

  // Forward message
  Future<void> forwardMessage({
    required String sourceChatId,
    required String messageId,
    required List<String> targetChatIds,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$sourceChatId/messages/$messageId/forward',
        data: {
          'targetChatIds': targetChatIds,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get typing indicators
  Future<List<Map<String, dynamic>>> getTypingIndicators(String chatId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/typing',
      );

      return (response['typing'] as List)
          .map((indicator) => indicator as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Send typing indicator
  Future<void> sendTypingIndicator({
    required String chatId,
    required bool isTyping,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$chatId/typing',
        data: {
          'isTyping': isTyping,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get message delivery status
  Future<Map<String, String>> getMessageDeliveryStatus({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/delivery-status',
      );

      return Map<String, String>.from(response['status']);
    } catch (e) {
      rethrow;
    }
  }

  // Get chat analytics
  Future<Map<String, dynamic>> getChatAnalytics({
    required String chatId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/analytics',
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
