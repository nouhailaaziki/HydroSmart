// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_member_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HouseholdMemberAdapter extends TypeAdapter<HouseholdMember> {
  @override
  final int typeId = 2;

  @override
  HouseholdMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HouseholdMember(
      id: fields[0] as String,
      name: fields[1] as String?,
      age: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HouseholdMember obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HouseholdMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
