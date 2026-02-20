import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'en';
  bool _hasSelectedLanguage = false;

  String get currentLanguage => _currentLanguage;
  bool get hasSelectedLanguage => _hasSelectedLanguage;

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
      _hasSelectedLanguage = box.containsKey('language');
      _currentLanguage = box.get('language', defaultValue: 'en');
      notifyListeners();
    } catch (e) {
      _currentLanguage = 'en';
      _hasSelectedLanguage = false;
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      final box = await Hive.openBox('settings');
      await box.put('language', languageCode);
      _currentLanguage = languageCode;
      _hasSelectedLanguage = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
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