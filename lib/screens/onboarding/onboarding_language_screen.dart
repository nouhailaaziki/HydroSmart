import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final VoidCallback onLanguageSelected;

  const LanguageSelectionScreen({Key? key, required this.onLanguageSelected})
      : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧', 'native': 'English'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷', 'native': 'Français'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦', 'native': 'العربية'},
  ];

  Future<void> _confirmSelection() async {
    if (_selectedLanguage == null) return;
    final languageProvider =
    Provider.of<LanguageProvider>(context, listen: false);
    await languageProvider.setLanguage(_selectedLanguage!);
    widget.onLanguageSelected();
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                // App icon / logo area
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Colors.cyanAccent,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to HydroSmart',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred language\nChoisissez votre langue\nاختر لغتك',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ...(_languages.map((lang) => _buildLanguageTile(lang))),
                const Spacer(),
                ElevatedButton(
                  onPressed: _selectedLanguage != null ? _confirmSelection : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.cyanAccent.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue / Continuer / متابعة',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(Map<String, String> lang) {
    final isSelected = _selectedLanguage == lang['code'];
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = lang['code']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyanAccent.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.cyanAccent
                : Colors.white.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              lang['flag']!,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang['native']!,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    lang['name']!,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 24),
          ],
        ),
      ),
    );
  }
}