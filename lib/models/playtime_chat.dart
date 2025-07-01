import 'package:freezed_annotation/freezed_annotation.dart';

part 'playtime_chat.freezed.dart';
part 'playtime_chat.g.dart';

@freezed
class PlaytimeChat with _$PlaytimeChat {
  const factory PlaytimeChat({
    required final String sessionId,
    required final List<ChatMessage> messages,
  }) = _PlaytimeChat;

  factory PlaytimeChat.fromJson(final Map<String, dynamic> json) =>
      _$PlaytimeChatFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required final String id,
    required final String senderId,
    required final String content,
    required final DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(final Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
