// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_meter_reading_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterMeterReadingAdapter extends TypeAdapter<WaterMeterReading> {
  @override
  final int typeId = 3;

  @override
  WaterMeterReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterMeterReading(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      meterValue: fields[2] as double,
      dailyConsumption: fields[3] as double?,
      isGapFilled: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WaterMeterReading obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.meterValue)
      ..writeByte(3)
      ..write(obj.dailyConsumption)
      ..writeByte(4)
      ..write(obj.isGapFilled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterMeterReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
