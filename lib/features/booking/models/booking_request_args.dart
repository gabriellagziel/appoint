class BookingRequestArgs {
  BookingRequestArgs({
    required this.inviteeId,
    required this.openCall,
    this.scheduledAt,
    this.serviceType,
    this.notes,
    this.location,
    this.businessId,
  });

  factory BookingRequestArgs.fromJson(Map<String, dynamic> json) =>
      BookingRequestArgs(
        inviteeId: json['inviteeId'] as String,
        openCall: json['openCall'] as bool,
        scheduledAt: json['scheduledAt'] != null
            ? DateTime.parse(json['scheduledAt'] as String)
            : null,
        serviceType: json['serviceType'] as String?,
        notes: json['notes'] as String?,
        location: json['location'] as String?,
        businessId: json['businessId'] as String?,
      );

  final String inviteeId;
  final bool openCall;
  final DateTime? scheduledAt;
  final String? serviceType;
  final String? notes;
  final String? location;
  final String? businessId;

  BookingRequestArgs copyWith({
    String? inviteeId,
    bool? openCall,
    DateTime? scheduledAt,
    String? serviceType,
    String? notes,
    String? location,
    String? businessId,
  }) =>
      BookingRequestArgs(
        inviteeId: inviteeId ?? this.inviteeId,
        openCall: openCall ?? this.openCall,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        serviceType: serviceType ?? this.serviceType,
        notes: notes ?? this.notes,
        location: location ?? this.location,
        businessId: businessId ?? this.businessId,
      );

  Map<String, dynamic> toJson() => {
        'inviteeId': inviteeId,
        'openCall': openCall,
        'scheduledAt': scheduledAt?.toIso8601String(),
        'serviceType': serviceType,
        'notes': notes,
        'location': location,
        'businessId': businessId,
      };
}
