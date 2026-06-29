import 'package:flutter/material.dart';

import '../../../app/theme/styles/app_text_styles.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/colors.dart';
import '../../../core/extensions/context_extensions.dart';

class ImagePlaceholderCard extends StatelessWidget {
  final bool isFront;
  final String title;
  final String supportDesc;
  final VoidCallback onPick;

  const ImagePlaceholderCard({
    super.key,
    required this.onPick,
    required this.title,
    required this.supportDesc,
    this.isFront = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 200,
        width: context.screenWidth,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.title, width: 1),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSizes.sm,
          children: <Widget>[
            const Spacer(
              flex: 2,
            ),
            const Icon(
              Icons.open_in_browser_rounded,
              size: 24.0,
              color: AppColors.body,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              supportDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
            ),
            const SizedBox(
              height: AppSizes.xs,
            ),
          ],
        ),
      ),
    );
  }
}
