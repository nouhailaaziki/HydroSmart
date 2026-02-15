import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Preferences", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          _buildGoalSetter(waterProvider),
          const SizedBox(height: 20),
          _buildToggleOption("Leak Detection", waterProvider.leakDetectionEnabled, waterProvider.toggleLeakDetection),
          _buildToggleOption("Smart Notifications", waterProvider.notificationsEnabled, waterProvider.toggleNotifications),
        ],
      ),
    );
  }

  Widget _buildGoalSetter(WaterProvider provider) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 150,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Weekly Goal: ${provider.weeklyGoal.toInt()}L",
              style: const TextStyle(fontSize: 20, color: Colors.white)),
          Slider(
            value: provider.weeklyGoal,
            min: 5,
            max: 100,
            divisions: 19,
            activeColor: Colors.cyanAccent,
            onChanged: (val) => provider.updateGoal(val),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String title, bool val, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(value: val, activeColor: Colors.cyanAccent, onChanged: onChanged),
    );
  }
}