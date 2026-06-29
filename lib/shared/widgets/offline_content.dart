import 'package:flutter/material.dart';

import '../../app/theme/styles/app_text_styles.dart';
import '../../core/config/colors.dart';
import '../../core/config/sizes.dart';

class OfflineContent extends StatelessWidget {
  const OfflineContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppSizes.md,
      children: <Widget>[
        Text(
          "You Are Offline",
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1,
        ),
        Text(
          "You won't receive new orders while offline. Click the button below to go online and start getting orders.",
          textAlign: TextAlign.center,
          style: AppTextStyles.paragraph0.copyWith(
            color: AppColors.body,
            height: 2.0,
          ),
        ),
      ],
    );
  }
}
