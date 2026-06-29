import 'package:flutter/foundation.dart';

@immutable
class ResetPasswordState {
  final String newPassword;
  final String? newPasswordError;
  final String confirmPassword;
  final String? confirmPasswordError;
  final bool isSubmitting;

  const ResetPasswordState({
    this.newPassword = '',
    this.newPasswordError,
    this.confirmPassword = '',
    this.confirmPasswordError,
    this.isSubmitting = false,
  });

  bool get isValid => 
    newPasswordError == null && 
    confirmPasswordError == null && 
    newPassword.isNotEmpty && 
    confirmPassword.isNotEmpty &&
    newPassword == confirmPassword;

  ResetPasswordState copyWith({
    String? newPassword,
    String? newPasswordError,
    String? confirmPassword,
    String? confirmPasswordError,
    bool? isSubmitting,
    String? generalError,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      newPasswordError: newPasswordError,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      confirmPasswordError: confirmPasswordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}