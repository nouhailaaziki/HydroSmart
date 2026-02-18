import 'package:hive/hive.dart';

part 'water_meter_reading_model.g.dart';

@HiveType(typeId: 3)
class WaterMeterReading extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double meterValue;

  @HiveField(3)
  final double? dailyConsumption;

  @HiveField(4)
  final bool isGapFilled;

  WaterMeterReading({
    required this.id,
    required this.timestamp,
    required this.meterValue,
    this.dailyConsumption,
    this.isGapFilled = false,
  });

  WaterMeterReading copyWith({
    String? id,
    DateTime? timestamp,
    double? meterValue,
    double? dailyConsumption,
    bool? isGapFilled,
  }) {
    return WaterMeterReading(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      meterValue: meterValue ?? this.meterValue,
      dailyConsumption: dailyConsumption ?? this.dailyConsumption,
      isGapFilled: isGapFilled ?? this.isGapFilled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'meterValue': meterValue,
      'dailyConsumption': dailyConsumption,
      'isGapFilled': isGapFilled,
    };
  }

  factory WaterMeterReading.fromMap(Map<String, dynamic> map) {
    return WaterMeterReading(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      meterValue: (map['meterValue'] as num).toDouble(),
      dailyConsumption: map['dailyConsumption'] != null 
          ? (map['dailyConsumption'] as num).toDouble() 
          : null,
      isGapFilled: map['isGapFilled'] as bool? ?? false,
    );
  }
}
