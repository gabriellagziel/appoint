class Contact {
  final String id;
  final String displayName;
  final String phone;
  final String? photoUrl;

  Contact({
    required this.id,
    required this.displayName,
    required this.phone,
    this.photoUrl,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }
}
