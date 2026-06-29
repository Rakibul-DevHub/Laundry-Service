import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/change_password_state.dart';

class ChangeOldPasswordField extends ConsumerWidget {
  const ChangeOldPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("CHANGE PASSWORD SCREEN ChangeOldPasswordField BUILD");

    final String password = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.oldPassword,
      ),
    );
    final String? error = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.oldPasswordError,
      ),
    );

    return AppTextField(
      labelText: AppStrings.changePasswordOld,
      obscureText: true,
      errorText: error,
      initialValue: password,
      onChanged: (String v) =>
          ref.read(changePasswordProvider.notifier).setOldPassword(v),
      onEditingComplete: () =>
          ref.read(changePasswordProvider.notifier).validateOldPassword(),
      onUnfocus: () =>
          ref.read(changePasswordProvider.notifier).validateOldPassword(),
    );
  }
}
