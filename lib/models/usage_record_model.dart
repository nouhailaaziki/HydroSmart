class UsageRecord {
  final DateTime date;
  final double usage;
  final double goal;

  UsageRecord({
    required this.date,
    required this.usage,
    required this.goal,
  });

  bool get isUnderGoal => usage <= goal;
  
  double get savedLiters => goal - usage;

  factory UsageRecord.fromMap(Map<String, dynamic> map) {
    return UsageRecord(
      date: DateTime.parse(map['date']),
      usage: map['usage'],
      goal: map['goal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'usage': usage,
      'goal': goal,
    };
  }
}
