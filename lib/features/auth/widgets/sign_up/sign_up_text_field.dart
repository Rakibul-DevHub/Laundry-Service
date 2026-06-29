import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../shared/enums/role.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_up_state.dart';

class SignUpTextField extends ConsumerWidget {
  final Role role;
  final String labelText;
  final String? Function(SignUpState) getValue;
  final String? Function(SignUpState) getError;
  final void Function(WidgetRef, String) onChanged;
  final void Function(WidgetRef)? onUnfocus;
  final TextInputType keyboardType;
  final bool obscureText;

  const SignUpTextField({
    super.key,
    required this.role,
    required this.labelText,
    required this.getValue,
    required this.getError,
    required this.onChanged,
    this.onUnfocus,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN UP _SignUpTextField $labelText SCREEN BUILD");

    final String? value = ref.watch(signUpProvider(role).select(getValue));
    final String? error = ref.watch(signUpProvider(role).select(getError));

    return AppTextField(
      labelText: labelText,
      errorText: error,
      initialValue: value,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: (String v) => onChanged(ref, v),
      onUnfocus: onUnfocus != null ? () => onUnfocus!(ref) : () {},
    );
  }
}
