import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/colors.dart';

class MyBagItemShimmer extends StatelessWidget {
  const MyBagItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.title.withValues(alpha: 0.1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
      ),
    );
  }
}
