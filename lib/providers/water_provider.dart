import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/water_service.dart';
import '../models/achievement_model.dart';
import '../models/usage_record_model.dart';
import '../models/water_meter_reading_model.dart';
import '../models/challenge_model.dart';
import '../models/household_member_model.dart';
import '../models/user_settings_model.dart';
import '../services/challenge_service.dart';
import '../services/consumption_estimation_service.dart';
import '../services/data_recalculation_service.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class WaterProvider with ChangeNotifier {
  final WaterService _service = WaterService();
  double _currentUsage = 14.0;
  double _weeklyGoal = 20.0;
  bool _isLeakDetected = false;
  bool _leakDetectionEnabled = true;
  bool _notificationsEnabled = true;

  // Gamification
  int _totalPoints = 0;
  int _currentStreak = 0;
  double _totalWaterSaved = 0.0;
  List<Achievement> _achievements = Achievement.getDefaultAchievements();
  List<UsageRecord> _usageHistory = [];
  int _aiInteractions = 0;

  // Vacation Mode
  bool _vacationModeActive = false;
  List<double> _dailyReadings = [];
  DateTime? _lastReadingDate;

  // Meter Readings & Challenges
  List<WaterMeterReading> _meterReadings = [];
  Challenge? _currentChallenge;
  UserSettings? _userSettings;
  List<HouseholdMember> _householdMembers = [];
  Box? _readingsBox;
  Box? _challengeBox;
  Box? _settingsBox;
  final NotificationService _notificationService = NotificationService();

  // Getters
  double get currentUsage => _currentUsage;
  double get weeklyGoal => _weeklyGoal;
  bool get isLeakDetected => _isLeakDetected;
  bool get leakDetectionEnabled => _leakDetectionEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  int get totalPoints => _totalPoints;
  int get currentStreak => _currentStreak;
  double get totalWaterSaved => _totalWaterSaved;
  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();
  List<UsageRecord> get usageHistory => _usageHistory;
  bool get vacationModeActive => _vacationModeActive;
  int get aiInteractions => _aiInteractions;
  List<WaterMeterReading> get meterReadings => _meterReadings;
  Challenge? get currentChallenge => _currentChallenge;
  UserSettings? get userSettings => _userSettings;
  List<HouseholdMember> get householdMembers => _householdMembers;
  bool get hasMeterReadings => _meterReadings.isNotEmpty;
  WaterMeterReading? get lastMeterReading =>
      _meterReadings.isNotEmpty ? _meterReadings.last : null;
  double? get lastMeterValue => lastMeterReading?.meterValue;
  bool get hasActiveChallenge => _currentChallenge?.isActive ?? false;
  bool get isChallengePaused => _currentChallenge?.isPaused ?? false;

  WaterProvider() {
    _service.getWaterUsageStream().listen((newUsage) {
      _currentUsage = newUsage;
      _checkLeak(newUsage);
      _trackDailyReading(newUsage);
      notifyListeners();
    });
    _initializeUsageHistory();
  }

  void _initializeUsageHistory() {
    // This will be populated from real meter readings
    // Initialize empty for now
    _usageHistory = [];
  }

  /// Get last seven days usage from actual meter readings
  List<UsageRecord> getLastSevenDays() {
    // If we don't have enough meter readings, return empty/partial data
    if (_meterReadings.isEmpty) {
      // Return placeholder data for the last 7 days
      final now = DateTime.now();
      return List.generate(7, (i) {
        return UsageRecord(
          date: now.subtract(Duration(days: 6 - i)),
          usage: 0.0,
          goal: 3.0,
        );
      });
    }

    // Get readings from the last 7 days
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    final recentReadings = _meterReadings
        .where((r) => r.timestamp.isAfter(sevenDaysAgo))
        .toList();

    // Create usage records for each day
    final Map<String, double> dailyUsage = {};
    
    // Calculate daily consumption from consecutive readings
    for (var i = 0; i < recentReadings.length; i++) {
      final reading = recentReadings[i];
      final dateKey = _getDateKey(reading.timestamp);
      
      if (reading.dailyConsumption != null) {
        dailyUsage[dateKey] = (dailyUsage[dateKey] ?? 0.0) + reading.dailyConsumption!;
      }
    }

    // Generate list for last 7 days
    final records = <UsageRecord>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);
      final usage = dailyUsage[dateKey] ?? 0.0;
      
      records.add(UsageRecord(
        date: date,
        usage: usage,
        goal: _weeklyGoal / 7, // Daily goal
      ));
    }

    return records;
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void updateGoal(double newGoal) {
    _weeklyGoal = newGoal;
    notifyListeners();
  }

  void toggleLeakDetection(bool value) {
    _leakDetectionEnabled = value;
    if (!value) _isLeakDetected = false;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void _checkLeak(double usage) {
    if (_leakDetectionEnabled && usage > 25.0) {
      if (!_isLeakDetected) {
        _isLeakDetected = true;
        _unlockAchievement('leak_detective');
      }
    } else if (!_leakDetectionEnabled) {
      _isLeakDetected = false;
    }
  }

  // Vacation Mode Detection
  void _trackDailyReading(double reading) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastReadingDate == null || _lastReadingDate != today) {
      _dailyReadings.add(reading);
      _lastReadingDate = today;

      if (_dailyReadings.length > AppConstants.vacationModeThresholdDays) {
        _dailyReadings.removeAt(0);
      }

      _checkVacationMode();
    }
  }

  void _checkVacationMode() {
    if (_dailyReadings.length >= AppConstants.vacationModeThresholdDays) {
      final recentReadings = _dailyReadings.sublist(
          _dailyReadings.length - AppConstants.vacationModeThresholdDays
      );

      // Check if all readings are identical (zero usage)
      final allSame = recentReadings.every(
              (reading) => (reading - recentReadings.first).abs() < 0.1
      );

      if (allSame && !_vacationModeActive) {

  void enableVacationMode() {
    _vacationModeActive = true;
    notifyListeners();
  }

  void disableVacationMode() {
    _vacationModeActive = false;
    notifyListeners();
  }

  // Points System
  void addPoints(int points) {
    _totalPoints += points;
    notifyListeners();
  }

  void incrementAIInteractions() {
    _aiInteractions++;
    addPoints(AppConstants.pointsAIInteraction);

    if (_aiInteractions >= 50) {
      _unlockAchievement('ai_friend');
    }
    notifyListeners();
  }

  void recordDailyGoalAchievement() {
    addPoints(AppConstants.pointsPerDailyGoal);
    _currentStreak++;

    if (_currentStreak == 7) {
      addPoints(AppConstants.pointsPerStreakDay);
      _unlockAchievement('hot_streak');
    }

    if (_currentStreak == 30) {
      _unlockAchievement('consistency_king');
    }

    notifyListeners();
  }

  void recordWeeklyGoalCompletion() {
    addPoints(AppConstants.pointsPerWeeklyGoal);
    _unlockAchievement('water_warrior');

    // Reduce next week's goal by 5-10%
    _adjustGoalAfterSuccess();
    notifyListeners();
  }

  void _adjustGoalAfterSuccess() {
    final reduction = _weeklyGoal * AppConstants.goalReductionPercentage;
    _weeklyGoal = (_weeklyGoal - reduction).clamp(
      AppConstants.minWeeklyGoal,
      AppConstants.maxWeeklyGoal,
    );
  }

  void updateWaterSaved(double liters) {
    _totalWaterSaved += liters;
    final pointsEarned = (liters * AppConstants.pointsPerLiterSaved).toInt();
    addPoints(pointsEarned);

    if (_totalWaterSaved >= 100) {
      _unlockAchievement('drop_by_drop');
    }

    if (_totalWaterSaved >= 1000) {
      _unlockAchievement('eco_hero');
    }

    notifyListeners();
  }

  void _unlockAchievement(String achievementId) {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index != -1 && !_achievements[index].isUnlocked) {
      _achievements[index] = _achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void addUsageRecord(UsageRecord record) {
    _usageHistory.add(record);
    if (_usageHistory.length > 30) {
      _usageHistory.removeAt(0);
    }
    notifyListeners();
  }

  List<UsageRecord> getLastSevenDays() {
    if (_usageHistory.length < 7) return _usageHistory;
    return _usageHistory.sublist(_usageHistory.length - 7);
  }

  // ========== NEW METHODS FOR ONBOARDING & CHALLENGES ==========

  /// Initialize provider with Hive boxes
  Future<void> initialize() async {
    _readingsBox = await Hive.openBox('meter_readings');
    _challengeBox = await Hive.openBox('challenges');
    _settingsBox = await Hive.openBox('user_settings');

    await _loadMeterReadings();
    await _loadCurrentChallenge();
    await _loadUserSettings();
    await _notificationService.initialize();

    // Check for inactive user on app open
    await _checkForInactivity();
  }

  /// Load meter readings from storage
  Future<void> _loadMeterReadings() async {
    final readings = _readingsBox?.values.toList() ?? [];
    _meterReadings = readings
        .map((r) => WaterMeterReading.fromMap(Map<String, dynamic>.from(r)))
        .toList();
    _meterReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Load current challenge from storage
  Future<void> _loadCurrentChallenge() async {
    final challengeData = _challengeBox?.get('current_challenge');
    if (challengeData != null) {
      _currentChallenge = Challenge.fromMap(Map<String, dynamic>.from(challengeData));
    }
  }

  /// Load user settings from storage
  Future<void> _loadUserSettings() async {
    final settingsData = _settingsBox?.get('settings');
    if (settingsData != null) {
      _userSettings = UserSettings.fromMap(Map<String, dynamic>.from(settingsData));
    } else {
      _userSettings = UserSettings();
    }
  }

  /// Save meter reading
  Future<void> _saveMeterReading(WaterMeterReading reading) async {
    await _readingsBox?.put(reading.id, reading.toMap());
  }

  /// Save current challenge
  Future<void> _saveCurrentChallenge() async {
    if (_currentChallenge != null) {
      await _challengeBox?.put('current_challenge', _currentChallenge!.toMap());
    }
  }

  /// Save user settings
  Future<void> _saveUserSettings() async {
    if (_userSettings != null) {
      await _settingsBox?.put('settings', _userSettings!.toMap());
    }
  }

  /// Add a meter reading
  Future<void> addMeterReading(double meterValue) async {
    final now = DateTime.now();
    double? dailyConsumption;

    // Calculate daily consumption if we have a previous reading
    if (_meterReadings.isNotEmpty) {
      final lastReading = _meterReadings.last;
      dailyConsumption = meterValue - lastReading.meterValue;

      // Validate the reading
      final validation = DataRecalculationService.validateMeterReading(
        newReading: meterValue,
        previousReading: lastReading.meterValue,
        previousDate: lastReading.timestamp,
        newDate: now,
      );

      if (validation['isValid'] == false) {
        throw Exception(validation['errors']?.first ?? 'Invalid meter reading');
      }
    }

    final reading = WaterMeterReading(
      id: 'reading_${now.millisecondsSinceEpoch}',
      timestamp: now,
      meterValue: meterValue,
      dailyConsumption: dailyConsumption,
    );

    _meterReadings.add(reading);
    await _saveMeterReading(reading);

    // Update last reading date in settings
    _userSettings = _userSettings?.copyWith(lastReadingDate: now);
    await _saveUserSettings();

    // Check challenge progress
    await _checkChallengeProgress();

    notifyListeners();
  }

  /// Set initial meter reading (during onboarding)
  Future<void> setInitialMeterReading(double meterValue) async {
    final now = DateTime.now();
    final reading = WaterMeterReading(
      id: 'reading_${now.millisecondsSinceEpoch}',
      timestamp: now,
      meterValue: meterValue,
    );

    _meterReadings = [reading];
    await _saveMeterReading(reading);

    _userSettings = _userSettings?.copyWith(
      initialMeterReading: meterValue,
      lastReadingDate: now,
    );
    await _saveUserSettings();

    notifyListeners();
  }

  /// Set notification time
  Future<void> setNotificationTime(TimeOfDay time) async {
    _userSettings = _userSettings?.copyWith(
      notificationHour: time.hour,
      notificationMinute: time.minute,
    );
    await _saveUserSettings();

    // Schedule the notification
    if (_notificationsEnabled) {
      await _notificationService.scheduleDailyMeterReading(time: time);
    }

    notifyListeners();
  }

  /// Update household members
  Future<void> updateHouseholdMembers(List<HouseholdMember> members) async {
    _householdMembers = members;

    // Record household change for data integrity
    DataRecalculationService.recordHouseholdChange(members);

    // Recalculate current challenge if active
    if (_currentChallenge != null && _currentChallenge!.isActive) {
      _currentChallenge = DataRecalculationService.recalculateChallenge(
        _currentChallenge!,
        members,
      );
      await _saveCurrentChallenge();
    }

    notifyListeners();
  }

  /// Start a new challenge
  Future<void> startChallenge(ChallengeType type) async {
    if (_householdMembers.isEmpty) {
      throw Exception('Please set up your household first');
    }

    final previousCompletions = _currentChallenge?.completionCount ?? 0;

    _currentChallenge = ChallengeService.createChallenge(
      type: type,
      householdMembers: _householdMembers,
      previousCompletions: previousCompletions,
    );

    await _saveCurrentChallenge();
    notifyListeners();
  }

  /// Complete current challenge and start a new progressive one
  Future<void> completeCurrentChallenge() async {
    if (_currentChallenge == null || !_currentChallenge!.isActive) {
      return;
    }

    // Mark as completed
    _currentChallenge = ChallengeService.completeChallenge(_currentChallenge!);
    await _saveCurrentChallenge();

    // Award points
    addPoints(AppConstants.pointsPerWeeklyGoal * 2);

    // Create progressive challenge
    _currentChallenge = ChallengeService.createProgressiveChallenge(
      previousChallenge: _currentChallenge!,
      householdMembers: _householdMembers,
    );

    await _saveCurrentChallenge();
    notifyListeners();
  }

  /// Fail current challenge and restart with same goal (no reduction)
  Future<void> failCurrentChallenge() async {
    if (_currentChallenge == null || !_currentChallenge!.isActive) {
      return;
    }

    final failedChallenge = _currentChallenge!;

    // Mark as not completed (failed)
    _currentChallenge = ChallengeService.completeChallenge(failedChallenge).copyWith(
      isCompleted: false,
    );
    await _saveCurrentChallenge();

    // Restart same challenge without reduction (keep same completion count)
    _currentChallenge = ChallengeService.createChallenge(
      type: failedChallenge.type,
      householdMembers: _householdMembers,
      customReduction: failedChallenge.reductionPercentage,
      previousCompletions: failedChallenge.completionCount, // Don't increment
    );

    await _saveCurrentChallenge();
    notifyListeners();
  }

  /// Pause current challenge
  Future<void> pauseChallenge() async {
    if (_currentChallenge == null || !_currentChallenge!.isActive) {
      return;
    }

    _currentChallenge = ChallengeService.pauseChallenge(_currentChallenge!);
    await _saveCurrentChallenge();

    // Switch to motivational notifications
    if (_userSettings != null) {
      await _notificationService.scheduleMotivationalNotification(
        time: _userSettings!.notificationTime,
      );
    }

    notifyListeners();
  }

  /// Resume paused challenge
  Future<void> resumeChallenge() async {
    if (_currentChallenge == null || !_currentChallenge!.isPaused) {
      return;
    }

    _currentChallenge = ChallengeService.resumeChallenge(_currentChallenge!);
    await _saveCurrentChallenge();

    // Switch back to meter reading notifications
    if (_userSettings != null) {
      await _notificationService.scheduleDailyMeterReading(
        time: _userSettings!.notificationTime,
      );
    }

    notifyListeners();
  }

  /// Check challenge progress after adding a reading
  Future<void> _checkChallengeProgress() async {
    if (_currentChallenge == null ||
        !_currentChallenge!.isActive ||
        _currentChallenge!.isPaused) {
      return;
    }

    // Check if challenge period has ended
    if (_currentChallenge!.endDate == null) return;
    
    final now = DateTime.now();
    if (now.isBefore(_currentChallenge!.endDate!)) {
      return; // Challenge still ongoing
    }

    // Calculate consumption for challenge period
    final consumption = _calculateChallengeConsumption();

    // Check if target was met
    if (consumption <= _currentChallenge!.targetConsumption) {
      // Success - create progressive challenge
      await completeCurrentChallenge();
    } else {
      // Failure - restart with same goal
      await failCurrentChallenge();
    }
  }

  /// Calculate consumption for current challenge period
  double _calculateChallengeConsumption() {
    if (_currentChallenge == null || _meterReadings.length < 2) {
      return 0.0;
    }

    final startDate = _currentChallenge!.startDate;
    final readingsInPeriod = _meterReadings
        .where((r) => r.timestamp.isAfter(startDate))
        .toList();

    if (readingsInPeriod.isEmpty) return 0.0;

    return readingsInPeriod
        .map((r) => r.dailyConsumption ?? 0.0)
        .reduce((a, b) => a + b);
  }

  /// Check for inactive user (gap in app usage)
  Future<void> _checkForInactivity() async {
    if (_userSettings?.lastAppOpenDate == null) {
      _userSettings = _userSettings?.copyWith(lastAppOpenDate: DateTime.now());
      await _saveUserSettings();
      return;
    }

    final daysSinceLastOpen =
        DateTime.now().difference(_userSettings!.lastAppOpenDate!).inDays;

    // Update last app open date
    _userSettings = _userSettings?.copyWith(lastAppOpenDate: DateTime.now());
    await _saveUserSettings();

    // If more than 1 day gap, user needs to provide catch-up data
    if (daysSinceLastOpen > 1) {
      // This will be handled by UI showing WelcomeBackScreen
      debugPrint('User inactive for $daysSinceLastOpen days');
    }
  }

  /// Get days since last app open
  int getDaysSinceLastOpen() {
    if (_userSettings?.lastAppOpenDate == null) return 0;
    return DateTime.now().difference(_userSettings!.lastAppOpenDate!).inDays;
  }

  /// Handle gap in readings (when user was inactive)
  Future<void> handleReadingGap({
    required double currentMeterValue,
    bool markAsAway = false,
  }) async {
    if (_meterReadings.isEmpty) {
      await addMeterReading(currentMeterValue);
      return;
    }

    final lastReading = _meterReadings.last;
    final gapDays = DateTime.now().difference(lastReading.timestamp).inDays;

    if (gapDays <= 1) {
      // No significant gap
      await addMeterReading(currentMeterValue);
      return;
    }

    final totalConsumption = currentMeterValue - lastReading.meterValue;

    if (markAsAway) {
      // Pause challenge during this period
      if (_currentChallenge != null && _currentChallenge!.isActive) {
        await pauseChallenge();
      }
    }

    // Distribute consumption across gap days
    final distributedReadings = DataRecalculationService.distributeGapConsumption(
      totalConsumption: totalConsumption,
      startDate: lastReading.timestamp,
      endDate: DateTime.now(),
      lastMeterValue: lastReading.meterValue,
    );

    // Save distributed readings
    for (var reading in distributedReadings) {
      _meterReadings.add(reading);
      await _saveMeterReading(reading);
    }

    notifyListeners();
  }

  /// Get household water profile
  Map<String, dynamic> getHouseholdProfile() {
    return ConsumptionEstimationService.getHouseholdProfile(_householdMembers);
  }

  /// Get estimated daily consumption
  double getEstimatedDailyConsumption() {
    return ConsumptionEstimationService.estimateDailyConsumption(_householdMembers);
  }

  /// Get challenge progress percentage
  double getChallengeProgress() {
    if (_currentChallenge == null || !_currentChallenge!.isActive) {
      return 0.0;
    }

    final consumption = _calculateChallengeConsumption();
    final target = _currentChallenge!.targetConsumption;

    // Guard against division by zero
    if (target == 0.0) return 0.0;

    return (consumption / target).clamp(0.0, 1.0);
  }

  /// Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    await _readingsBox?.clear();
    await _challengeBox?.clear();
    _meterReadings.clear();
    _currentChallenge = null;
    notifyListeners();
  }
}