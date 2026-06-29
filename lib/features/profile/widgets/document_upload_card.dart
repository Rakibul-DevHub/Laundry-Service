import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/icons.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../shared/widgets/asset_loader.dart';

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconAsset;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showStatus;
  final bool isUploaded;

  const DocumentUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconAsset = AppIcons.idIcon,
    this.onTap,
    this.onLongPress,
    this.showStatus = false,
    this.isUploaded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Create the card content
    Widget cardContent = Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.title, width: 1.0),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      child: Row(
        spacing: AppSizes.md,
        children: <Widget>[
          AssetLoader(
            assetPath: iconAsset,
            width: 78,
            height: 58,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.sm,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.heading4,
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.paragraph1,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Wrap with interactive overlay ONLY if needed
    if (onTap != null || onLongPress != null) {
      cardContent = _InteractiveCard(
        onTap: onTap,
        onLongPress: onLongPress,
        child: cardContent,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.xs,
      children: <Widget>[
        cardContent,
        if (showStatus)
          if (isUploaded)
            Text(
              AppStrings.uploaded,
              style: AppTextStyles.paragraph0.copyWith(
                color: AppColors.green,
              ),
            )
          else
            Text(
              AppStrings.notUploaded,
              style: AppTextStyles.paragraph0.copyWith(
                color: AppColors.red,
              ),
            ),
      ],
    );
  }
}

/// Handles tap/long-press with visual feedback
class _InteractiveCard extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  const _InteractiveCard({
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
