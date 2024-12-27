

class Validator {
  /// Validates an email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const emailRegex =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a password (minimum 8 characters with letters and numbers)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$')
        .hasMatch(value)) {
      return 'Password must include letters, numbers, and special characters';
    }
    return null;
  }

  /// Confirms if two passwords match
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates a general text field
  static String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
