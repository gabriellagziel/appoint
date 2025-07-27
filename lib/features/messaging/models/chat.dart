import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String name,
    required List<String> participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    @Default(false) bool isGroup,
    String? imageUrl,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required DateTime timestamp,
    @Default('text') String type,
    Map<String, dynamic>? metadata,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => 
      _$ChatMessageFromJson(json);
}