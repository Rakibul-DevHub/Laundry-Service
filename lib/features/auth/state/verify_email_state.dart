import 'package:flutter/material.dart';

import '../../../shared/enums/verify_email_type.dart';

@immutable
class VerifyEmailState {
  final String email;
  final List<String> code;
  final bool isSubmitting;
  final String? error;
  final int resendTimer;
  final bool canResend;
  final VerifyEmailType type;
  final List<FocusNode> focusNodes;

  VerifyEmailState({
    this.email = '',
    this.type = VerifyEmailType.verifyEmail,
    this.code = const <String>['', '', '', '', '', ''],
    this.isSubmitting = false,
    this.error,
    this.resendTimer = 60,
    this.canResend = false,
    List<FocusNode>? focusNodes,
  }) : focusNodes =
           focusNodes ??
           List<FocusNode>.generate(
             6,
             (int index) => FocusNode(),
             growable: false,
           );

  bool get isValidCode =>
      code.length == 6 && code.every((String digit) => digit.isNotEmpty);

  VerifyEmailState copyWith({
    List<String>? code,
    bool? isSubmitting,
    String? error,
    VerifyEmailType? type,
    String? email,
    int? resendTimer,
    bool? canResend,
    List<FocusNode>? focusNodes,
  }) {
    return VerifyEmailState(
      email: email ?? this.email,
      type: type ?? this.type,
      code: code ?? this.code,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      resendTimer: resendTimer ?? this.resendTimer,
      canResend: canResend ?? this.canResend,
      focusNodes: focusNodes ?? this.focusNodes,
    );
  }

  @override
  String toString() {
    return 'VerifyEmailState('
        'email: $email, '
        'code: $code, '
        'isSubmitting: $isSubmitting, '
        'error: $error, '
        'resendTimer: $resendTimer, '
        'canResend: $canResend, '
        'type: $type'
        ')';
  }
}
