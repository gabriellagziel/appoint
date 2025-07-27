import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  const Message({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.replyToId,
    this.attachments,
    this.metadata,
    this.isRead = false,
    this.isDelivered = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  final String id;
  final String senderId;
  final String chatId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? replyToId;
  final List<Attachment>? attachments;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final bool isDelivered;

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String? id,
    String? senderId,
    String? chatId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    String? replyToId,
    List<Attachment>? attachments,
    Map<String, dynamic>? metadata,
    bool? isRead,
    bool? isDelivered,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      replyToId: replyToId ?? this.replyToId,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }
}

@JsonSerializable()
class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.participants,
    required this.type,
    required this.lastMessage,
    required this.updatedAt,
    this.name,
    this.avatar,
    this.metadata,
    this.isGroup = false,
    this.isArchived = false,
    this.isMuted = false,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);

  final String id;
  final List<String> participants;
  final ChatType type;
  final Message? lastMessage;
  final DateTime updatedAt;
  final String? name;
  final String? avatar;
  final Map<String, dynamic>? metadata;
  final bool isGroup;
  final bool isArchived;
  final bool isMuted;

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);

  ChatRoom copyWith({
    String? id,
    List<String>? participants,
    ChatType? type,
    Message? lastMessage,
    DateTime? updatedAt,
    String? name,
    String? avatar,
    Map<String, dynamic>? metadata,
    bool? isGroup,
    bool? isArchived,
    bool? isMuted,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      type: type ?? this.type,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      metadata: metadata ?? this.metadata,
      isGroup: isGroup ?? this.isGroup,
      isArchived: isArchived ?? this.isArchived,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

@JsonSerializable()
class Attachment {
  const Attachment({
    required this.id,
    required this.type,
    required this.url,
    required this.name,
    this.size,
    this.mimeType,
    this.metadata,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  final String id;
  final AttachmentType type;
  final String url;
  final String name;
  final int? size;
  final String? mimeType;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}

@JsonSerializable()
class Conversation {
  const Conversation({
    required this.id,
    required this.chat,
    required this.messages,
    required this.unreadCount,
    this.participantProfiles,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  final String id;
  final Chat chat;
  final List<Message> messages;
  final int unreadCount;
  final Map<String, UserProfile>? participantProfiles;

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}

@JsonSerializable()
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.avatar,
    this.status,
    this.lastSeen,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  final String id;
  final String name;
  final String? avatar;
  final String? status;
  final DateTime? lastSeen;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('file')
  file,
  @JsonValue('location')
  location,
  @JsonValue('system')
  system,
}

enum ChatType {
  @JsonValue('direct')
  direct,
  @JsonValue('group')
  group,
  @JsonValue('business')
  business,
  @JsonValue('support')
  support,
}

enum AttachmentType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('document')
  document,
  @JsonValue('location')
  location,
} 