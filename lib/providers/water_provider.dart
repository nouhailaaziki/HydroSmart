import 'package:flutter/material.dart';
import '../services/water_service.dart';

class WaterProvider with ChangeNotifier {
  final WaterService _service = WaterService();
  double _currentUsage = 14.0;
  double _weeklyGoal = 20.0;
  bool _isLeakDetected = false;

  double get currentUsage => _currentUsage;
  double get weeklyGoal => _weeklyGoal;
  bool get isLeakDetected => _isLeakDetected;

  WaterProvider() {
    _service.getWaterUsageStream().listen((newUsage) {
      _currentUsage = newUsage;

      if (newUsage > 25.0) _isLeakDetected = true;

      notifyListeners();
    });
  }

  void updateGoal(double newGoal) {
    _weeklyGoal = newGoal;
    notifyListeners();
  }
}