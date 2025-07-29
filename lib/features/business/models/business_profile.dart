import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory BusinessProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BusinessProfile(
      id: doc.id,
      name: data['name'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
    );
  }
  final String id;
  final String name;
  final bool isActive;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isActive': isActive,
      };

  BusinessProfile copyWith({
    final String? id,
    final String? name,
    final bool? isActive,
  }) =>
      BusinessProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
      );

  @override
  String toString() =>
      'BusinessProfile(id: $id, name: $name, isActive: $isActive)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusinessProfile &&
        other.id == id &&
        other.name == name &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, name, isActive);
}
