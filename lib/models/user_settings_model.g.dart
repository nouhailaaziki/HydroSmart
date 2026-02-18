// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 5;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      notificationHour: fields[0] as int,
      notificationMinute: fields[1] as int,
      initialMeterReading: fields[2] as double?,
      lastReadingDate: fields[3] as DateTime?,
      lastAppOpenDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.notificationHour)
      ..writeByte(1)
      ..write(obj.notificationMinute)
      ..writeByte(2)
      ..write(obj.initialMeterReading)
      ..writeByte(3)
      ..write(obj.lastReadingDate)
      ..writeByte(4)
      ..write(obj.lastAppOpenDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
