import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/reset_password_state.dart';

class ResetNewPasswordField extends ConsumerWidget {
  const ResetNewPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("RESET PASSWORD SCREEN NEW PASSWORD BUILD");
    final String password = ref.watch(
      resetPasswordProvider.select(
        (ResetPasswordState state) => state.newPassword,
      ),
    );
    final String? error = ref.watch(
      resetPasswordProvider.select(
        (ResetPasswordState state) => state.newPasswordError,
      ),
    );

    return AppTextField(
      labelText: AppStrings.resetPasswordNew,
      obscureText: true,
      errorText: error,
      initialValue: password,
      onChanged: (String v) =>
          ref.read(resetPasswordProvider.notifier).setNewPassword(v),
      onEditingComplete: () =>
          ref.read(resetPasswordProvider.notifier).validateNewPassword(),
      onUnfocus: () =>
          ref.read(resetPasswordProvider.notifier).validateNewPassword(),
    );
  }
}
