// Model representing a stored content record in Firestore.
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a piece of content in the library.
class ContentItem {
  ContentItem({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description,
    this.imageUrl,
  });

  /// Constructs a [ContentItem] from Firestore data.
  factory ContentItem.fromMap(String id, final Map<String, dynamic> map) {
    final ts = map['createdAt'];
    DateTime created;
    if (ts is Timestamp) {
      created = ts.toDate();
    } else if (ts is String) {
      created = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      created = DateTime.now();
    }
    return ContentItem(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      createdAt: created,
    );
  }
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;

  /// Converts this item to a map for Firestore.
  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
