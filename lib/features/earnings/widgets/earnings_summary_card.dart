import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/asset_loader.dart';

class EarningsSummaryCard extends ConsumerWidget {
  final String title;
  final String amount;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTapCallback;

  const EarningsSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.iconPath,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        GestureDetector(
          onTap: onTapCallback,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 50),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              border: Border.all(color: borderColor, width: 1),
            ),
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: AppSizes.sm,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.paragraph1.copyWith(
                    color: borderColor,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.paragraph1.copyWith(
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: -16,
          left: 12,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: borderColor, width: .5),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            ),
            child: AssetLoader(
              assetPath: iconPath,
              width: AppSizes.iconMd,
              height: AppSizes.iconMd,
              color: borderColor,
            ),
          ),
        ),
      ],
    );
  }
}
