import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../models/household_member_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/validators.dart';

class OnboardingHouseholdScreen extends StatefulWidget {
  final String userName;
  final int userAge;
  final Function(List<HouseholdMember> members) onHouseholdSubmitted;

  const OnboardingHouseholdScreen({
    Key? key,
    required this.userName,
    required this.userAge,
    required this.onHouseholdSubmitted,
  }) : super(key: key);

  @override
  State<OnboardingHouseholdScreen> createState() =>
      _OnboardingHouseholdScreenState();
}

class _OnboardingHouseholdScreenState extends State<OnboardingHouseholdScreen> {
  static const int defaultMemberAge = 25;
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  List<HouseholdMember> _members = [];
  int _householdSize = 1;
  final _ageControllers = <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    // Add user as first member
    _members.add(HouseholdMember(
      id: _uuid.v4(),
      name: widget.userName,
      age: widget.userAge,
    ));
  }

  @override
  void dispose() {
    for (var controller in _ageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateHouseholdSize(int size) {
    setState(() {
      _householdSize = size;
      _ageControllers.clear();

      // Keep user as first member, add/remove others
      _members = [_members.first];

      for (int i = 1; i < size; i++) {
        if (_members.length <= i) {
          _members.add(HouseholdMember(
            id: _uuid.v4(),
            age: defaultMemberAge,
          ));
        }
        _ageControllers.add(TextEditingController(text: _members[i].age.toString()));
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Update ages from controllers
      for (int i = 1; i < _members.length; i++) {
        final age = int.tryParse(_ageControllers[i - 1].text) ?? defaultMemberAge;
        _members[i] = _members[i].copyWith(age: age);
      }
      widget.onHouseholdSubmitted(_members);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
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
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.translate('onboarding_household_title'),
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.translate('onboarding_household_subtitle'),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('onboarding_household_size_question'),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(10, (index) {
                              final size = index + 1;
                              final isSelected = _householdSize == size;
                              return GestureDetector(
                                onTap: () => _updateHouseholdSize(size),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primaryDark
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.white.withOpacity(0.15),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$size',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          if (_householdSize > 1) ...[
                            Text(
                              l10n.translate('onboarding_household_members_age_title'),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(_householdSize - 1, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: TextFormField(
                                  controller: _ageControllers[index],
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: l10n.translateWithArgs(
                                      'onboarding_household_member_age_label',
                                      {'n': '${index + 2}'},
                                    ),
                                    labelStyle: GoogleFonts.poppins(
                                      color: Colors.white60,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.08),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppColors.primary.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) => Validators.validateAge(value),
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                _buildContinueButton(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _submit,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              l10n.translate('continue'),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}