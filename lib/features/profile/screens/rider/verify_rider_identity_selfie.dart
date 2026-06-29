import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/config/videos.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/image_picker_utils.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../providers/rider_identity_verify_providers.dart';
import '../../state/rider_verification_state.dart';

class VerifyRiderIdentitySelfie extends StatelessWidget {
  const VerifyRiderIdentitySelfie({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("VerifyRiderIdentitySelfie SCREEN BUILD");
    return Scaffold(
      appBar: const CustomAppBar(
        showBackBtn: true,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontal,
            vertical: AppSizes.screenVertical,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                        AppLogger().d(
                          "VerifyRiderIdentitySelfie insurance file BUILD",
                        );
                        final File? selfie = ref.watch(
                          riderIdentityVerifyProvider.select(
                            (RiderVerificationState state) => state.selfie,
                          ),
                        );
                        if (selfie != null) {
                          return SelfiePreview(
                            image: selfie,
                            onRetakeCallback: () async {
                              final File? file =
                                  await ImagePickerUtils.takeSelfie();
                              if (file != null) {
                                ref
                                    .read(riderIdentityVerifyProvider.notifier)
                                    .setSelfie(file);
                              }
                            },
                          );
                        } else {
                          return InitialState(
                            onTapCallback: () async {
                              final File? file =
                                  await ImagePickerUtils.takeSelfie();
                              if (file != null) {
                                ref
                                    .read(riderIdentityVerifyProvider.notifier)
                                    .setSelfie(file);
                              }
                            },
                          );
                        }
                      },
                ),

                // const SizedBox(height: AppSizes.spaceBetweenSections),

                // const VerifySelfieSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InitialState extends StatelessWidget {
  final VoidCallback onTapCallback;
  const InitialState({super.key, required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppStrings.selfieVerificationTitle,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            AppStrings.selfieVerificationSubTitle,
            style: AppTextStyles.subTitle1.copyWith(
              color: AppColors.body,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceBetweenSections),

          ClipRRect(
            borderRadius: BorderRadius.circular(56),
            child: const AssetLoader(
              assetPath: AppVideos.selfieVerification,
            ),
          ),
          const SizedBox(height: AppSizes.spaceBetweenSections),
          _buildBulletPoint("Ensure your face is fully visible."),
          const SizedBox(height: AppSizes.xs),
          _buildBulletPoint("Avoid hats, sunglasses, or masks."),
          const SizedBox(height: AppSizes.xs),
          _buildBulletPoint("Good lighting improves verification accuracy."),
          const SizedBox(height: AppSizes.spaceBetweenSections),

          AppElevatedButton(
            label: AppStrings.selfieVerificationTakeSelfie,
            onPressed: onTapCallback,
          ),
        ],
      ),
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

class SelfiePreview extends StatelessWidget {
  final File image;
  final VoidCallback onRetakeCallback;
  const SelfiePreview({
    super.key,
    required this.onRetakeCallback,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AssetLoader(assetPath: image),
        const SizedBox(height: AppSizes.spaceBetweenSections),
        AppOutlineButton(
          label: AppStrings.selfieVerificationRetake,
          onPressed: onRetakeCallback,
          outlineColor: AppColors.body,
        ),
        const SizedBox(height: AppSizes.spaceBetweenItems),
        const VerifySelfieSubmitButton(),
      ],
    );
  }
}

class VerifySelfieSubmitButton extends ConsumerWidget {
  const VerifySelfieSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().d("VerifyDriving VerifySelfieSubmitButton BUILD");

    final bool isSubmitting = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isSelfieSubmitting,
      ),
    );
    final bool isSelfieComplete = ref.watch(
      riderIdentityVerifyProvider.select(
        (RiderVerificationState state) => state.isSelfieComplete,
      ),
    );

    return AppElevatedButton(
      label: AppStrings.submitButton,
      onPressed: isSubmitting || !isSelfieComplete
          ? null
          : () => ref
                .read(riderIdentityVerifyProvider.notifier)
                .handleSelfieSubmit(),
      isEnabled: isSelfieComplete,
      isLoading: isSubmitting,
    );
  }
}
