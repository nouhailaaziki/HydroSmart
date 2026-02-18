import '../models/household_member_model.dart';
import '../models/challenge_model.dart';
import '../models/water_meter_reading_model.dart';
import 'consumption_estimation_service.dart';

/// Handles data recalculation when household configuration changes
class DataRecalculationService {
  /// Historical snapshot of household configuration
  static final Map<DateTime, List<HouseholdMember>> _householdHistory = {};

  /// Track when household configuration changes
  static void recordHouseholdChange(List<HouseholdMember> members) {
    _householdHistory[DateTime.now()] = List.from(members);
  }

  /// Get household configuration at a specific date
  static List<HouseholdMember>? getHouseholdAt(DateTime date) {
    DateTime? closestDate;
    for (var historyDate in _householdHistory.keys) {
      if (historyDate.isBefore(date) || historyDate.isAtSameMomentAs(date)) {
        if (closestDate == null || historyDate.isAfter(closestDate)) {
          closestDate = historyDate;
        }
      }
    }
    return closestDate != null ? _householdHistory[closestDate] : null;
  }

  /// Recalculate challenge targets based on new household configuration
  static Challenge recalculateChallenge(
    Challenge currentChallenge,
    List<HouseholdMember> newHouseholdMembers,
  ) {
    final type = currentChallenge.type;

    // Calculate new base consumption
    final newBaseConsumption = type == ChallengeType.weekly
        ? ConsumptionEstimationService.estimateWeeklyConsumption(newHouseholdMembers)
        : ConsumptionEstimationService.estimateMonthlyConsumption(newHouseholdMembers);

    // Apply the same reduction percentage
    final newTarget = ConsumptionEstimationService.calculateTargetWithReduction(
      newBaseConsumption,
      currentChallenge.reductionPercentage,
    );

    return currentChallenge.copyWith(
      targetConsumption: newTarget,
    );
  }

  /// Calculate consumption for a gap period
  static double calculateGapConsumption(
    List<WaterMeterReading> readings,
    DateTime gapStart,
    DateTime gapEnd,
  ) {
    // Find readings before and after gap
    WaterMeterReading? beforeGap;
    WaterMeterReading? afterGap;

    for (var reading in readings) {
      if (reading.timestamp.isBefore(gapStart) ||
          reading.timestamp.isAtSameMomentAs(gapStart)) {
        if (beforeGap == null ||
            reading.timestamp.isAfter(beforeGap.timestamp)) {
          beforeGap = reading;
        }
      }
      if (reading.timestamp.isAfter(gapEnd) ||
          reading.timestamp.isAtSameMomentAs(gapEnd)) {
        if (afterGap == null ||
            reading.timestamp.isBefore(afterGap.timestamp)) {
          afterGap = reading;
        }
      }
    }

    if (beforeGap == null || afterGap == null) {
      return 0.0; // Cannot calculate without both readings
    }

    return afterGap.meterValue - beforeGap.meterValue;
  }

  /// Distribute gap consumption evenly across days
  static List<WaterMeterReading> distributeGapConsumption({
    required double totalConsumption,
    required DateTime startDate,
    required DateTime endDate,
    required double lastMeterValue,
  }) {
    final List<WaterMeterReading> distributedReadings = [];
    final gapDays = endDate.difference(startDate).inDays;

    if (gapDays <= 0) return distributedReadings;

    final dailyConsumption = totalConsumption / gapDays;

    for (int i = 0; i < gapDays; i++) {
      final date = startDate.add(Duration(days: i + 1));
      final meterValue = lastMeterValue + (dailyConsumption * (i + 1));

      distributedReadings.add(
        WaterMeterReading(
          id: 'gap_${date.millisecondsSinceEpoch}',
          timestamp: date,
          meterValue: meterValue,
          dailyConsumption: dailyConsumption,
          isGapFilled: true,
        ),
      );
    }

    return distributedReadings;
  }

  /// Check data integrity
  static Map<String, dynamic> checkDataIntegrity(
    List<WaterMeterReading> readings,
  ) {
    final issues = <String>[];
    int gapCount = 0;
    int negativeConsumptionCount = 0;

    for (int i = 1; i < readings.length; i++) {
      final current = readings[i];
      final previous = readings[i - 1];

      // Check for gaps (more than 1 day)
      final daysDiff = current.timestamp.difference(previous.timestamp).inDays;
      if (daysDiff > 1 && !current.isGapFilled) {
        gapCount++;
        issues.add('Gap of $daysDiff days between ${previous.timestamp} and ${current.timestamp}');
      }

      // Check for negative consumption (meter went backwards)
      if (current.meterValue < previous.meterValue) {
        negativeConsumptionCount++;
        issues.add('Negative consumption detected at ${current.timestamp}');
      }

      // Check for suspicious high consumption (more than 500L per day per person)
      if (current.dailyConsumption != null &&
          current.dailyConsumption! > 500) {
        issues.add('Unusually high consumption (${current.dailyConsumption}L) at ${current.timestamp}');
      }
    }

    return {
      'hasIssues': issues.isNotEmpty,
      'gapCount': gapCount,
      'negativeConsumptionCount': negativeConsumptionCount,
      'issues': issues,
      'totalReadings': readings.length,
      'isHealthy': issues.isEmpty && gapCount == 0 && negativeConsumptionCount == 0,
    };
  }

  /// Validate meter reading
  static Map<String, dynamic> validateMeterReading({
    required double newReading,
    required double? previousReading,
    required DateTime previousDate,
    required DateTime newDate,
  }) {
    final validation = {
      'isValid': true,
      'warnings': <String>[],
      'errors': <String>[],
    };

    if (previousReading != null) {
      // Check if meter went backwards
      if (newReading < previousReading) {
        validation['isValid'] = false;
        validation['errors'] = [
          'New reading ($newReading) is less than previous reading ($previousReading). '
              'Please check your meter reading.',
        ];
        return validation;
      }

      // Calculate consumption
      final consumption = newReading - previousReading;
      final daysDiff = newDate.difference(previousDate).inDays;

      if (daysDiff > 0) {
        final dailyConsumption = consumption / daysDiff;

        // Warning for very high consumption (>500L per day)
        if (dailyConsumption > 500) {
          validation['warnings'] = [
            'Daily consumption (${dailyConsumption.toStringAsFixed(1)}L) seems unusually high. '
                'Please verify your reading.',
          ];
        }

        // Warning for zero consumption over multiple days
        if (consumption == 0 && daysDiff > 1) {
          validation['warnings'] = [
            'No water consumption detected for $daysDiff days. '
                'Are you on vacation or is there an issue with the meter?',
          ];
        }
      }
    }

    return validation;
  }

  /// Clear historical data
  static void clearHistory() {
    _householdHistory.clear();
  }

  /// Export household history for persistence
  static Map<String, dynamic> exportHistory() {
    return _householdHistory.map(
      (key, value) => MapEntry(
        key.toIso8601String(),
        value.map((m) => m.toMap()).toList(),
      ),
    );
  }

  /// Import household history from persistence
  static void importHistory(Map<String, dynamic> data) {
    // Clear the existing map instead of reassigning the variable
    _householdHistory.clear();

    data.forEach((key, value) {
      _householdHistory[DateTime.parse(key)] = (value as List)
          .map((m) => HouseholdMember.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    });
  }
}
