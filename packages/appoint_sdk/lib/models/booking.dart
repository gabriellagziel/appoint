/// Booking model representing an appointment in the App-Oint system
/// 
/// Contains booking information including ID, user/business IDs, scheduled time, service type, status, and metadata
class Booking {
  /// Unique booking identifier
  final String id;
  
  /// ID of the user who made the booking
  final String userId;
  
  /// ID of the business where the appointment is scheduled
  final String businessId;
  
  /// Scheduled date and time for the appointment
  final DateTime scheduledAt;
  
  /// Type of service being booked
  final String serviceType;
  
  /// Current status of the booking
  final BookingStatus status;
  
  /// Optional notes for the booking
  final String? notes;
  
  /// Optional location for the appointment
  final String? location;
  
  /// When the booking was created
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.scheduledAt,
    required this.serviceType,
    required this.status,
    this.notes,
    this.location,
    required this.createdAt,
  });

  /// Create Booking from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      businessId: json['businessId'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      serviceType: json['serviceType'] as String,
      status: BookingStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'serviceType': serviceType,
      'status': status.name,
      if (notes != null) 'notes': notes,
      if (location != null) 'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, businessId: $businessId, scheduledAt: $scheduledAt, serviceType: $serviceType, status: $status, notes: $notes, location: $location, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking &&
        other.id == id &&
        other.userId == userId &&
        other.businessId == businessId &&
        other.scheduledAt == scheduledAt &&
        other.serviceType == serviceType &&
        other.status == status &&
        other.notes == notes &&
        other.location == location &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, businessId, scheduledAt, serviceType, status, notes, location, createdAt);
  }
}

/// Booking status values
enum BookingStatus {
  /// Booking is pending confirmation
  pending,
  
  /// Booking has been confirmed
  confirmed,
  
  /// Booking has been cancelled
  cancelled,
  
  /// Appointment has been completed
  completed,
} 