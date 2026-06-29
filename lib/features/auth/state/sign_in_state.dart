import 'package:flutter/foundation.dart';

@immutable
class SignInState {
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final bool isSubmitting;
  final bool isSendOtpSubmitting;
  final bool isForgotPopupOpen;
  // final String? error;

  const SignInState({
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.isForgotPopupOpen = false,
    this.isSendOtpSubmitting = false,
    // this.error,
    this.emailError,
    this.passwordError,
  });

  bool get isValid => emailError == null && passwordError == null;
  bool get isEmpty => email.isEmpty && password.isEmpty;

  SignInState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool? isForgotPopupOpen,
    bool? isSendOtpSubmitting,
    // String? error,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isForgotPopupOpen: isForgotPopupOpen ?? this.isForgotPopupOpen,
      isSendOtpSubmitting: isSendOtpSubmitting ?? this.isSendOtpSubmitting,
      // error: error,
    );
  }

  @override
  String toString() {
    return 'SignInState('
        'email: $email, '
        'password: [REDACTED], '
        'emailError: $emailError, '
        'passwordError: $passwordError, '
        'isSubmitting: $isSubmitting'
        ')';
  }
}
