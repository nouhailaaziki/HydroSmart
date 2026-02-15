import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;

  void login(String email, String password) {
    _user = AppUser(
      id: "123",
      name: email.split('@')[0],
      email: email,
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}