// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnhancedChatMessageImpl _$$EnhancedChatMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$EnhancedChatMessageImpl(
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

Map<String, dynamic> _$$EnhancedChatMessageImplToJson(
        _$EnhancedChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'read_by': instance.readBy,
      'is_typing': instance.isTyping,
    };
