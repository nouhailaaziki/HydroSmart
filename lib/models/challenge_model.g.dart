// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 4;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      id: fields[0] as String,
      typeIndex: fields[1] as int,
      targetConsumption: fields[2] as double,
      reductionPercentage: fields[3] as double,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      isActive: fields[6] as bool,
      isCompleted: fields[7] as bool,
      completionCount: fields[8] as int,
      isPaused: fields[9] as bool,
      pauseStartDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.typeIndex)
      ..writeByte(2)
      ..write(obj.targetConsumption)
      ..writeByte(3)
      ..write(obj.reductionPercentage)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.completionCount)
      ..writeByte(9)
      ..write(obj.isPaused)
      ..writeByte(10)
      ..write(obj.pauseStartDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
