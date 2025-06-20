// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playtime_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaytimeChatImpl _$$PlaytimeChatImplFromJson(Map<String, dynamic> json) =>
    _$PlaytimeChatImpl(
      sessionId: json['sessionId'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlaytimeChatImplToJson(_$PlaytimeChatImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
    };
