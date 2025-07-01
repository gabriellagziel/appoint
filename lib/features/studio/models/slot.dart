import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;

  const Slot({
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory Slot.fromFirestore(final DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Document data is null');
      }

      final startTime = data['startTime'];
      final endTime = data['endTime'];
      final isBooked = data['isBooked'] as bool? ?? false;

      if (startTime == null || endTime == null) {
        throw Exception('Missing required fields: startTime or endTime');
      }

      return Slot(
        startTime: startTime is Timestamp
            ? startTime.toDate()
            : DateTime.parse(startTime.toString()),
        endTime: endTime is Timestamp
            ? endTime.toDate()
            : DateTime.parse(endTime.toString()),
        isBooked: isBooked,
      );
    } catch (e) {
      // Removed debug print: print('❌ Error parsing slot from Firestore: $e');
      // Removed debug print: print('📄 Document ID: ${doc.id}');
      rethrow;
    }
  }
}

class SlotWithId extends Slot {
  final String id;

  const SlotWithId({
    required this.id,
    required super.startTime,
    required super.endTime,
    required super.isBooked,
  });

  factory SlotWithId.fromFirestore(final DocumentSnapshot doc) {
    final slot = Slot.fromFirestore(doc);
    return SlotWithId(
      id: doc.id,
      startTime: slot.startTime,
      endTime: slot.endTime,
      isBooked: slot.isBooked,
    );
  }

  SlotWithId copyWith({
    final String? id,
    final DateTime? startTime,
    final DateTime? endTime,
    final bool? isBooked,
  }) {
    return SlotWithId(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}
