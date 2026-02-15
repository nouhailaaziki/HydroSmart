import 'package:flutter/material.dart';
import '../services/water_service.dart';

class WaterProvider with ChangeNotifier {
  final WaterService _service = WaterService();
  double _currentUsage = 14.0;
  double _weeklyGoal = 20.0;
  bool _isLeakDetected = false;
  bool _leakDetectionEnabled = true;
  bool _notificationsEnabled = true;

  double get currentUsage => _currentUsage;
  double get weeklyGoal => _weeklyGoal;
  bool get isLeakDetected => _isLeakDetected;
  bool get leakDetectionEnabled => _leakDetectionEnabled;
  bool get notificationsEnabled => _notificationsEnabled;

  WaterProvider() {
    _service.getWaterUsageStream().listen((newUsage) {
      _currentUsage = newUsage;
      _checkLeak(newUsage);
      notifyListeners();
    });
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
      _isLeakDetected = true;
    } else if (!_leakDetectionEnabled) {
      _isLeakDetected = false;
    }
  }
}