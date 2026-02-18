import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/water_provider.dart';
import '../../models/challenge_model.dart';
import '../../models/household_member_model.dart';
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
  String? _name;
  int? _age;
  List<HouseholdMember>? _householdMembers;
  double? _initialMeterReading;
  TimeOfDay? _notificationTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
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
    
    try {
      // Show loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.cyanAccent,
            ),
          ),
        );
        loadingShown = true;
      }

      final authProvider = context.read<AuthProvider>();
      final waterProvider = context.read<WaterProvider>();

      // Update auth provider with onboarding data
      try {
        await authProvider.completeOnboarding(
          name: _name!,
          age: _age!,
          householdMembers: _householdMembers!,
        );
      } catch (e) {
        debugPrint('Error completing auth onboarding: $e');
        // Continue anyway as this is not critical
      }

      // Set up water tracking
      try {
        await waterProvider.setInitialMeterReading(_initialMeterReading!);
      } catch (e) {
        debugPrint('Error setting initial meter reading: $e');
      }

      try {
        await waterProvider.setNotificationTime(_notificationTime!);
      } catch (e) {
        debugPrint('Error setting notification time: $e');
        // Continue anyway
      }

      try {
        await waterProvider.updateHouseholdMembers(_householdMembers!);
      } catch (e) {
        debugPrint('Error updating household members: $e');
      }

      // Start the challenge
      try {
        await waterProvider.startChallenge(challengeType);
      } catch (e) {
        debugPrint('Error starting challenge: $e');
        // Continue anyway
      }

      // Close loading dialog
      if (mounted && loadingShown) {
        Navigator.of(context).pop();
        loadingShown = false;

        // Show success message
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF001529),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.celebration, color: Colors.cyanAccent, size: 32),
                SizedBox(width: 12),
                Text(
                  'All Set!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: Text(
              'Your water-saving journey begins now. Let\'s make every drop count!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Let\'s Go!'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in _completeOnboarding: $e');
      
      // Close loading dialog if open
      if (mounted && loadingShown) {
        try {
          Navigator.of(context).pop();
        } catch (e) {
          debugPrint('Error closing loading dialog: $e');
        }

        // Show error but still allow navigation to continue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup partially completed. You can continue using the app.'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
