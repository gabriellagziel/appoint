/// Temporary stub Chat model for messaging API service
/// TODO: Replace with proper implementation when messaging feature is fully developed
class Chat {
  final String id;
  final String name;
  final List<String> participants;
  final DateTime lastMessageTime;
  final String? lastMessage;
  
  Chat({
    required this.id,
    required this.name,
    required this.participants,
    required this.lastMessageTime,
    this.lastMessage,
  });
  
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      participants: List<String>.from(json['participants'] as List),
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      lastMessage: json['lastMessage'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
    };
  }
}