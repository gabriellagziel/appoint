// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playtime_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaytimeChatImpl _$$PlaytimeChatImplFromJson(Map<String, dynamic> json) =>
    _$PlaytimeChatImpl(
      sessionId: json['session_id'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlaytimeChatImplToJson(_$PlaytimeChatImpl instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'messages': instance.messages,
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      readBy: (json['read_by'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isTyping: json['is_typing'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'read_by': instance.readBy,
      'is_typing': instance.isTyping,
    };
