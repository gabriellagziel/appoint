// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      chatId: json['chat_id'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      replyToId: json['reply_to_id'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      isDelivered: json['is_delivered'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'sender_id': instance.senderId,
    'chat_id': instance.chatId,
    'content': instance.content,
    'type': _$MessageTypeEnumMap[instance.type]!,
    'timestamp': instance.timestamp.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reply_to_id', instance.replyToId);
  writeNotNull('attachments', instance.attachments);
  writeNotNull('metadata', instance.metadata);
  val['is_read'] = instance.isRead;
  val['is_delivered'] = instance.isDelivered;
  return val;
}

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
  MessageType.file: 'file',
  MessageType.location: 'location',
  MessageType.system: 'system',
};

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      lastMessage: json['last_message'] == null
          ? null
          : Message.fromJson(json['last_message'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isGroup: json['is_group'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'participants': instance.participants,
    'type': _$ChatTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('last_message', instance.lastMessage);
  val['updated_at'] = instance.updatedAt.toIso8601String();
  writeNotNull('name', instance.name);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('metadata', instance.metadata);
  val['is_group'] = instance.isGroup;
  val['is_archived'] = instance.isArchived;
  val['is_muted'] = instance.isMuted;
  return val;
}

const _$ChatTypeEnumMap = {
  ChatType.direct: 'direct',
  ChatType.group: 'group',
  ChatType.business: 'business',
  ChatType.support: 'support',
};

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      id: json['id'] as String,
      type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
      url: json['url'] as String,
      name: json['name'] as String,
      size: (json['size'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$AttachmentTypeEnumMap[instance.type]!,
    'url': instance.url,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('size', instance.size);
  writeNotNull('mime_type', instance.mimeType);
  writeNotNull('metadata', instance.metadata);
  return val;
}

const _$AttachmentTypeEnumMap = {
  AttachmentType.image: 'image',
  AttachmentType.video: 'video',
  AttachmentType.audio: 'audio',
  AttachmentType.document: 'document',
  AttachmentType.location: 'location',
};

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      id: json['id'] as String,
      chat: Chat.fromJson(json['chat'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unread_count'] as num).toInt(),
      participantProfiles:
          (json['participant_profiles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, UserProfile.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'chat': instance.chat,
    'messages': instance.messages,
    'unread_count': instance.unreadCount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('participant_profiles', instance.participantProfiles);
  return val;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      status: json['status'] as String?,
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('avatar', instance.avatar);
  writeNotNull('status', instance.status);
  writeNotNull('last_seen', instance.lastSeen?.toIso8601String());
  return val;
}
