import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'en';
  
  String get currentLanguage => _currentLanguage;
  
  Locale get currentLocale {
    switch (_currentLanguage) {
      case 'ar':
        return Locale('ar');
      case 'fr':
        return Locale('fr');
      default:
        return Locale('en');
    }
  }
  
  bool get isRTL => _currentLanguage == 'ar';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final box = await Hive.openBox('settings');
      _currentLanguage = box.get('language', defaultValue: 'en');
      notifyListeners();
    } catch (e) {
      _currentLanguage = 'en';
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    try {
      final box = await Hive.openBox('settings');
      await box.put('language', languageCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
    notifyListeners();
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }
}
