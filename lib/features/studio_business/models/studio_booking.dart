import 'package:json_annotation/json_annotation.dart';

// Temporarily removed generated file dependency
// part 'studio_booking.g.dart';

@JsonSerializable()
class StudioBooking {

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

  // Manual implementation instead of generated code
  factory StudioBooking.fromJson(Map<String, dynamic> json) {
    return StudioBooking(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      staffProfileId: json['staffProfileId'] as String,
      businessProfileId: json['businessProfileId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      cost: (json['cost'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

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
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'staffProfileId': staffProfileId,
      'businessProfileId': businessProfileId,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'cost': cost,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
