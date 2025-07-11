import 'package:freezed_annotation/freezed_annotation.dart';

part 'enhanced_chat_message.freezed.dart';
part 'enhanced_chat_message.g.dart';

@freezed
class EnhancedChatMessage with _$EnhancedChatMessage {
  const factory EnhancedChatMessage({
    required final String id,
    required final String senderId,
    required final String content,
    required final DateTime timestamp,
    @Default([]) final List<String> readBy,
    @Default(false) final bool isTyping,
  }) = _EnhancedChatMessage;

  factory EnhancedChatMessage.fromJson(Map<String, dynamic> json) =>
      _$EnhancedChatMessageFromJson(json);
}
