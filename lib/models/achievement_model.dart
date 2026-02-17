class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int pointsRequired;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.pointsRequired,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? pointsRequired,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      pointsRequired: map['pointsRequired'],
      isUnlocked: map['isUnlocked'] ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'pointsRequired': pointsRequired,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  // Default achievements
  static List<Achievement> getDefaultAchievements() {
    return [
      Achievement(
        id: 'water_warrior',
        title: 'Water Warrior',
        description: 'Complete your first week',
        icon: '🌊',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'drop_by_drop',
        title: 'Drop by Drop',
        description: 'Save 100L total',
        icon: '💧',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'consistency_king',
        title: 'Consistency King',
        description: 'Maintain a 30-day streak',
        icon: '🏆',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'eco_hero',
        title: 'Eco Hero',
        description: 'Save 1000L total',
        icon: '🌍',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'hot_streak',
        title: 'Hot Streak',
        description: 'Stay under goal for 7 days',
        icon: '🔥',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'perfect_week',
        title: 'Perfect Week',
        description: 'Every day under daily target',
        icon: '🎯',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'leak_detective',
        title: 'Leak Detective',
        description: 'Detect your first leak',
        icon: '🛡️',
        pointsRequired: 0,
      ),
      Achievement(
        id: 'ai_friend',
        title: 'AI Friend',
        description: 'Have 50 AI conversations',
        icon: '🤖',
        pointsRequired: 0,
      ),
    ];
  }
}