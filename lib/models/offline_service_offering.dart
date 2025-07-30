import 'package:appoint/models/service_offering.dart';
import 'package:hive/hive.dart';

part 'offline_service_offering.g.dart';

@HiveType(typeId: 2)
class OfflineServiceOffering extends HiveObject {
  OfflineServiceOffering({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInMinutes,
    required this.lastSyncAttempt,
    this.category,
    this.staffIds,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'pending',
    this.operation = 'create',
    this.syncError,
  });

  factory OfflineServiceOffering.fromServiceOffering(
    ServiceOffering service, {
    String syncStatus = 'pending',
    String operation = 'create',
    DateTime? lastSyncAttempt,
    String? syncError,
  }) =>
      OfflineServiceOffering(
        id: service.id,
        businessId: service.businessId,
        name: service.name,
        description: service.description,
        price: service.price,
        durationInMinutes: service.duration.inMinutes,
        category: service.category,
        staffIds: service.staffIds,
        isActive: service.isActive,
        createdAt: service.createdAt,
        updatedAt: DateTime.now(),
        syncStatus: syncStatus,
        operation: operation,
        lastSyncAttempt: lastSyncAttempt ?? DateTime.now(),
        syncError: syncError,
      );
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int durationInMinutes;

  @HiveField(6)
  final String? category;

  @HiveField(7)
  final List<String>? staffIds;

  @HiveField(8)
  final bool isActive;

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

  ServiceOffering toServiceOffering() => ServiceOffering(
        id: id,
        businessId: businessId,
        name: name,
        description: description,
        price: price,
        duration: Duration(minutes: durationInMinutes),
        category: category,
        staffIds: staffIds,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  OfflineServiceOffering copyWith({
    String? id,
    String? businessId,
    String? name,
    String? description,
    double? price,
    int? durationInMinutes,
    String? category,
    List<String>? staffIds,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    String? operation,
    DateTime? lastSyncAttempt,
    String? syncError,
  }) =>
      OfflineServiceOffering(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        durationInMinutes: durationInMinutes ?? this.durationInMinutes,
        category: category ?? this.category,
        staffIds: staffIds ?? this.staffIds,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        operation: operation ?? this.operation,
        lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
        syncError: syncError ?? this.syncError,
      );
}
