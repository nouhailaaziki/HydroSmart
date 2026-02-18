import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/profile_screen.dart';
import 'screens/household_settings_screen.dart';
import 'screens/challenge_management_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';
import 'utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),

          // Weekly Goal Setter
          _buildGoalSetter(waterProvider),
          const SizedBox(height: 24),

          // New Features Section
          _buildSectionHeader("Water Tracking"),
          const SizedBox(height: 12),
          _buildNavigationTile(
            "Household Members",
            Icons.family_restroom,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HouseholdSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildNavigationTile(
            "Challenge Management",
            Icons.emoji_events,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChallengeManagementScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Preferences Section
          _buildSectionHeader("Preferences"),
          const SizedBox(height: 12),
          _buildToggleOption("Leak Detection", waterProvider.leakDetectionEnabled, waterProvider.toggleLeakDetection),

          // Notifications Settings
          _buildNotificationsSection(waterProvider),
          const SizedBox(height: 24),

          // Language Selection
          _buildSectionHeader("Language"),
          const SizedBox(height: 12),
          _buildLanguageSelector(languageProvider),
          const SizedBox(height: 24),

          // Theme Mode
          _buildSectionHeader("Appearance"),
          const SizedBox(height: 12),
          _buildToggleOption("Dark Mode", themeProvider.isDarkMode, (value) {
            themeProvider.setTheme(value);
          }),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader("Account"),
          const SizedBox(height: 12),
          _buildProfileButton(context),
          const SizedBox(height: 12),
          _buildLogoutButton(context),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader("About"),
          const SizedBox(height: 12),
          _buildInfoTile("App Version", AppConstants.appVersion),
          _buildActionTile("Privacy Policy", Icons.policy, () {
            // Open privacy policy
          }),
          _buildActionTile("Terms of Service", Icons.description, () {
            // Open terms
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3,
    );
  }

  Widget _buildGoalSetter(WaterProvider provider) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 160,
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Goal",
                  style: AppTextStyles.heading3.copyWith(fontSize: 18),
                ),
                Text(
                  "${provider.weeklyGoal.toInt()}L",
                  style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            SizedBox(height: 16),
            Slider(
              value: provider.weeklyGoal,
              min: AppConstants.minWeeklyGoal,
              max: AppConstants.maxWeeklyGoal,
              divisions: 19,
              activeColor: Colors.cyanAccent,
              label: "${provider.weeklyGoal.toInt()}L",
              onChanged: (val) => provider.updateGoal(val),
            ),
            Text(
              "Adjust your weekly water usage goal",
              style: AppTextStyles.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(WaterProvider provider) {
    return ExpansionTile(
      title: Text(
        "Notifications",
        style: AppTextStyles.body,
      ),
      leading: Icon(Icons.notifications_outlined, color: AppColors.primary),
      trailing: Switch(
        value: provider.notificationsEnabled,
        activeColor: Colors.cyanAccent,
        onChanged: provider.toggleNotifications,
      ),
      children: [
        _buildToggleOption("Daily Usage Reminders", true, (value) {}),
        _buildToggleOption("Goal Achievement Alerts", true, (value) {}),
        _buildToggleOption("Leak Alerts", true, (value) {}),
        _buildToggleOption("Vacation Mode Alerts", true, (value) {}),
      ],
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 15,
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
      child: ListTile(
        leading: Icon(Icons.language, color: AppColors.primary),
        title: Text("Language", style: AppTextStyles.body),
        trailing: DropdownButton<String>(
          value: languageProvider.currentLanguage,
          dropdownColor: AppColors.backgroundDark,
          style: AppTextStyles.body,
          underline: SizedBox(),
          items: [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ar', child: Text('العربية')),
            DropdownMenuItem(value: 'fr', child: Text('Français')),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              languageProvider.setLanguage(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildToggleOption(String title, bool val, Function(bool) onChanged) {
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: Switch(
        value: val,
        activeColor: Colors.cyanAccent,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 15,
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
      child: ListTile(
        leading: Icon(Icons.person_outline, color: AppColors.primary),
        title: Text("Edit Profile", style: AppTextStyles.body),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 15,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          Colors.red.withOpacity(0.2),
          Colors.red.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.red.withOpacity(0.3),
          Colors.red.withOpacity(0.2),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.redAccent),
        title: Text("Logout", style: GoogleFonts.poppins(color: Colors.white)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Color(0xFF0D47A1),
              title: Text("Logout", style: GoogleFonts.poppins(color: Colors.white)),
              content: Text("Are you sure you want to logout?", style: TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  },
                  child: Text("Logout", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: Text(
        value,
        style: AppTextStyles.caption.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.body),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildNavigationTile(String title, IconData icon, VoidCallback onTap) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 15,
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
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.body),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: onTap,
      ),
    );
  }
}