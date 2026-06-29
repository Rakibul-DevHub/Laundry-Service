import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../providers/auth_providers.dart';
import '../../state/reset_password_state.dart';

class ResetPasswordButton extends ConsumerWidget {
  final String token;

  const ResetPasswordButton({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("RESET PASSWORD SCREEN BUTTON BUILD");
    // Only watch validation state for button enable/disable & submitting
    final bool isValid = ref.watch(
      resetPasswordProvider.select((ResetPasswordState state) => state.isValid),
    );
    final bool isSubmitting = ref.watch(
      resetPasswordProvider.select(
        (ResetPasswordState state) => state.isSubmitting,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.resetPasswordBtn,
      onPressed: isSubmitting || !isValid
          ? null
          : () => ref.read(resetPasswordProvider.notifier).resetPassword(token),
      isEnabled: isValid,
      isLoading: isSubmitting,
    );
  }
}
