import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {

  const Slot({
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory Slot.fromFirestore(DocumentSnapshot doc) {
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
      // Removed debug print: debugPrint('❌ Error parsing slot from Firestore: $e');
      // Removed debug print: debugPrint('📄 Document ID: ${doc.id}');
      rethrow;
    }
  }
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;
}

class SlotWithId extends Slot {

  const SlotWithId({
    required this.id,
    required super.startTime,
    required super.endTime,
    required super.isBooked,
  });

  factory SlotWithId.fromFirestore(DocumentSnapshot doc) {
    final slot = Slot.fromFirestore(doc);
    return SlotWithId(
      id: doc.id,
      startTime: slot.startTime,
      endTime: slot.endTime,
      isBooked: slot.isBooked,
    );
  }
  final String id;

  SlotWithId copyWith({
    final String? id,
    final DateTime? startTime,
    final DateTime? endTime,
    final bool? isBooked,
  }) => SlotWithId(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isBooked: isBooked ?? this.isBooked,
    );
}
