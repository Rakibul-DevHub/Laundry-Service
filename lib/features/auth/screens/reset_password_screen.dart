import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../core/utils/app_logger.dart';
import '../widgets/reset_password/reset_confirm_password_field.dart';
import '../widgets/reset_password/reset_new_password_field.dart';
import '../widgets/reset_password/reset_password_button.dart';
import '../../../core/extensions/context_extensions.dart';

class ResetPasswordScreen extends StatelessWidget {
final String token;

const ResetPasswordScreen({super.key, required this.token});

@override
Widget build(BuildContext context) {
  AppLogger().d("RESET PASSWORD SCREEN BUILD");

  return PopScope(
    canPop: false,
    child: Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: context.getKeyboardHeight,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontal,
              vertical: AppSizes.screenVertical,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  AppStrings.resetPasswordTitle,
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  AppStrings.resetPasswordSubTitle,
                  style: AppTextStyles.subTitle1.copyWith(
                    color: AppColors.body,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceBetweenSections),
                // New Password field (only rebuilds when newPassword/newPasswordError changes)
                const ResetNewPasswordField(),
                const SizedBox(height: AppSizes.spaceBetweenInputs),

                // Confirm Password field (only rebuilds when confirmPassword/confirmPasswordError changes)
                const ConfirmPasswordField(),
                const SizedBox(height: AppSizes.spaceBetweenInputs),

                // Submit button (only rebuilds when isSubmitting/isValid changes)
                ResetPasswordButton(
                  token: token,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
