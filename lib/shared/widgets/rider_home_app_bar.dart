import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/core/config/icons.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/styles/app_text_styles.dart';
import '../../core/config/colors.dart';
import '../../features/home/rider/widgets/rider_online_status.dart';
import '../../features/profile/providers/profile_providers.dart';
import '../../features/profile/state/rider_profile_state.dart';
import '../models/user_model.dart';
import 'asset_loader.dart';
import 'shimmer/app_bar_info_shimmer.dart';

class RiderHomeAppBar extends StatelessWidget {
  final bool isChatVisible;

  const RiderHomeAppBar({super.key, this.isChatVisible = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Logo (leading)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? widget) {
              final AsyncValue<User> user = ref.watch(
                riderProfileProvider.select(
                  (RiderProfileState value) => value.profileValue,
                ),
              );
              return user.when(
                data: (User data) => Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: AssetLoader(
                        assetPath: data.profilePicture,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Title (Welcome + Aqua Rider)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Welcome",
                          style: AppTextStyles.paragraph1.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                        Text(
                          data.firstName ?? 'N/A',
                          style: AppTextStyles.heading1,
                        ),
                      ],
                    ),
                  ],
                ),
                error: (Object error, StackTrace stackTrace) =>
                    const AppBarInfoShimmer(),
                loading: () => const AppBarInfoShimmer(),
              );
            },
          ),
          const Spacer(),

          if (isChatVisible)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
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
            ),

          const RiderOnlineStatus(),
        ],
      ),
    );
  }
}
