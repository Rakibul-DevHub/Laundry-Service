import 'package:flutter/material.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/icons.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/widgets/asset_loader.dart';

class ProfileCard extends StatelessWidget {
  final User profile;
  final VoidCallback onNavigation;
  const ProfileCard({
    super.key,
    required this.profile,
    required this.onNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onNavigation,
      child: Row(
        spacing: AppSizes.md,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AssetLoader(
              assetPath: profile.profilePicture,
              width: 56,
              height: 56,
              shape: BoxShape.rectangle,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.fullName,
                  style: AppTextStyles.heading3,
                ),
                Text(
                  profile.email,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.paragraph0.copyWith(
                    color: AppColors.body,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNavigation,
            child: const AssetLoader(
              assetPath: AppIcons.next,
              width: AppSizes.iconMd,
              height: AppSizes.iconMd,
              color: AppColors.title,
            ),
          ),
        ],
      ),
    );
  }
}
