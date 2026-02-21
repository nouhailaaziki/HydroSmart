import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, loc),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              loc.translate('privacy_policy'),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return _buildLocalizedContent();
  }

  Widget _buildLocalizedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          'Effective Date: February 20, 2026',
          '',
          isDate: true,
        ),
        _buildSection(
          '1. Information We Collect',
          'HydroSmart collects water meter readings, household member information, and app usage data to provide personalized water conservation recommendations. We do not collect personally identifiable information beyond what you provide during setup.',
        ),
        _buildSection(
          '2. How We Use Your Information',
          'Your data is used exclusively to:\n• Calculate water consumption trends\n• Generate personalized conservation challenges\n• Provide AI-powered water saving tips\n• Send reminders for meter readings',
        ),
        _buildSection(
          '3. Data Storage',
          'All data is stored locally on your device using secure storage. We do not transmit your water usage data to external servers. AI chat queries are processed through secure API connections.',
        ),
        _buildSection(
          '4. Data Sharing',
          'HydroSmart does not sell, trade, or otherwise transfer your personal information to outside parties. Your data remains private and under your control.',
        ),
        _buildSection(
          '5. Your Rights',
          'You have the right to:\n• Access your stored data at any time\n• Delete all your data through the app settings\n• Export your usage history\n• Opt out of any data collection',
        ),
        _buildSection(
          '6. Security',
          'We implement industry-standard security measures to protect your data. All sensitive data is encrypted at rest on your device.',
        ),
        _buildSection(
          '7. Children\'s Privacy',
          'HydroSmart is not directed to children under 13. We do not knowingly collect personal information from children.',
        ),
        _buildSection(
          '8. Changes to This Policy',
          'We may update this Privacy Policy periodically. We will notify you of significant changes through the app.',
        ),
        _buildSection(
          '9. Contact Us',
          'If you have questions about this Privacy Policy, please contact us through the app\'s feedback feature.',
        ),
      ],
    );
  }

  Widget _buildSection(String title, String body, {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: isDate ? Colors.white54 : AppColors.primary,
              fontSize: isDate ? 13 : 16,
              fontWeight: isDate ? FontWeight.normal : FontWeight.w600,
            ),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              body,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
          const SizedBox(height: 4),
          if (!isDate)
            Divider(color: Colors.white.withOpacity(0.1)),
        ],
      ),
    );
  }
}