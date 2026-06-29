import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/asset_loader.dart';

class JobsOverviewItem extends ConsumerWidget {
  final VoidCallback onTapCallBack;
  final String title;
  final int value;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const JobsOverviewItem({
    super.key,
    required this.onTapCallBack,
    required this.title,
    required this.value,
    required this.iconPath,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTapCallBack,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
      child: Container(
        constraints: const BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentGeometry.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: AppSizes.spaceBetweenItems),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading5.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  '$value',
                  style: AppTextStyles.heading1.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -20,
              left: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: borderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
                ),
                padding: const EdgeInsets.all(AppSizes.sm),
                child: AssetLoader(
                  assetPath: iconPath,
                  width: 24,
                  height: 24,
                  color: borderColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
