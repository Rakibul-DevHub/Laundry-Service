import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_providers.dart';
import '../../state/delete_account_state.dart';

class DeleteAccountPasswordField extends ConsumerWidget {
  const DeleteAccountPasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("DELETE ACCOUNT FORM SCREEN DeleteAccountPasswordField BUILD");
    final String password = ref.watch(
      deleteAccountProvider.select(
        (DeleteAccountState state) => state.password,
      ),
    );
    final String? error = ref.watch(
      deleteAccountProvider.select(
        (DeleteAccountState state) => state.passwordError,
      ),
    );

    return AppTextField(
      labelText: "Password*",
      obscureText: true,
      errorText: error,
      initialValue: password,
      onChanged: (String v) =>
          ref.read(deleteAccountProvider.notifier).setPassword(v),
      onEditingComplete: () =>
          ref.read(deleteAccountProvider.notifier).validatePassword(),
      onUnfocus: () =>
          ref.read(deleteAccountProvider.notifier).validatePassword(),
    );
  }
}
