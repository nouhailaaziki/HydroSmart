import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../models/household_member_model.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;
  Box? _userBox;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get hasCompletedOnboarding => _user?.hasCompletedOnboarding ?? false;

  /// Initialize the auth provider
  Future<void> initialize() async {
    _userBox = await Hive.openBox('user');
    await _loadUser();
  }

  /// Load user from storage
  Future<void> _loadUser() async {
    final userData = _userBox?.get('current_user');
    if (userData != null) {
      _user = AppUser.fromMap(Map<String, dynamic>.from(userData));
      notifyListeners();
    }
  }

  /// Save user to storage
  Future<void> _saveUser() async {
    if (_user != null) {
      await _userBox?.put('current_user', _user!.toMap());
    }
  }

  void login(String email, String password) {
    _user = AppUser(
      id: "123",
      name: email.split('@')[0],
      email: email,
    );
    _saveUser();
    notifyListeners();
  }

  /// Update user with onboarding completion
  Future<void> completeOnboarding({
    required String name,
    required int age,
    required List householdMembers,
  }) async {
    if (_user == null) return;

    _user = _user!.copyWith(
      name: name,
      age: age,
      householdMembers: householdMembers.cast<HouseholdMember>(),
      hasCompletedOnboarding: true,
    );
    await _saveUser();
    notifyListeners();
  }

  /// Update user profile
  Future<void> updateUser(AppUser updatedUser) async {
    _user = updatedUser;
    await _saveUser();
    notifyListeners();
  }

  /// Update household members
  Future<void> updateHouseholdMembers(List householdMembers) async {
    if (_user == null) return;

    _user = _user!.copyWith(householdMembers: householdMembers.cast<HouseholdMember>(),);
    await _saveUser();
    notifyListeners();
  }

  void logout() {
    _user = null;
    _userBox?.delete('current_user');
    notifyListeners();
  }

  /// Clear all auth data
  Future<void> clearData() async {
    await _userBox?.clear();
    _user = null;
    notifyListeners();
  }
}