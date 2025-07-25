class Chat {
  final String id;
  final String name;
  final List<String> participants;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final String? lastMessage;

  const Chat({
    required this.id,
    required this.name,
    required this.participants,
    required this.createdAt,
    this.lastMessageAt,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      participants: List<String>.from(json['participants'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: json['lastMessageAt'] != null 
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      lastMessage: json['lastMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'lastMessage': lastMessage,
    };
  }
}