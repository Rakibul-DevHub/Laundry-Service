import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/change_password_state.dart';

class ChangeConfirmPasswordField extends ConsumerWidget {
  const ChangeConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("CHANGE PASSWORD SCREEN _ConfirmPasswordField BUILD");

    final String password = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.confirmPassword,
      ),
    );
    final String? error = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.confirmPasswordError,
      ),
    );

    return AppTextField(
      labelText: AppStrings.changePasswordConfirm,
      obscureText: true,
      errorText: error,
      initialValue: password,
      onChanged: (String v) =>
          ref.read(changePasswordProvider.notifier).setConfirmPassword(v),
      onEditingComplete: () =>
          ref.read(changePasswordProvider.notifier).validateConfirmPassword(),
      onUnfocus: () =>
          ref.read(changePasswordProvider.notifier).validateConfirmPassword(),
    );
  }
}
