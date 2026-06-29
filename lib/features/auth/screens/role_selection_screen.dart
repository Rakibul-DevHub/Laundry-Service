import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/images.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/enums/role.dart';
import '../../../shared/provider/role_provider.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../widgets/role_container.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger().d("ROLE SELECTION SCREEN BUILD");

    return Scaffold(
      appBar: const CustomAppBar(
        showBackBtn: true,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // top section
            Text(
              AppStrings.roleTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              AppStrings.roleSubTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.subTitle1.copyWith(color: AppColors.body),
            ),

            const SizedBox(height: 56.0),

            const RoleContainer(
              role: Role.user,
              title: AppStrings.userRole,
              description: AppStrings.userRoleDesc,
              asset: AppImages.userRole,
            ),
            const SizedBox(height: 24.0),

            const RoleContainer(
              role: Role.rider,
              title: AppStrings.riderRole,
              description: AppStrings.riderRoleDesc,
              asset: AppImages.riderRole,
            ),

            const SizedBox(height: 24.0),
            const RoleContainer(
              role: Role.provider,
              title: AppStrings.providerRole,
              description: AppStrings.providerRoleDesc,
              asset: AppImages.providerRole,
            ),

            const SizedBox(height: 32.0),

            // confirm button
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                return AppElevatedButton(
                  label: AppStrings.roleBtn,
                  onPressed: () async {
                    ref.read(selectedRoleProvider).whenData((Role role) {
                      context.push(RoutePaths.signUp, extra: role);
                    });
                  },
                );
              },
            ),

            const SizedBox(height: AppSizes.spaceBetweenSections),
          ],
        ),
      ),
    );
  }
}
