import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_in_state.dart';

class SignInPasswordField extends ConsumerWidget {
  const SignInPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN IN _SignInPasswordField BUILD");

    // Only rebuild when password & passwordError changes
    final String? passwordError = ref.watch(
      signInProvider.select((SignInState state) => state.passwordError),
    );

    final String password = ref.watch(
      signInProvider.select((SignInState state) => state.password),
    );

    return AppTextField(
      labelText: AppStrings.signInPassword,
      obscureText: true,
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
    );
  }
}
