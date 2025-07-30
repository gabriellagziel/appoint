/// Temporary stub Message model for messaging API service
/// TODO: Replace with proper implementation when messaging feature is fully developed
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  
  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
    };
  }
}

enum MessageType {
  text,
  image,
  file,
  system,
}