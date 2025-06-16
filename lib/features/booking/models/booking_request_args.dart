class BookingRequestArgs {
  final String inviteeId;
  final bool openCall;
  final DateTime? scheduledAt;
  BookingRequestArgs({
    required this.inviteeId,
    required this.openCall,
    this.scheduledAt,
  });
}
