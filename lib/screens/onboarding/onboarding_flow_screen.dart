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
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.cyanAccent,
          ),
        ),
      );

      final authProvider = context.read<AuthProvider>();
      final waterProvider = context.read<WaterProvider>();

      // Update auth provider with onboarding data
      await authProvider.completeOnboarding(
        name: _name!,
        age: _age!,
        householdMembers: _householdMembers!,
      );

      // Set up water tracking
      await waterProvider.setInitialMeterReading(_initialMeterReading!);
      await waterProvider.setNotificationTime(_notificationTime!);
      await waterProvider.updateHouseholdMembers(_householdMembers!);

      // Start the challenge
      await waterProvider.startChallenge(challengeType);

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();

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
      // Close loading dialog if open
      if (mounted) {
        Navigator.of(context).pop();

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
