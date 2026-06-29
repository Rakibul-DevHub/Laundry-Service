import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/core/constants/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/images.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../../../shared/widgets/asset_loader.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("ONBOARDING SCREEN BUILD");

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.screenVertical,
          horizontal: AppSizes.screenHorizontal,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const AssetLoader(assetPath: AppImages.onboarding),
              const SizedBox(height: AppSizes.sm),
              Text(
                AppStrings.onboardingTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                AppStrings.onboardingSubTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.subTitle1.copyWith(color: AppColors.body),
              ),
              const SizedBox(height: AppSizes.spaceBetweenSections),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  return AppElevatedButton(
                    label: AppStrings.onboardingBtn,
                    onPressed: () async {
                      await ref
                          .read(secureStorageProvider)
                          .write(StorageKeys.onboardingSeen, "true");
                      // Navigate to role selection
                      ref
                          .read(appRouterProvider)
                          .pushReplacement(RoutePaths.signIn);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
