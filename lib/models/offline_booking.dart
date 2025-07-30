import 'package:appoint/models/booking.dart';
import 'package:hive/hive.dart';

part 'offline_booking.g.dart';

@HiveType(typeId: 1)
class OfflineBooking extends HiveObject {
  OfflineBooking({
    required this.id,
    required this.userId,
    required this.staffId,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.durationInMinutes,
    required this.lastSyncAttempt,
    this.notes,
    this.isConfirmed = false,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'pending',
    this.operation = 'create',
    this.syncError,
  });

  factory OfflineBooking.fromBooking(
    Booking booking, {
    String syncStatus = 'pending',
    String operation = 'create',
    DateTime? lastSyncAttempt,
    String? syncError,
  }) =>
      OfflineBooking(
        id: booking.id,
        userId: booking.userId,
        staffId: booking.staffId,
        serviceId: booking.serviceId,
        serviceName: booking.serviceName,
        dateTime: booking.dateTime,
        durationInMinutes: booking.duration.inMinutes,
        notes: booking.notes,
        isConfirmed: booking.isConfirmed,
        createdAt: booking.createdAt,
        updatedAt: DateTime.now(),
        syncStatus: syncStatus,
        operation: operation,
        lastSyncAttempt: lastSyncAttempt ?? DateTime.now(),
        syncError: syncError,
      );
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String staffId;

  @HiveField(3)
  final String serviceId;

  @HiveField(4)
  final String serviceName;

  @HiveField(5)
  final DateTime dateTime;

  @HiveField(6)
  final int durationInMinutes;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  final bool isConfirmed;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  @HiveField(11)
  final String syncStatus; // 'pending', 'synced', 'failed'

  @HiveField(12)
  final String operation; // 'create', 'update', 'delete'

  @HiveField(13)
  final DateTime lastSyncAttempt;

  @HiveField(14)
  final String? syncError;

  Booking toBooking() => Booking(
        id: id,
        userId: userId,
        staffId: staffId,
        serviceId: serviceId,
        serviceName: serviceName,
        dateTime: dateTime,
        duration: Duration(minutes: durationInMinutes),
        notes: notes,
        isConfirmed: isConfirmed,
        createdAt: createdAt,
      );

  OfflineBooking copyWith({
    String? id,
    String? userId,
    String? staffId,
    String? serviceId,
    String? serviceName,
    DateTime? dateTime,
    int? durationInMinutes,
    String? notes,
    bool? isConfirmed,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    String? operation,
    DateTime? lastSyncAttempt,
    String? syncError,
  }) =>
      OfflineBooking(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        staffId: staffId ?? this.staffId,
        serviceId: serviceId ?? this.serviceId,
        serviceName: serviceName ?? this.serviceName,
        dateTime: dateTime ?? this.dateTime,
        durationInMinutes: durationInMinutes ?? this.durationInMinutes,
        notes: notes ?? this.notes,
        isConfirmed: isConfirmed ?? this.isConfirmed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        operation: operation ?? this.operation,
        lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
        syncError: syncError ?? this.syncError,
      );
}
