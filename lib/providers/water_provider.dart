import 'package:flutter/material.dart';
import '../services/water_service.dart';
import '../models/achievement_model.dart';
import '../models/usage_record_model.dart';
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
    // Initialize with some sample data for the last 7 days
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      _usageHistory.add(UsageRecord(
        date: now.subtract(Duration(days: i)),
        usage: 2.0 + (i * 0.5),
        goal: 3.0,
      ));
    }
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
        // Vacation mode should be prompted
        // This will be handled by the UI
      }
    }
  }

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
}