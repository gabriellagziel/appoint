class Booking {
  final DateTime dateTime;
  final String notes;

  Booking({
    required this.dateTime,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
    };
  }
}
