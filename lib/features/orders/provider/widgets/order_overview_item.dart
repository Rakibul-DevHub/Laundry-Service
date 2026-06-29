import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/asset_loader.dart';

class OrderOverviewItem extends ConsumerWidget {
  final VoidCallback onTapCallBack;
  final String title;
  final int value;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const OrderOverviewItem({
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
        constraints: const BoxConstraints(
          minHeight: 180,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
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
            const SizedBox(height: AppSizes.sm),
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
      ),
    );
  }
}
