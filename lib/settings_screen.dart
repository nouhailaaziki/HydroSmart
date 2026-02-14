import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _currentGoal = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Preferences",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildGoalSetter(),
            const SizedBox(height: 20),
            _buildToggleOption("Leak Detection", true),
            _buildToggleOption("Smart Notifications", true),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSetter() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 150,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
      borderGradient: LinearGradient(colors: [Colors.white24, Colors.white10]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Weekly Water Goal", style: GoogleFonts.poppins(color: Colors.white70)),
          Text("${_currentGoal.toInt()} Liters",
              style: GoogleFonts.poppins(color: Colors.cyanAccent, fontSize: 28, fontWeight: FontWeight.bold)),
          Slider(
            value: _currentGoal,
            min: 5,
            max: 100,
            divisions: 19,
            activeColor: Colors.cyanAccent,
            onChanged: (value) {
              setState(() => _currentGoal = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String title, bool value) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
      trailing: Switch(
        value: value,
        activeColor: Colors.cyanAccent,
        onChanged: (bool newValue) {},
      ),
    );
  }
}