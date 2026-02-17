import 'package:hive/hive.dart';
import 'household_member_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class AppUser extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String profilePic;

  @HiveField(4)
  final int? age;

  @HiveField(5)
  final List<HouseholdMember> householdMembers;

  @HiveField(6)
  final bool hasCompletedOnboarding;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic = "https://ui-avatars.com/api/?name=User",
    this.age,
    this.householdMembers = const [],
    this.hasCompletedOnboarding = false,
  });

  int get householdSize => householdMembers.length;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePic,
    int? age,
    List<HouseholdMember>? householdMembers,
    bool? hasCompletedOnboarding,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      age: age ?? this.age,
      householdMembers: householdMembers ?? this.householdMembers,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'age': age,
      'householdMembers': householdMembers.map((m) => m.toMap()).toList(),
      'hasCompletedOnboarding': hasCompletedOnboarding,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String? ?? "https://ui-avatars.com/api/?name=User",
      age: map['age'] as int?,
      householdMembers: map['householdMembers'] != null
          ? (map['householdMembers'] as List)
              .map((m) => HouseholdMember.fromMap(m as Map<String, dynamic>))
              .toList()
          : [],
      hasCompletedOnboarding: map['hasCompletedOnboarding'] as bool? ?? false,
    );
  }
}