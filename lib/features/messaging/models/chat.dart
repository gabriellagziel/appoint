import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const Chat._();
  
  const factory Chat({
    required String id,
    required String name,
    required List<String> participants,
    required DateTime createdAt,
    DateTime? lastMessageAt,
    String? lastMessage,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}