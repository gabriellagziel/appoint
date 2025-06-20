import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_chat.freezed.dart';
part 'playtime_chat.g.dart';

@freezed
class PlaytimeChat with _$PlaytimeChat {
  const factory PlaytimeChat({
    required String sessionId,
    required List<ChatMessage> messages,
  }) = _PlaytimeChat;

  factory PlaytimeChat.fromJson(Map<String, dynamic> json) =>
      _$PlaytimeChatFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderId,
    required String content,
    required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
