import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _familySizeController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _familySizeError;
  String? _phoneError;
  
  bool _obscurePassword = true;
  double _passwordStrength = 0.0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _familySizeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateName(String value) {
    setState(() {
      _nameError = Validators.validateName(value);
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = Validators.validateEmail(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError = Validators.validatePassword(value);
      _passwordStrength = Validators.getPasswordStrength(value);
    });
  }

  void _validateFamilySize(String value) {
    setState(() {
      _familySizeError = Validators.validateFamilySize(value);
    });
  }

  void _validatePhone(String value) {
    setState(() {
      _phoneError = Validators.validatePhone(value);
    });
  }

  bool _isFormValid() {
    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _familySizeError == null &&
        _phoneError == null &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _familySizeController.text.isNotEmpty;
  }

  Future<void> _handleSignup() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    if (!mounted) return;

    // Store user data and login
    Provider.of<AuthProvider>(context, listen: false)
        .login(_emailController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildHeader(),
                SizedBox(height: 40),
                _buildSignupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textWhite),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Create Account',
          style: AppTextStyles.heading1,
        ),
        SizedBox(height: 8),
        Text(
          'Join HydroSmart and start saving water today',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          CustomInput(
            controller: _nameController,
            labelText: 'Full Name',
            hintText: 'Enter your name',
            errorText: _nameError,
            onChanged: _validateName,
            prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
            suffixIcon: _nameError == null && _nameController.text.isNotEmpty
                ? Icon(Icons.check_circle, color: AppColors.success)
                : null,
          ),
          SizedBox(height: 16),

          // Email Field
          CustomInput(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'your.email@example.com',
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            onChanged: _validateEmail,
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            suffixIcon: _emailError == null && _emailController.text.isNotEmpty
                ? Icon(Icons.check_circle, color: AppColors.success)
                : null,
          ),
          SizedBox(height: 16),

          // Password Field
          CustomInput(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Create a strong password',
            obscureText: _obscurePassword,
            errorText: _passwordError,
            onChanged: _validatePassword,
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textWhite54,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          if (_passwordController.text.isNotEmpty) ...[
            SizedBox(height: 8),
            _buildPasswordStrengthIndicator(),
          ],
          SizedBox(height: 16),

          // Family Size Field
          CustomInput(
            controller: _familySizeController,
            labelText: 'Family Size',
            hintText: 'Number of family members',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText: _familySizeError,
            onChanged: _validateFamilySize,
            prefixIcon: Icon(Icons.group_outlined, color: AppColors.primary),
            suffixIcon: _familySizeError == null && _familySizeController.text.isNotEmpty
                ? Icon(Icons.check_circle, color: AppColors.success)
                : null,
          ),
          SizedBox(height: 16),

          // Phone Field (Optional)
          CustomInput(
            controller: _phoneController,
            labelText: 'Phone Number (Optional)',
            hintText: '+1 234 567 8900',
            keyboardType: TextInputType.phone,
            errorText: _phoneError,
            onChanged: _validatePhone,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
            suffixIcon: _phoneError == null && _phoneController.text.isNotEmpty
                ? Icon(Icons.check_circle, color: AppColors.success)
                : null,
          ),
          SizedBox(height: 32),

          // Sign Up Button
          CustomButton(
            text: 'Create Account',
            onPressed: _isFormValid() ? _handleSignup : () {},
            isLoading: _isLoading,
            width: double.infinity,
          ),
          SizedBox(height: 16),

          // Login Link
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Already have an account? Login',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: _passwordStrength,
                backgroundColor: AppColors.textWhite.withOpacity(0.1),
                color: Validators.getPasswordStrengthColor(_passwordStrength),
                minHeight: 4,
              ),
            ),
            SizedBox(width: 8),
            Text(
              Validators.getPasswordStrengthText(_passwordStrength),
              style: AppTextStyles.small.copyWith(
                color: Validators.getPasswordStrengthColor(_passwordStrength),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Use 8+ characters with uppercase, lowercase, and numbers',
          style: AppTextStyles.small,
        ),
      ],
    );
  }
}
