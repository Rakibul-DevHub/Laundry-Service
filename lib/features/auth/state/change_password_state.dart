import 'package:flutter/foundation.dart';

@immutable
class ChangePasswordState {
  final String oldPassword;
  final String? oldPasswordError;
  final String newPassword;
  final String? newPasswordError;
  final String confirmPassword;
  final String? confirmPasswordError;
  final bool isSubmitting;
  final bool isSuccess;

  const ChangePasswordState({
    this.oldPassword = '',
    this.oldPasswordError,
    this.newPassword = '',
    this.newPasswordError,
    this.confirmPassword = '',
    this.confirmPasswordError,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  bool get isValid =>
      oldPasswordError == null &&
      newPasswordError == null &&
      confirmPasswordError == null &&
      oldPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      newPassword == confirmPassword;

  ChangePasswordState copyWith({
    String? oldPassword,
    String? oldPasswordError,
    String? newPassword,
    String? newPasswordError,
    String? confirmPassword,
    String? confirmPasswordError,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      oldPasswordError: oldPasswordError,
      newPassword: newPassword ?? this.newPassword,
      newPasswordError: newPasswordError,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      confirmPasswordError: confirmPasswordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
