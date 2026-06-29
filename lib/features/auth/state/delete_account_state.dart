import 'package:flutter/foundation.dart';

@immutable
class DeleteAccountState {
  final String password;
  final String? passwordError;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isWarningScreen;

  const DeleteAccountState({
    this.password = '',
    this.passwordError,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isWarningScreen = true,
  });

  bool get isValid => passwordError == null && password.isNotEmpty;

  DeleteAccountState copyWith({
    String? password,
    String? passwordError,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isWarningScreen,
  }) {
    return DeleteAccountState(
      password: password ?? this.password,
      passwordError: passwordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isWarningScreen: isWarningScreen ?? this.isWarningScreen,
    );
  }
}