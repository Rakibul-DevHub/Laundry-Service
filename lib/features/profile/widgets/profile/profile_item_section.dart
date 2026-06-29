import 'package:flutter/material.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/icons.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/dashed_divider.dart';

class ProfileItemSection extends StatelessWidget {
  final String title;
  final Widget child;
  const ProfileItemSection({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.body, width: .5),
        borderRadius: BorderRadius.circular(
          AppSizes.borderRadiusXl,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.sm,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.heading4,
          ),
          child,
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final bool isDivider;
  final String title;
  final VoidCallback onTapCallback;
  const ProfileItem({
    super.key,
    required this.onTapCallback,
    required this.title,
    this.isDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTapCallback,
          borderRadius: BorderRadius.circular(
            8,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.paragraph0,
                ),
                const AssetLoader(
                  assetPath: AppIcons.next,
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  color: AppColors.body,
                ),
              ],
            ),
          ),
        ),
        if (isDivider) ...<Widget>[
          const SizedBox(
            height: AppSizes.sm,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
          ),
        ],
      ],
    );
  }
}
