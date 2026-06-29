import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import 'delete_account_button.dart';
import 'delete_account_password_field.dart';

class DeleteAccountForm extends StatelessWidget {
  const DeleteAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("DELETE ACCOUNT FORM SCREEN BUILD");
    return Container(
      constraints: BoxConstraints(
        maxHeight: (context.screenHeight - context.getAppBarHeight),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),
            const DeleteAccountPasswordField(),
            const SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),
            Text(
              AppStrings.deleteAccountHeading,
              style: AppTextStyles.heading1,
            ),
            const SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),
            Text(
              AppStrings.deleteAccountInstruction1,
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
            ),
            const SizedBox(
              height: AppSizes.sm,
            ),
            Text(
              AppStrings.deleteAccountInstruction2,
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
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
                    "• ${AppStrings.deleteAccountBullet1}",
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                  Text(
                    "• ${AppStrings.deleteAccountBullet2}",
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                  Text(
                    "• ${AppStrings.deleteAccountBullet3}",
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              AppStrings.deleteAccountInstruction3,
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
            ),

            const SizedBox(
              height: AppSizes.spaceBetweenSections * 2,
            ),

            const DeleteAccountButton(),

            const SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),

            AppOutlineButton(
              label: AppStrings.deleteAccountButtonCancel,
              outlineColor: AppColors.body,
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
