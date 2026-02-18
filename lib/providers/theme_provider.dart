import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox('settings');
      _isDarkMode = box.get('isDarkMode', defaultValue: true);
      notifyListeners();
    } catch (e) {
      _isDarkMode = true;
    }
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    try {
      final box = await Hive.openBox('settings');
      await box.put('isDarkMode', isDark);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
    notifyListeners();
  }

  void toggleTheme() {
    setTheme(!_isDarkMode);
  }
}
