import 'package:drop_n_fresh/shared/widgets/shimmer/card_border_shimmer.dart';
import 'package:drop_n_fresh/shared/widgets/shimmer/card_header_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/colors.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: const CardBorderShimmer(
        child: Column(
          children: <Widget>[
            CardHeaderShimmer(
              isLastItem: false,
            ),
            //
          ],
        ),
      ),
    );
  }
}
