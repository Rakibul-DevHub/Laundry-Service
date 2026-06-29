import 'package:flutter/material.dart';

import '../../app/theme/styles/app_text_styles.dart';
import '../../core/config/colors.dart';
import '../../core/config/sizes.dart';
import 'app_elevated_button.dart';
import 'asset_loader.dart';

class SuccessSheet extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const SuccessSheet({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AssetLoader(
            assetPath: iconAsset,
            width: 100,
            height: 100,
          ),
          const SizedBox(height: AppSizes.spaceBetweenItems),
          Text(
            title,
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
          ),
          const SizedBox(height: AppSizes.spaceBetweenSections),
          AppElevatedButton(
            onPressed: onConfirm,
            label: 'OK',
          ),
        ],
      ),
    );
  }
}
