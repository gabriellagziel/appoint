class BookingRequestArgs {
  BookingRequestArgs({
    required this.inviteeId,
    required this.openCall,
    this.scheduledAt,
  });
  final String inviteeId;
  final bool openCall;
  final DateTime? scheduledAt;
}
