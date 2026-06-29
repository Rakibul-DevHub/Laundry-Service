import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_in_state.dart';

class SignInEmailField extends ConsumerWidget {
  const SignInEmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN IN SignInEmailField BUILD");

    final String? emailError = ref.watch(
      signInProvider.select((SignInState state) => state.emailError),
    );
    final String email = ref.watch(
      signInProvider.select((SignInState state) => state.email),
    );

    return AppTextField(
      labelText: AppStrings.signInEmail,
      keyboardType: TextInputType.emailAddress,
      errorText: emailError,
      initialValue: email,
      onEditingComplete: () {
        ref.read(signInProvider.notifier).emailValidate();
      },
      onUnfocus: () {
        ref.read(signInProvider.notifier).emailValidate();
      },
      onChanged: (String value) =>
          ref.read(signInProvider.notifier).setEmail(value),
    );
  }
}
