import 'package:flutter/material.dart';
import '../../models/challenge_model.dart';

class OnboardingChallengeScreen extends StatefulWidget {
  final Function(ChallengeType type) onChallengeSelected;

  const OnboardingChallengeScreen({
    Key? key,
    required this.onChallengeSelected,
  }) : super(key: key);

  @override
  State<OnboardingChallengeScreen> createState() =>
      _OnboardingChallengeScreenState();
}

class _OnboardingChallengeScreenState extends State<OnboardingChallengeScreen> {
  ChallengeType? _selectedType;

  void _submit() {
    if (_selectedType != null) {
      widget.onChallengeSelected(_selectedType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF001529)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: Colors.cyanAccent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Choose your challenge',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Start saving water with a personalized goal',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildChallengeCard(
                          type: ChallengeType.weekly,
                          title: 'Weekly Challenge',
                          description: '7-day water saving goal',
                          icon: Icons.calendar_view_week,
                          duration: '1 week',
                        ),
                        const SizedBox(height: 16),
                        _buildChallengeCard(
                          type: ChallengeType.monthly,
                          title: 'Monthly Challenge',
                          description: '30-day water saving goal',
                          icon: Icons.calendar_month,
                          duration: '1 month',
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.cyanAccent,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Progressive Challenges',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Each time you complete a challenge, your next goal will be slightly more ambitious, helping you save even more water!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedType != null ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedType != null
                          ? Colors.cyanAccent
                          : Colors.grey,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start My Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard({
    required ChallengeType type,
    required String title,
    required String description,
    required IconData icon,
    required String duration,
  }) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyanAccent.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.cyanAccent,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.cyanAccent,
                    size: 28,
                  )
                else
                  Icon(
                    Icons.circle_outlined,
                    color: Colors.white.withOpacity(0.3),
                    size: 28,
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
