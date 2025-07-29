import 'package:appoint/models/chat.dart';
import 'package:appoint/models/message.dart';
import 'package:appoint/services/api/api_client.dart';

class MessagingApiService {
  MessagingApiService._();
  static final MessagingApiService _instance = MessagingApiService._();
  static MessagingApiService get instance => _instance;

  // Get user's chats
  Future<List<Chat>> getUserChats() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats',
      );

      final chats = response['chats'] as List;
      return chats.map(Chat.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get chat messages
  Future<List<Message>> getChatMessages({
    required String chatId,
    int? limit,
    String? beforeMessageId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (beforeMessageId != null) queryParams['before'] = beforeMessageId;

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        queryParameters: queryParams,
      );

      final messages = response['messages'] as List;
      return messages.map(Message.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Send message
  Future<Message> sendMessage({
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
          'type': messageType ?? 'text',
          if (metadata != null) 'metadata': metadata,
        },
      );

      return Message.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Create new chat
  Future<Chat> createChat({
    required String participantId,
    String? initialMessage,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats',
        data: {
          'participantId': participantId,
          if (initialMessage != null) 'initialMessage': initialMessage,
        },
      );

      return Chat.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get chat details
  Future<Chat> getChatDetails(String chatId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId',
      );

      return Chat.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead({
    required String chatId,
    List<String>? messageIds,
  }) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/read',
        data: {
          if (messageIds != null) 'messageIds': messageIds,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Delete message
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

  // Edit message
  Future<Message> editMessage({
    required String chatId,
    required String messageId,
    required String newContent,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId',
        data: {'content': newContent},
      );

      return Message.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Send file message
  Future<Message> sendFileMessage({
    required String chatId,
    required String filePath,
    required String fileName,
    String? messageType,
  }) async {
    try {
      final response =
          await ApiClient.instance.uploadFile<Map<String, dynamic>>(
        '/chats/$chatId/messages/file',
        File(filePath),
        extraData: {
          'fileName': fileName,
          'type': messageType ?? 'file',
        },
      );

      return Message.fromJson(response);
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
  Future<List<Message>> searchMessages({
    required String query,
    String? chatId,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (chatId != null) 'chatId': chatId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/messages/search',
        queryParameters: queryParams,
      );

      final messages = response['messages'] as List;
      return messages.map(Message.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get message reactions
  Future<List<MessageReaction>> getMessageReactions({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/reactions',
      );

      final reactions = response['reactions'] as List;
      return reactions
          .map((reaction) => MessageReaction.fromJson(reaction))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add reaction to message
  Future<void> addMessageReaction({
    required String chatId,
    required String messageId,
    required String reaction,
  }) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/reactions',
        data: {'reaction': reaction},
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

  // Get chat participants
  Future<List<ChatParticipant>> getChatParticipants(String chatId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/$chatId/participants',
      );

      final participants = response['participants'] as List;
      return participants.map((p) => ChatParticipant.fromJson(p)).toList();
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
        data: {'participantId': participantId},
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

  // Leave chat
  Future<void> leaveChat(String chatId) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/chats/$chatId/leave',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Archive chat
  Future<void> archiveChat(String chatId) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/archive',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Unarchive chat
  Future<void> unarchiveChat(String chatId) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/chats/$chatId/unarchive',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get archived chats
  Future<List<Chat>> getArchivedChats() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/chats/archived',
      );

      final chats = response['chats'] as List;
      return chats.map(Chat.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }
}

class MessageReaction {
  const MessageReaction({
    required this.reaction,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      MessageReaction(
        reaction: json['reaction'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  final String reaction;
  final String userId;
  final String userName;
  final DateTime timestamp;
}

class ChatParticipant {
  const ChatParticipant({
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      ChatParticipant(
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        avatar: json['avatar'] as String?,
        isOnline: json['isOnline'] as bool,
        lastSeen: json['lastSeen'] != null
            ? DateTime.parse(json['lastSeen'] as String)
            : null,
      );

  final String userId;
  final String userName;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;
}
