import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 5)
class UserSettings extends HiveObject {
  @HiveField(0)
  final int notificationHour;

  @HiveField(1)
  final int notificationMinute;

  @HiveField(2)
  final double? initialMeterReading;

  @HiveField(3)
  final DateTime? lastReadingDate;

  @HiveField(4)
  final DateTime? lastAppOpenDate;

  UserSettings({
    this.notificationHour = 20,
    this.notificationMinute = 0,
    this.initialMeterReading,
    this.lastReadingDate,
    this.lastAppOpenDate,
  });

  TimeOfDay get notificationTime => TimeOfDay(
        hour: notificationHour,
        minute: notificationMinute,
      );

  UserSettings copyWith({
    int? notificationHour,
    int? notificationMinute,
    double? initialMeterReading,
    DateTime? lastReadingDate,
    DateTime? lastAppOpenDate,
  }) {
    return UserSettings(
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      initialMeterReading: initialMeterReading ?? this.initialMeterReading,
      lastReadingDate: lastReadingDate ?? this.lastReadingDate,
      lastAppOpenDate: lastAppOpenDate ?? this.lastAppOpenDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationHour': notificationHour,
      'notificationMinute': notificationMinute,
      'initialMeterReading': initialMeterReading,
      'lastReadingDate': lastReadingDate?.toIso8601String(),
      'lastAppOpenDate': lastAppOpenDate?.toIso8601String(),
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      notificationHour: map['notificationHour'] as int? ?? 20,
      notificationMinute: map['notificationMinute'] as int? ?? 0,
      initialMeterReading: map['initialMeterReading'] != null
          ? (map['initialMeterReading'] as num).toDouble()
          : null,
      lastReadingDate: map['lastReadingDate'] != null
          ? DateTime.parse(map['lastReadingDate'] as String)
          : null,
      lastAppOpenDate: map['lastAppOpenDate'] != null
          ? DateTime.parse(map['lastAppOpenDate'] as String)
          : null,
    );
  }
}
