import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/colors.dart';
import '../../../../../shared/widgets/dashed_divider.dart';
import '../../../../../shared/widgets/shimmer/card_border_shimmer.dart';
import '../../../../../shared/widgets/shimmer/card_header_shimmer.dart';
import '../../../../../shared/widgets/shimmer/card_row_shimmer.dart';

class JobsItemShimmer extends StatelessWidget {
  const JobsItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: const CardBorderShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CardHeaderShimmer(),
            SizedBox(height: 16),
            DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            SizedBox(height: 16),
            CardRowShimmer(),
            SizedBox(height: 16),
            DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            SizedBox(height: 16),
            CardRowShimmer(),
            SizedBox(height: 16),
            DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            SizedBox(height: 16),
            CardRowShimmer(),
            SizedBox(height: 16),
            DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            SizedBox(height: 16),
            CardRowShimmer(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
