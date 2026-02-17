import 'package:flutter/material.dart';
import '../../utils/validators.dart';

class OnboardingNameScreen extends StatefulWidget {
  final Function(String name) onNameSubmitted;

  const OnboardingNameScreen({
    Key? key,
    required this.onNameSubmitted,
  }) : super(key: key);

  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _validationMessage;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _validationMessage = Validators.validateName(_nameController.text);
      _isValid = _validationMessage == null && _nameController.text.isNotEmpty;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNameSubmitted(_nameController.text.trim());
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
                const SizedBox(height: 40),
                const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.cyanAccent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'What\'s your name?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Let\'s personalize your water-saving journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
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
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.cyanAccent,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 2,
                            ),
                          ),
                          suffixIcon: _nameController.text.isNotEmpty
                              ? Icon(
                                  _isValid ? Icons.check_circle : Icons.error,
                                  color: _isValid
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                )
                              : null,
                        ),
                        validator: Validators.validateName,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      if (_validationMessage != null &&
                          _nameController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            _validationMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRule(
                              'Only letters and single spaces',
                              _nameController.text.isEmpty ||
                                  RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)*$')
                                      .hasMatch(_nameController.text.trim()),
                            ),
                            _buildRule(
                              'At least 2 characters',
                              _nameController.text.trim().length >= 2,
                            ),
                            _buildRule(
                              'No spaces at start or end',
                              _nameController.text.isEmpty ||
                                  (!_nameController.text.startsWith(' ') &&
                                      !_nameController.text.endsWith(' ')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isValid ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isValid ? Colors.cyanAccent : Colors.grey,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildRule(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check : Icons.circle_outlined,
            size: 16,
            color: isValid ? Colors.greenAccent : Colors.white.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? Colors.greenAccent : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
