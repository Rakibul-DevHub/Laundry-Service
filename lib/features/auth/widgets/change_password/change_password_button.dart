import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/icons.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/custom_bottom_sheet.dart';
import '../../providers/auth_providers.dart';
import '../../state/change_password_state.dart';
import '../../../../shared/widgets/success_sheet.dart';

class ChangePasswordButton extends ConsumerWidget {
  const ChangePasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("CHANGE PASSWORD SCREEN ChangePasswordButton BUILD");

    final bool isValid = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.isValid,
      ),
    );

    final bool isSuccess = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.isSuccess,
      ),
    );
    AppLogger().d(
      "CHANGE PASSWORD SCREEN ChangePasswordButton BUILD -- isSuccess $isSuccess",
    );

    // Show success sheet when isSuccess becomes true
    if (isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(
              changePasswordProvider.notifier,
            )
            .setResetSuccess();
        CustomBottomSheet.show<SuccessSheet>(
          context: context,
          child: SuccessSheet(
            iconAsset: AppIcons.changePasswordSuccess,
            title: 'Password Changed!',
            message: 'Your password has been successfully updated.',
            onConfirm: () {
              context.pop();
              context.pop();
            },
          ),
        );
      });
    }

    final bool isSubmitting = ref.watch(
      changePasswordProvider.select(
        (ChangePasswordState state) => state.isSubmitting,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.changePasswordButton,
      onPressed: isSubmitting || !isValid
          ? null
          : () => ref.read(changePasswordProvider.notifier).changePassword(),
      isLoading: isSubmitting,
      isEnabled: isValid,
    );
  }
}
