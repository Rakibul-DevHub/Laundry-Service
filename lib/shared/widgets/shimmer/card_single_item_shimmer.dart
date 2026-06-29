import 'package:flutter/material.dart';

import '../../../core/config/colors.dart';

class CardSingleItemShimmer extends StatelessWidget {
  final double width;
  final double height;
  const CardSingleItemShimmer({
    super.key,
    this.width = 120,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
