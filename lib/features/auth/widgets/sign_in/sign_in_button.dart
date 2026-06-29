import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../providers/auth_providers.dart';
import '../../state/sign_in_state.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("SIGN IN _SignInButton BUILD");

    final bool isSubmitting = ref.watch(
      signInProvider.select((SignInState state) => state.isSubmitting),
    );
    final String? emailError = ref.watch(
      signInProvider.select((SignInState state) => state.emailError),
    );
    final String? passwordError = ref.watch(
      signInProvider.select((SignInState state) => state.passwordError),
    );
    final String email = ref.watch(
      signInProvider.select((SignInState state) => state.email),
    );
    final String password = ref.watch(
      signInProvider.select((SignInState state) => state.password),
    );

    final bool isValid = emailError == null && passwordError == null;
    final bool isEmpty = email.isEmpty || password.isEmpty;

    return AppElevatedButton(
      label: AppStrings.signInBtn,
      onPressed: isSubmitting || !isValid
          ? null
          : () => ref.read(signInProvider.notifier).handleSignIn(),
      isEnabled: isValid && !isEmpty,
      isLoading: isSubmitting,
    );
  }
}
