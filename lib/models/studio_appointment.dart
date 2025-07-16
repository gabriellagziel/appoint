import 'package:cloud_firestore/cloud_firestore.dart';

class StudioAppointment {
  final String id;
  final String businessId;
  final String customerId;
  final String customerName;
  final DateTime date;
  final String time;
  final Duration duration;
  final String service;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudioAppointment({
    required this.id,
    required this.businessId,
    required this.customerId,
    required this.customerName,
    required this.date,
    required this.time,
    required this.duration,
    required this.service,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudioAppointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudioAppointment(
      id: doc.id,
      businessId: data['businessId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      time: data['time'] ?? '',
      duration: Duration(minutes: data['duration'] ?? 60),
      service: data['service'] ?? '',
      status: data['status'] ?? 'pending',
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory StudioAppointment.fromJson(Map<String, dynamic> json) => StudioAppointment(
    id: json['id'] as String,
    businessId: json['businessId'] as String,
    customerId: json['customerId'] as String,
    customerName: json['customerName'] as String,
    date: DateTime.parse(json['date'] as String),
    time: json['time'] as String,
    duration: Duration(minutes: json['duration'] as int),
    service: json['service'] as String,
    status: json['status'] as String,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'businessId': businessId,
    'customerId': customerId,
    'customerName': customerName,
    'date': date.toIso8601String(),
    'time': time,
    'duration': duration.inMinutes,
    'service': service,
    'status': status,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Map<String, dynamic> toFirestore() => {
    'businessId': businessId,
    'customerId': customerId,
    'customerName': customerName,
    'date': date.toIso8601String(),
    'time': time,
    'duration': duration.inMinutes,
    'service': service,
    'status': status,
    'notes': notes,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  StudioAppointment copyWith({
    String? id,
    String? businessId,
    String? customerId,
    String? customerName,
    DateTime? date,
    String? time,
    Duration? duration,
    String? service,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StudioAppointment(
    id: id ?? this.id,
    businessId: businessId ?? this.businessId,
    customerId: customerId ?? this.customerId,
    customerName: customerName ?? this.customerName,
    date: date ?? this.date,
    time: time ?? this.time,
    duration: duration ?? this.duration,
    service: service ?? this.service,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
