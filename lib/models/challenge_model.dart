import 'package:hive/hive.dart';

part 'challenge_model.g.dart';

enum ChallengeType {
  weekly,
  monthly,
}

@HiveType(typeId: 4)
class Challenge extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int typeIndex; // Store enum as int for Hive

  @HiveField(2)
  final double targetConsumption;

  @HiveField(3)
  final double reductionPercentage;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime? endDate;

  @HiveField(6)
  final bool isActive;

  @HiveField(7)
  final bool isCompleted;

  @HiveField(8)
  final int completionCount;

  @HiveField(9)
  final bool isPaused;

  @HiveField(10)
  final DateTime? pauseStartDate;

  Challenge({
    required this.id,
    required this.typeIndex,
    required this.targetConsumption,
    required this.reductionPercentage,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.isCompleted = false,
    this.completionCount = 0,
    this.isPaused = false,
    this.pauseStartDate,
  });

  ChallengeType get type => ChallengeType.values[typeIndex];

  Challenge copyWith({
    String? id,
    int? typeIndex,
    double? targetConsumption,
    double? reductionPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? isCompleted,
    int? completionCount,
    bool? isPaused,
    DateTime? pauseStartDate,
  }) {
    return Challenge(
      id: id ?? this.id,
      typeIndex: typeIndex ?? this.typeIndex,
      targetConsumption: targetConsumption ?? this.targetConsumption,
      reductionPercentage: reductionPercentage ?? this.reductionPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      completionCount: completionCount ?? this.completionCount,
      isPaused: isPaused ?? this.isPaused,
      pauseStartDate: pauseStartDate ?? this.pauseStartDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'typeIndex': typeIndex,
      'targetConsumption': targetConsumption,
      'reductionPercentage': reductionPercentage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'isCompleted': isCompleted,
      'completionCount': completionCount,
      'isPaused': isPaused,
      'pauseStartDate': pauseStartDate?.toIso8601String(),
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as String,
      typeIndex: map['typeIndex'] as int,
      targetConsumption: (map['targetConsumption'] as num).toDouble(),
      reductionPercentage: (map['reductionPercentage'] as num).toDouble(),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null 
          ? DateTime.parse(map['endDate'] as String) 
          : null,
      isActive: map['isActive'] as bool? ?? true,
      isCompleted: map['isCompleted'] as bool? ?? false,
      completionCount: map['completionCount'] as int? ?? 0,
      isPaused: map['isPaused'] as bool? ?? false,
      pauseStartDate: map['pauseStartDate'] != null 
          ? DateTime.parse(map['pauseStartDate'] as String) 
          : null,
    );
  }

  int get durationInDays {
    if (endDate == null) {
      return type == ChallengeType.weekly ? 7 : 30;
    }
    return endDate!.difference(startDate).inDays;
  }

  int get remainingDays {
    if (endDate == null) return 0;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return 0;
    return endDate!.difference(now).inDays;
  }

  double get progressPercentage {
    if (endDate == null) return 0.0;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return 1.0;
    final totalDuration = endDate!.difference(startDate).inDays;
    final elapsed = now.difference(startDate).inDays;
    if (totalDuration == 0) return 0.0;
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }
}
