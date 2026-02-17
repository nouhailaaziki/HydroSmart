import '../models/household_member_model.dart';

class ConsumptionEstimationService {
  /// Average daily water consumption in liters per person for children (0-12 years)
  static const double childConsumption = 120.0;
  
  /// Average daily water consumption in liters per person for teenagers (13-17 years)
  static const double teenConsumption = 150.0;
  
  /// Average daily water consumption in liters per person for adults (18-64 years)
  static const double adultConsumption = 165.0;
  
  /// Average daily water consumption in liters per person for seniors (65+ years)
  static const double seniorConsumption = 140.0;

  /// Estimates daily water consumption for a household based on member ages
  static double estimateDailyConsumption(List<HouseholdMember> members) {
    if (members.isEmpty) return 0.0;

    double total = 0.0;
    for (var member in members) {
      total += _getConsumptionForAge(member.age);
    }
    return total;
  }

  /// Estimates weekly water consumption
  static double estimateWeeklyConsumption(List<HouseholdMember> members) {
    return estimateDailyConsumption(members) * 7;
  }

  /// Estimates monthly water consumption (30 days)
  static double estimateMonthlyConsumption(List<HouseholdMember> members) {
    return estimateDailyConsumption(members) * 30;
  }

  /// Get consumption rate for a specific age
  static double _getConsumptionForAge(int age) {
    if (age <= 12) {
      return childConsumption;
    } else if (age <= 17) {
      return teenConsumption;
    } else if (age <= 64) {
      return adultConsumption;
    } else {
      return seniorConsumption;
    }
  }

  /// Calculate target consumption with reduction percentage
  static double calculateTargetWithReduction(
    double baseConsumption,
    double reductionPercentage,
  ) {
    return baseConsumption * (1 - reductionPercentage / 100);
  }

  /// Calculate next challenge target after successful completion
  /// Progressive reduction with maximum savings cap
  static double calculateProgressiveTarget(
    double currentTarget,
    double reductionPercentage,
    double minimumThreshold,
  ) {
    final newTarget = currentTarget * (1 - reductionPercentage / 100);
    return newTarget < minimumThreshold ? minimumThreshold : newTarget;
  }

  /// Get age group description
  static String getAgeGroupDescription(int age) {
    if (age <= 12) return 'Child';
    if (age <= 17) return 'Teen';
    if (age <= 64) return 'Adult';
    return 'Senior';
  }

  /// Calculate household water usage profile
  static Map<String, dynamic> getHouseholdProfile(List<HouseholdMember> members) {
    int children = 0;
    int teens = 0;
    int adults = 0;
    int seniors = 0;

    for (var member in members) {
      if (member.age <= 12) {
        children++;
      } else if (member.age <= 17) {
        teens++;
      } else if (member.age <= 64) {
        adults++;
      } else {
        seniors++;
      }
    }

    return {
      'children': children,
      'teens': teens,
      'adults': adults,
      'seniors': seniors,
      'totalMembers': members.length,
      'estimatedDaily': estimateDailyConsumption(members),
      'estimatedWeekly': estimateWeeklyConsumption(members),
      'estimatedMonthly': estimateMonthlyConsumption(members),
    };
  }
}
