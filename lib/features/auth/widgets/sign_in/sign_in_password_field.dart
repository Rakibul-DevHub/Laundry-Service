import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_in_state.dart';

class SignInPasswordField extends ConsumerStatefulWidget {
  const SignInPasswordField({super.key});

  @override
  ConsumerState<SignInPasswordField> createState() =>
      _SignInPasswordFieldState();
}

class _SignInPasswordFieldState extends ConsumerState<SignInPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    AppLogger().d("SIGN IN _SignInPasswordField BUILD");

    final String? passwordError = ref.watch(
      signInProvider.select((SignInState state) => state.passwordError),
    );

    final String password = ref.watch(
      signInProvider.select((SignInState state) => state.password),
    );

    return AppTextField(
      labelText: AppStrings.signInPassword,
      obscureText: _obscurePassword,
      errorText: passwordError,
      initialValue: password,
      onEditingComplete: () {
        ref.read(signInProvider.notifier).passwordValidate();
      },
      onUnfocus: () {
        ref.read(signInProvider.notifier).passwordValidate();
      },
      onChanged: (String value) =>
          ref.read(signInProvider.notifier).setPassword(value),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility : Icons.visibility_off,
          color: AppColors.body,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }
}
