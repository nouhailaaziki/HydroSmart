class Validators {
  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Password Strength
  static double getPasswordStrength(String password) {
    double strength = 0.0;
    
    if (password.length >= 8) strength += 0.2;
    if (password.length >= 12) strength += 0.1;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.15;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.15;
    
    return strength.clamp(0.0, 1.0);
  }

  static String getPasswordStrengthText(double strength) {
    if (strength < 0.3) return 'Weak';
    if (strength < 0.6) return 'Fair';
    if (strength < 0.8) return 'Good';
    return 'Strong';
  }

  static Color getPasswordStrengthColor(double strength) {
    if (strength < 0.3) return Color(0xFFF44336);
    if (strength < 0.6) return Color(0xFFFFC107);
    if (strength < 0.8) return Color(0xFF2196F3);
    return Color(0xFF4CAF50);
  }

  // Family Size Validation
  static String? validateFamilySize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Family size is required';
    }
    final size = int.tryParse(value);
    if (size == null) {
      return 'Please enter a valid number';
    }
    if (size < 1 || size > 20) {
      return 'Family size must be between 1 and 20';
    }
    return null;
  }

  // Phone Number Validation (Optional)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    if (value.replaceAll(RegExp(r'[\s\-()]'), '').length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }
}
