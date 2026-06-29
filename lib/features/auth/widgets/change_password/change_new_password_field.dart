import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/change_password_state.dart';

class ChangeNewPasswordField extends ConsumerWidget {
  const ChangeNewPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("CHANGE PASSWORD SCREEN ChangeNewPasswordField BUILD");

    final String password = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.newPassword,
      ),
    );
    final String? error = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.newPasswordError,
      ),
    );

    return AppTextField(
      labelText: AppStrings.changePasswordNew,
      obscureText: true,
      errorText: error,
      initialValue: password,
      onChanged: (String v) =>
          ref.read(changePasswordProvider.notifier).setNewPassword(v),
      onEditingComplete: () =>
          ref.read(changePasswordProvider.notifier).validateNewPassword(),
      onUnfocus: () =>
          ref.read(changePasswordProvider.notifier).validateNewPassword(),
    );
  }
}
