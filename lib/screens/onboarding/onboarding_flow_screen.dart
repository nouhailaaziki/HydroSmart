import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/water_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/challenge_model.dart';
import '../../models/household_member_model.dart';
import '../../theme/app_colors.dart';
import '../../main.dart' show MainNavigationShell;
import 'onboarding_language_screen.dart';
import 'onboarding_name_screen.dart';
import 'onboarding_age_screen.dart';
import 'onboarding_household_screen.dart';
import 'onboarding_meter_screen.dart';
import 'onboarding_challenge_screen.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  bool? _languageSelected;
  String? _name;
  int? _age;
  List<HouseholdMember>? _householdMembers;
  double? _initialMeterReading;
  TimeOfDay? _notificationTime;

  // Delay to allow SnackBar to be visible before navigation
  static const Duration _navigationDelay = Duration(milliseconds: 500);

  // Helper method to navigate to home screen
  Future<void> _navigateToHome() async {
    await Future.delayed(_navigationDelay);
    if (mounted) {
      // Use pushAndRemoveUntil to prevent back navigation to onboarding
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigationShell()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Step 0: Language Selection (only if not yet selected in this session,
    // and not previously saved in storage)
    if (_languageSelected != true && !languageProvider.hasSelectedLanguage) {
      return LanguageSelectionScreen(
        onLanguageSelected: () {
          setState(() => _languageSelected = true);
        },
      );
    }

    // Step 1: Name
    if (_name == null) {
      return OnboardingNameScreen(
        onNameSubmitted: (name) {
          setState(() => _name = name);
        },
      );
    }

    // Step 2: Age
    if (_age == null) {
      return OnboardingAgeScreen(
        userName: _name!,
        onAgeSubmitted: (age) {
          setState(() => _age = age);
        },
      );
    }

    // Step 3: Household
    if (_householdMembers == null) {
      return OnboardingHouseholdScreen(
        userName: _name!,
        userAge: _age!,
        onHouseholdSubmitted: (members) {
          setState(() => _householdMembers = members);
        },
      );
    }

    // Step 4: Meter Setup
    if (_initialMeterReading == null || _notificationTime == null) {
      return OnboardingMeterScreen(
        onMeterSubmitted: (reading, time) {
          setState(() {
            _initialMeterReading = reading;
            _notificationTime = time;
          });
        },
      );
    }

    // Step 5: Challenge Selection (Final step)
    return OnboardingChallengeScreen(
      onChallengeSelected: (type) async {
        await _completeOnboarding(type);
      },
    );
  }

  Future<void> _completeOnboarding(ChallengeType challengeType) async {
    bool loadingShown = false;
    bool hasErrors = false;

    // Capture the root navigator and providers before any async gaps so that
    // stale BuildContext issues cannot occur after awaits.
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final authProvider = context.read<AuthProvider>();
    final waterProvider = context.read<WaterProvider>();

    try {
      // Show non-dismissible loading dialog via the root navigator so that
      // rootNavigator.pop() always targets it.  PopScope prevents the back
      // button from dismissing the overlay mid-completion.
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (_) => const PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      );
      loadingShown = true;

      // Update auth provider with onboarding data
      try {
        await authProvider.completeOnboarding(
          name: _name!,
          age: _age!,
          householdMembers: _householdMembers!,
        );
      } catch (e) {
        debugPrint('Error completing auth onboarding: $e');
        hasErrors = true;
      }

      // Set up water tracking
      try {
        await waterProvider.setInitialMeterReading(_initialMeterReading!);
      } catch (e) {
        debugPrint('Error setting initial meter reading: $e');
        hasErrors = true;
      }

      try {
        await waterProvider.setNotificationTime(_notificationTime!);
      } catch (e) {
        debugPrint('Error setting notification time: $e');
        hasErrors = true;
      }

      try {
        await waterProvider.updateHouseholdMembers(_householdMembers!);
      } catch (e) {
        debugPrint('Error updating household members: $e');
        hasErrors = true;
      }

      // Start the challenge
      try {
        await waterProvider.startChallenge(challengeType);
      } catch (e) {
        debugPrint('Error starting challenge: $e');
        hasErrors = true;
      }
    } catch (e) {
      debugPrint('Error in _completeOnboarding: $e');
      hasErrors = true;
    } finally {
      // Always close the loading dialog using the pre-captured root navigator
      // so the correct route is targeted regardless of any widget rebuilds.
      if (loadingShown) {
        if (rootNavigator.canPop()) {
          rootNavigator.pop();
          debugPrint('Onboarding loading dialog dismissed.');
        } else {
          debugPrint('Warning: onboarding dialog shown but canPop() is false.');
        }
      }
    }

    // Wait for the post-frame callback so the dialog route has been fully
    // removed from the navigator stack before we push the home screen.
    final frameCompleter = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => frameCompleter.complete());
    await frameCompleter.future;

    // Show appropriate message and navigate only after the dialog is closed.
    if (mounted) {
      if (hasErrors) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Setup completed with some errors. You can continue using the app.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome to Hydrosmart! 🎉'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      await _navigateToHome();
    }
  }
}