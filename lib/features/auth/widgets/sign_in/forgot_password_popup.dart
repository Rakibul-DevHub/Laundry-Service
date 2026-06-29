import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../features/auth/providers/auth_providers.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/app_outline_button.dart';

class ForgotPasswordPopup extends StatelessWidget {
  final String email;

  const ForgotPasswordPopup({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Title
        Text(
          AppStrings.forgotPasswordPopupTitle,
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center, 
        ),
        const SizedBox(height: AppSizes.sm),

        // Subtitle
        Text(
          AppStrings.forgotPasswordPopupSubTitle,
          style: AppTextStyles.subTitle2.copyWith(
            color: AppColors.body,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spaceBetweenItems),

        // Email Display
        Text(
          AppStrings.forgotPasswordPopupYourEmail,
          style: AppTextStyles.heading5,
        ),
        Text(
          email,
          style: AppTextStyles.heading5.copyWith(color: AppColors.primary),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spaceBetweenItems),

        // Info text
        Text(
          AppStrings.forgotPasswordPopupInstruction,
          style: AppTextStyles.subTitle2.copyWith(color: AppColors.body),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.spaceBetweenItems),

        // Bullet points
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBulletPoint(
              AppStrings.forgotPasswordPopupBullet1,
            ),
            _buildBulletPoint(
              AppStrings.forgotPasswordPopupBullet2,
            ),
            _buildBulletPoint(
              AppStrings.forgotPasswordPopupBullet3,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBetweenSections),

        // Buttons
        Row(
          children: <Widget>[
            Expanded(
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  return AppOutlineButton(
                    label: AppStrings.cancel,
                    outlineColor: AppColors.primary,
                    onPressed: () async {
                      await ref
                          .read(signInProvider.notifier)
                          .handleResetForgotPopup();
                      context.pop();
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  return AppElevatedButton(
                    label: AppStrings.sendOTP,
                    isLoading: ref.watch(signInProvider).isSendOtpSubmitting,
                    onPressed: () async {
                      await ref.read(signInProvider.notifier).handleSendOtp();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("• ", style: AppTextStyles.paragraph1),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.paragraph1.copyWith(
                color: AppColors.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
