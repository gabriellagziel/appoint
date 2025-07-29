/// Thrown when a local booking operation conflicts with the server state.
class BookingConflictException implements Exception {
  BookingConflictException({
    required this.bookingId,
    required this.localUpdatedAt,
    required this.remoteUpdatedAt,
    this.message = 'Booking conflict detected.',
  });

  /// The ID of the booking that caused the conflict.
  final String bookingId;

  /// The local version timestamp.
  final DateTime localUpdatedAt;

  /// The remote server version timestamp.
  final DateTime remoteUpdatedAt;

  /// Optional human-readable message.
  final String message;

  @override
  String toString() => 'BookingConflictException: bookingId=$bookingId '
      '(local: $localUpdatedAt, remote: $remoteUpdatedAt) — $message';
}
