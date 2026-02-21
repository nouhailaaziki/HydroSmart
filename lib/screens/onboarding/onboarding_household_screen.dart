import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../models/household_member_model.dart';
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
                  Icons.family_restroom,
                  size: 64,
                  color: Colors.cyanAccent,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.translate('onboarding_household_title'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.translate('onboarding_household_subtitle'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
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
                            style: TextStyle(
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
                              return ChoiceChip(
                                label: Text('$size'),
                                selected: _householdSize == size,
                                onSelected: (selected) {
                                  if (selected) _updateHouseholdSize(size);
                                },
                                selectedColor: Colors.cyanAccent,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                labelStyle: TextStyle(
                                  color: _householdSize == size
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          if (_householdSize > 1) ...[
                            Text(
                              l10n.translate('onboarding_household_members_age_title'),
                              style: TextStyle(
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
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: l10n.translateWithArgs(
                                      'onboarding_household_member_age_label',
                                      {'n': '${index + 2}'},
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.cyanAccent.withOpacity(0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.cyanAccent,
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
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.translate('continue'),
                      style: const TextStyle(
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
}