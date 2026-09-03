import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/router/route_paths.dart';
import '../../core/config/colors.dart';
import '../../core/config/icons.dart';
import '../../features/profile/providers/profile_providers.dart';
import '../../features/profile/state/provider_profile_state.dart';
import '../models/user_model.dart';

class ProviderHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProviderHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? widget) {
          final AsyncValue<User> user = ref.watch(
            providerProfileProvider.select(
              (ProviderProfileState value) => value.profileValue,
            ),
          );
          return user.when(
            data: (User data) => AppBar(
              shadowColor: AppColors.paste100,
              surfaceTintColor: AppColors.paste100,
              backgroundColor: AppColors.white,
              elevation: 0.0,
              scrolledUnderElevation: .6,
              leading: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: AssetLoader(
                    assetPath: data.profilePicture,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome",
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                  Text(
                    data.businessInfo?.businessName ?? 'N/A',
                    style: AppTextStyles.heading1,
                  ),
                ],
              ),
              centerTitle: false,
              actions: <Widget>[
                InkWell(
                  onTap: () => context.push(RoutePaths.notification),
                  borderRadius: BorderRadius.circular(
                    AppSizes.borderRadiusMd,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: AppColors.paste50,
                      border: Border.all(color: AppColors.body, width: 1.0),
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMd,
                      ),
                    ),
                    child: const AssetLoader(
                      assetPath: AppIcons.notification,
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.sm,
                ),
                InkWell(
                  onTap: () => context.push(RoutePaths.conversations),
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: AppColors.paste50,
                      border: Border.all(color: AppColors.body, width: 1.0),
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMd,
                      ),
                    ),
                    child: const AssetLoader(
                      assetPath: AppIcons.chat,
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.sm,
                ),
              ],
            ),
            loading: () => const AppBarInfoShimmer(),
            error: (Object error, StackTrace stackTrace) =>
                const AppBarInfoShimmer(),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarInfoShimmer extends StatelessWidget {
  const AppBarInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, right: 8, left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Avatar placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Text placeholders
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 16,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                Container(
                  width: 40,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),

            const Spacer(),

            // Arrow placeholder
            Container(
              width: AppSizes.iconMd,
              height: AppSizes.iconMd,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
