import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../widgets/change_password/change_confirm_password_field.dart';
import '../widgets/change_password/change_new_password_field.dart';
import '../widgets/change_password/change_old_password_field.dart';
import '../widgets/change_password/change_password_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("CHANGE PASSWORD SCREEN BUILD");

    // 👇 Watch ONLY success state for bottom sheet

    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.changePasswordTitle),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: AppSizes.md,
                ),
                const ChangeOldPasswordField(),
                const SizedBox(height: AppSizes.spaceBetweenInputs),
                const ChangeNewPasswordField(),
                const SizedBox(height: AppSizes.spaceBetweenInputs),
                const ChangeConfirmPasswordField(),
                const SizedBox(height: AppSizes.spaceBetweenInputs),
                Text(
                  AppStrings.changePasswordInstruction,
                  style: AppTextStyles.paragraph0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.md,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizes.xs,
                    children: <Widget>[
                      Text(
                        "• ${AppStrings.changePasswordBullet1}",
                        style: AppTextStyles.paragraph1,
                      ),
                      Text(
                        "• ${AppStrings.changePasswordBullet2}",
                        style: AppTextStyles.paragraph1,
                      ),
                      Text(
                        "• ${AppStrings.changePasswordBullet3}",
                        style: AppTextStyles.paragraph1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.md,
                ),
                const ChangePasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
