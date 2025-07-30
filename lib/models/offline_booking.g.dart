// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineBookingAdapter extends TypeAdapter<OfflineBooking> {
  @override
  final int typeId = 1;

  @override
  OfflineBooking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineBooking(
      id: fields[0] as String,
      userId: fields[1] as String,
      staffId: fields[2] as String,
      serviceId: fields[3] as String,
      serviceName: fields[4] as String,
      dateTime: fields[5] as DateTime,
      durationInMinutes: fields[6] as int,
      lastSyncAttempt: fields[13] as DateTime,
      notes: fields[7] as String?,
      isConfirmed: fields[8] as bool,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
      syncStatus: fields[11] as String,
      operation: fields[12] as String,
      syncError: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineBooking obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.staffId)
      ..writeByte(3)
      ..write(obj.serviceId)
      ..writeByte(4)
      ..write(obj.serviceName)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.durationInMinutes)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.isConfirmed)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.syncStatus)
      ..writeByte(12)
      ..write(obj.operation)
      ..writeByte(13)
      ..write(obj.lastSyncAttempt)
      ..writeByte(14)
      ..write(obj.syncError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineBookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
