import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/icons.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/config/strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../providers/auth_providers.dart';

class DeleteAccountWarning extends StatelessWidget {
  const DeleteAccountWarning({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("DELETE ACCOUNT WARNING SCREEN BUILD");
    return Container(
      constraints: BoxConstraints(
        maxHeight: (context.screenHeight - context.getAppBarHeight),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: AppSizes.spaceBetweenSections,
            children: <Widget>[
              const AssetLoader(
                assetPath: AppIcons.deleteAccountWarning,
                width: 100,
                height: 100,
              ),
              Text(
                AppStrings.deleteAccountWarningTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1,
              ),
              Text(
                AppStrings.deleteAccountWarningSubTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
              ),

              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  return AppElevatedButton(
                    label: AppStrings.deleteAccountWarningButton,
                    onPressed: () {
                      ref
                          .read(deleteAccountProvider.notifier)
                          .changeWarningScreenState(false);
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
