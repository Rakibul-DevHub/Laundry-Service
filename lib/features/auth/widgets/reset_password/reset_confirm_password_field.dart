import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/reset_password_state.dart';

class ConfirmPasswordField extends ConsumerWidget {
  const ConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("RESET PASSWORD SCREEN CONFIRM PASSWORD BUILD");
    final String password = ref.watch(
      resetPasswordProvider.select(
        (ResetPasswordState state) => state.confirmPassword,
      ),
    );
    final String? error = ref.watch(
      resetPasswordProvider.select(
        (ResetPasswordState state) => state.confirmPasswordError,
      ),
    );

    return AppTextField(
      labelText: AppStrings.resetPasswordConfirm,
      obscureText: true,
      errorText: error,
      initialValue: password,
      onChanged: (String v) =>
          ref.read(resetPasswordProvider.notifier).setConfirmPassword(v),
      onEditingComplete: () =>
          ref.read(resetPasswordProvider.notifier).validateConfirmPassword(),
      onUnfocus: () =>
          ref.read(resetPasswordProvider.notifier).validateConfirmPassword(),
    );
  }
}
