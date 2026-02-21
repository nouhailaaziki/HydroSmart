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
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_of_service_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';
import 'utils/constants.dart';
import 'l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.translate('settings'), style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),

          // New Features Section
          _buildSectionHeader(loc.translate('water_tracking')),
          const SizedBox(height: 12),
          _buildNavigationTile(
            loc.translate('household_members'),
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
            loc.translate('challenge_management'),
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
          _buildSectionHeader(loc.translate('preferences')),
          const SizedBox(height: 12),
          _buildToggleOption(loc.translate('dark_mode'), themeProvider.isDarkMode, (value) => themeProvider.setTheme(value)),
          _buildToggleOption(loc.translate('leak_detection'), waterProvider.leakDetectionEnabled, waterProvider.toggleLeakDetection),

          // Notifications Settings
          _buildNotificationsSection(waterProvider),
          const SizedBox(height: 24),

          // Language Selection
          _buildSectionHeader(loc.translate('language')),
          const SizedBox(height: 12),
          _buildLanguageSelector(languageProvider),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader(loc.translate('account')),
          const SizedBox(height: 12),
          _buildProfileButton(context),
          const SizedBox(height: 12),
          _buildLogoutButton(context),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(loc.translate('about')),
          const SizedBox(height: 12),
          _buildInfoTile(loc.translate('app_version'), AppConstants.appVersion),
          _buildActionTile(loc.translate('privacy_policy'), Icons.policy, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
            );
          }),
          _buildActionTile(loc.translate('terms_of_service'), Icons.description, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.getHeading3(context),
    );
  }

  Widget _buildNotificationsSection(WaterProvider provider) {
    final loc = AppLocalizations.of(context);
    return ExpansionTile(
      title: Text(
        loc.translate('notifications'),
        style: AppTextStyles.getBody(context),
      ),
      leading: Icon(Icons.notifications_outlined, color: AppColors.primary),
      trailing: Switch(
        value: provider.notificationsEnabled,
        activeColor: AppColors.primary,
        onChanged: provider.toggleNotifications,
      ),
      children: [
        _buildToggleOption(loc.translate('daily_usage_reminders'), true, (value) {}),
        _buildToggleOption(loc.translate('goal_achievement_alerts'), true, (value) {}),
        _buildToggleOption(loc.translate('leak_alerts'), true, (value) {}),
        _buildToggleOption(loc.translate('vacation_mode_alerts'), true, (value) {}),
      ],
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 24,
      blur: 24,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x201A73E8),
          Color(0x101A73E8),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.12),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.language, color: AppColors.primary),
        title: Text(loc.translate('language'), style: AppTextStyles.getBody(context)),
        trailing: DropdownButton<String>(
          value: languageProvider.currentLanguage,
          dropdownColor: isDark ? AppColors.backgroundDark : AppColors.lightCyanSurface,
          style: AppTextStyles.getBody(context),
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
      title: Text(title, style: AppTextStyles.getBody(context)),
      trailing: Switch(
        value: val,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 24,
      blur: 24,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x201A73E8),
          Color(0x101A73E8),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.12),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.person_outline, color: AppColors.primary),
        title: Text(AppLocalizations.of(context).translate('edit_profile'), style: AppTextStyles.getBody(context)),
        trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : AppColors.lightPrimaryText.withOpacity(0.4), size: 16),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 24,
      blur: 24,
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
        title: Text(
          AppLocalizations.of(context).translate('logout'),
          style: GoogleFonts.poppins(color: isDark ? Colors.white : AppColors.lightPrimaryText),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.white54 : AppColors.lightPrimaryText.withOpacity(0.4),
          size: 16,
        ),
        onTap: () {
          final loc = AppLocalizations.of(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? AppColors.navyMid : AppColors.lightCyanSurface,
              title: Text(
                loc.translate('logout'),
                style: GoogleFonts.poppins(color: isDark ? Colors.white : AppColors.lightPrimaryText),
              ),
              content: Text(
                loc.translate('logout_confirm'),
                style: TextStyle(color: isDark ? Colors.white70 : AppColors.lightPrimaryText.withOpacity(0.7)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    loc.translate('cancel'),
                    style: TextStyle(color: isDark ? Colors.white70 : AppColors.lightPrimaryText.withOpacity(0.7)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  },
                  child: Text(loc.translate('logout'), style: TextStyle(color: Colors.white)),
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
      title: Text(title, style: AppTextStyles.getBody(context)),
      trailing: Text(
        value,
        style: AppTextStyles.getCaption(context).copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.getBody(context)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isDark ? Colors.white54 : AppColors.lightPrimaryText.withOpacity(0.4),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNavigationTile(String title, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 24,
      blur: 24,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x201A73E8),
          Color(0x101A73E8),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.12),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.getBody(context)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.white54 : AppColors.lightPrimaryText.withOpacity(0.4),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}