import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/colors.dart';
import '../../../../../shared/widgets/shimmer/card_border_shimmer.dart';
import '../../../../../shared/widgets/shimmer/card_single_item_shimmer.dart';

class OrderOverviewShimmer extends StatelessWidget {
  const OrderOverviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: const CardBorderShimmer(
        child: Column(
          spacing: AppSizes.sm,
          children: <Widget>[
            SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),
            CardSingleItemShimmer(
              height: 40,
              width: 40,
            ),
            CardSingleItemShimmer(),
            CardSingleItemShimmer(),
            SizedBox(
              height: AppSizes.sm,
            ),
          ],
        ),
      ),
    );
  }
}
