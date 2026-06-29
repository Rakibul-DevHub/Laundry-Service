import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/shared/widgets/shimmer/card_single_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/colors.dart';
import '../../../../shared/widgets/shimmer/card_border_shimmer.dart';

class SummaryShimmer extends StatelessWidget {
  const SummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _SummaryCardShimmer()),
            SizedBox(width: 8),
            Expanded(child: _SummaryCardShimmer()),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(child: _SummaryCardShimmer()),
            SizedBox(width: 8),
            Expanded(child: _SummaryCardShimmer()),
          ],
        ),
      ],
    );
  }
}

class _SummaryCardShimmer extends StatelessWidget {
  const _SummaryCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: const CardBorderShimmer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSizes.spaceBetweenItems,
          children: <Widget>[
            SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),
            CardSingleItemShimmer(
              height: 20,
            ),
            CardSingleItemShimmer(
              height: 20,
            ),
            SizedBox(
              height: AppSizes.spaceBetweenItems,
            ),
          ],
        ),
      ),
    );
  }
}
