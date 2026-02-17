import 'package:hive/hive.dart';

part 'household_member_model.g.dart';

@HiveType(typeId: 2)
class HouseholdMember extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final int age;

  HouseholdMember({
    required this.id,
    this.name,
    required this.age,
  });

  HouseholdMember copyWith({
    String? id,
    String? name,
    int? age,
  }) {
    return HouseholdMember(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  factory HouseholdMember.fromMap(Map<String, dynamic> map) {
    return HouseholdMember(
      id: map['id'] as String,
      name: map['name'] as String?,
      age: map['age'] as int,
    );
  }
}
