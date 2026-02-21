import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

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
              loc.translate('terms_of_service'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          'Last Updated: February 20, 2026',
          '',
          isDate: true,
        ),
        _buildSection(
          '1. Acceptance of Terms',
          'By downloading or using HydroSmart, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the application.',
        ),
        _buildSection(
          '2. Description of Service',
          'HydroSmart is a water conservation application that helps users track water consumption, set goals, and receive personalized recommendations to reduce water usage.',
        ),
        _buildSection(
          '3. User Responsibilities',
          'You are responsible for:\n• Providing accurate water meter readings\n• Maintaining the security of your device\n• Using the app in compliance with applicable laws\n• Not misusing the AI assistant feature',
        ),
        _buildSection(
          '4. Accuracy of Data',
          'HydroSmart relies on data you input. While we strive to provide accurate calculations and recommendations, we cannot guarantee the accuracy of consumption estimates. Actual water bills may differ from app estimates.',
        ),
        _buildSection(
          '5. AI Assistant',
          'The AI assistant provides general water conservation advice. This advice is for informational purposes only and should not replace professional guidance from water utilities or conservation experts.',
        ),
        _buildSection(
          '6. Intellectual Property',
          'All content, features, and functionality of HydroSmart are owned by the developers and are protected by copyright and other intellectual property laws.',
        ),
        _buildSection(
          '7. Disclaimer of Warranties',
          'HydroSmart is provided "as is" without warranties of any kind. We do not warrant that the app will be error-free or uninterrupted.',
        ),
        _buildSection(
          '8. Limitation of Liability',
          'HydroSmart shall not be liable for any indirect, incidental, or consequential damages arising from your use of the application.',
        ),
        _buildSection(
          '9. Changes to Terms',
          'We reserve the right to modify these terms at any time. Continued use of the app following notification of changes constitutes acceptance of the new terms.',
        ),
        _buildSection(
          '10. Termination',
          'You may stop using HydroSmart at any time. We reserve the right to terminate access for violations of these terms.',
        ),
        _buildSection(
          '11. Governing Law',
          'These terms are governed by applicable local laws. Any disputes shall be resolved through appropriate legal channels.',
        ),
        _buildSection(
          '12. Contact',
          'For questions about these Terms of Service, please contact us through the app\'s feedback feature.',
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