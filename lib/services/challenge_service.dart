import 'package:uuid/uuid.dart';
import '../models/challenge_model.dart';
import '../models/household_member_model.dart';
import 'consumption_estimation_service.dart';

class ChallengeService {
  static const uuid = Uuid();

  // Default reduction percentage for new challenges
  static const double defaultReductionPercentage = 5.0;

  // Progressive reduction percentage after each successful completion
  static const double progressiveReductionPercentage = 3.0;

  // Maximum reduction percentage that can be achieved (50% of original estimate)
  static const double maximumReductionPercentage = 50.0;

  /// Create a new challenge based on household data
  static Challenge createChallenge({
    required ChallengeType type,
    required List<HouseholdMember> householdMembers,
    double? customReduction,
    int previousCompletions = 0,
  }) {
    // Calculate base consumption
    final baseConsumption = type == ChallengeType.weekly
        ? ConsumptionEstimationService.estimateWeeklyConsumption(householdMembers)
        : ConsumptionEstimationService.estimateMonthlyConsumption(householdMembers);

    // Calculate target with reduction
    final reductionPercentage = customReduction ?? defaultReductionPercentage;
    final targetConsumption = ConsumptionEstimationService.calculateTargetWithReduction(
      baseConsumption,
      reductionPercentage,
    );

    final now = DateTime.now();
    final duration = type == ChallengeType.weekly ? 7 : 30;
    final endDate = now.add(Duration(days: duration));

    return Challenge(
      id: uuid.v4(),
      typeIndex: type.index,
      targetConsumption: targetConsumption,
      reductionPercentage: reductionPercentage,
      startDate: now,
      endDate: endDate,
      isActive: true,
      isCompleted: false,
      completionCount: previousCompletions,
    );
  }

  /// Calculate the next challenge target after successful completion
  static Challenge createProgressiveChallenge({
    required Challenge previousChallenge,
    required List<HouseholdMember> householdMembers,
  }) {
    final type = previousChallenge.type;

    // Calculate original base consumption
    final baseConsumption = type == ChallengeType.weekly
        ? ConsumptionEstimationService.estimateWeeklyConsumption(householdMembers)
        : ConsumptionEstimationService.estimateMonthlyConsumption(householdMembers);

    // Calculate cumulative reduction
    final newCompletionCount = previousChallenge.completionCount + 1;
    final cumulativeReduction = defaultReductionPercentage +
        (progressiveReductionPercentage * newCompletionCount);

    // Apply minimum threshold
    final maxReduction = cumulativeReduction > maximumReductionPercentage
        ? maximumReductionPercentage
        : cumulativeReduction;

    final targetConsumption = ConsumptionEstimationService.calculateTargetWithReduction(
      baseConsumption,
      maxReduction,
    );

    final now = DateTime.now();
    final duration = type == ChallengeType.weekly ? 7 : 30;
    final endDate = now.add(Duration(days: duration));

    return Challenge(
      id: uuid.v4(),
      typeIndex: type.index,
      targetConsumption: targetConsumption,
      reductionPercentage: maxReduction,
      startDate: now,
      endDate: endDate,
      isActive: true,
      isCompleted: false,
      completionCount: newCompletionCount,
    );
  }

  /// Complete a challenge and return the updated challenge
  static Challenge completeChallenge(Challenge challenge) {
    return challenge.copyWith(
      isCompleted: true,
      isActive: false,
      endDate: DateTime.now(),
    );
  }

  /// Pause a challenge
  static Challenge pauseChallenge(Challenge challenge) {
    return challenge.copyWith(
      isPaused: true,
      pauseStartDate: DateTime.now(),
    );
  }

  /// Resume a paused challenge
  static Challenge resumeChallenge(Challenge challenge) {
    if (!challenge.isPaused || challenge.pauseStartDate == null) {
      return challenge;
    }

    // Calculate pause duration
    final pauseDuration = DateTime.now().difference(challenge.pauseStartDate!);

    // Extend end date by pause duration
    final newEndDate = challenge.endDate?.add(pauseDuration);

    return challenge.copyWith(
      isPaused: false,
      pauseStartDate: null,
      endDate: newEndDate,
    );
  }

  /// Check if a challenge should be automatically completed
  static bool shouldAutoComplete(Challenge challenge, double actualConsumption) {
    if (!challenge.isActive || challenge.isCompleted || challenge.isPaused) {
      return false;
    }

    if (challenge.endDate == null) return false;

    // Check if challenge period has ended
    final now = DateTime.now();
    if (now.isBefore(challenge.endDate!)) {
      return false;
    }

    // Check if target was met
    return actualConsumption <= challenge.targetConsumption;
  }

  /// Calculate challenge success rate
  static double calculateSuccessRate(int completedChallenges, int totalChallenges) {
    if (totalChallenges == 0) return 0.0;
    return (completedChallenges / totalChallenges) * 100;
  }

  /// Get challenge difficulty level based on reduction percentage
  static String getChallengeDifficulty(double reductionPercentage) {
    if (reductionPercentage < 5) return 'Easy';
    if (reductionPercentage < 10) return 'Medium';
    if (reductionPercentage < 20) return 'Hard';
    return 'Expert';
  }

  /// Check if maximum savings has been reached
  static bool hasReachedMaxSavings(double reductionPercentage) {
    return reductionPercentage >= maximumReductionPercentage;
  }
}
