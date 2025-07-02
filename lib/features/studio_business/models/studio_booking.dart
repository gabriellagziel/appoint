import 'package:json_annotation/json_annotation.dart';

part '../../../generated/features/studio_business/models/studio_booking.g.dart';

@JsonSerializable()
class StudioBooking {
  final String id;
  final String customerId;
  final String staffProfileId;
  final String businessProfileId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double cost;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final DateTime createdAt;
  final DateTime? updatedAt;

  StudioBooking({
    required this.id,
    required this.customerId,
    required this.staffProfileId,
    required this.businessProfileId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.cost,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory StudioBooking.fromJson(final Map<String, dynamic> json) =>
      _$StudioBookingFromJson(json);
  Map<String, dynamic> toJson() => _$StudioBookingToJson(this);
} 