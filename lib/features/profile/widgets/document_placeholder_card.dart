import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/images.dart';
import '../../../core/extensions/context_extensions.dart';

class DocumentPlaceholderCard extends StatelessWidget {
  final bool isFront;
  final String title;
  final String supportDesc;
  final VoidCallback onPick;

  const DocumentPlaceholderCard({
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
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              isFront
                  ? AppImages.frontIdPlaceholder
                  : AppImages.backIdPlaceholder,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSizes.sm,
          children: <Widget>[
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading3,
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
