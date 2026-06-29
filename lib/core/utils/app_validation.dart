import '../../../core/extensions/strings_extensions.dart';
import 'app_logger.dart';

class AppValidation {
  AppValidation._();

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      AppLogger().d("Email is required");
      return "Email is required";
    }
    if (!email.isValidEmail()) {
      AppLogger().d("Invalid email address");
      return "Invalid email address";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      AppLogger().d("Password is required");
      return "Password is required";
    }
    if (password.length < 6) {
      AppLogger().d("Password must be at least 6 characters");
      return "Password must be at least 6 characters";
    }
    // if (!RegExp(r'[A-Z]').hasMatch(password)) {
    //   return "Password must contain at least one uppercase letter";
    // }
    // if (!RegExp(r'[a-z]').hasMatch(password)) {
    //   return "Password must contain at least one lowercase letter";
    // }
    // if (!RegExp(r'[0-9]').hasMatch(password)) {
    //   return "Password must contain at least one number";
    // }
    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    //   return "Password must contain at least one special character";
    // }
    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm password is required";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Phone number is required";
    }

    final RegExp phoneRegExp = RegExp(r'^\+?[\d\s-]{10,15}$');

    if (!phoneRegExp.hasMatch(phoneNumber)) {
      return "Invalid phone number";
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      AppLogger().d("$fieldName is required");
      return "$fieldName is required";
    }
    return null;
  }

  static String? validateBool(bool? value, {required String message}) {
    if (value == null || value == false) {
      return message;
    }
    return null;
  }

  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = "Field",
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    if (value.length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }
    return null;
  }

  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = "Field",
  }) {
    if (value != null && value.length > maxLength) {
      return "$fieldName must not exceed $maxLength characters";
    }
    return null;
  }

  static bool isValidYear(String yearStr) {
    if (yearStr.length != 4){
      return false;
    }
    final int? year = int.tryParse(yearStr);
    if (year == null){
      return false;
    }
    final int currentYear = DateTime.now().year;
    return year >= 1900 && year <= currentYear;
  }
}
