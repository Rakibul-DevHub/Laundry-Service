import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/styles/app_text_styles.dart';
import '../../../../../core/config/colors.dart';
import '../../../../../core/config/sizes.dart';
import '../../../../../core/config/strings.dart';
import '../../../../../shared/widgets/app_elevated_button.dart';
import '../../../../../shared/widgets/app_outline_button.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/config/icons.dart';
import '../../../shared/widgets/asset_loader.dart';
import '../../auth/providers/auth_providers.dart';

class LogoutPopup extends StatelessWidget {
  const LogoutPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const AssetLoader(
          assetPath: AppIcons.logoutWarning,
          width: 100,
          height: 100,
        ),
        const SizedBox(height: AppSizes.spaceBetweenItems),
        Text(
          "Logout",
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          "Are you sure you want to log out?",
          textAlign: TextAlign.center,
          style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
        ),
        const SizedBox(height: AppSizes.spaceBetweenSections),

        // Buttons
        Row(
          children: <Widget>[
            Expanded(
              child: AppOutlineButton(
                label: AppStrings.cancel,
                outlineColor: AppColors.primary,
                onPressed: () async {
                  context.pop();
                },
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  return AppElevatedButton(
                    label: AppStrings.logout,
                    onPressed: () async {
                      context.pop();
                      ref.read(authProvider.notifier).logout();
                      context.push(RoutePaths.signIn);
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
}
