// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] == null
          ? null
          : DateTime.parse(json['last_message_time'] as String),
      isGroup: json['is_group'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'participants': instance.participants,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('last_message', instance.lastMessage);
  writeNotNull(
      'last_message_time', instance.lastMessageTime?.toIso8601String());
  val['is_group'] = instance.isGroup;
  writeNotNull('image_url', instance.imageUrl);
  return val;
}

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String? ?? 'text',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'chat_id': instance.chatId,
    'sender_id': instance.senderId,
    'content': instance.content,
    'timestamp': instance.timestamp.toIso8601String(),
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('metadata', instance.metadata);
  return val;
}
