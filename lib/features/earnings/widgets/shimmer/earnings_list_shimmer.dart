import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:flutter/material.dart';

import 'earnings_list_item_shimmer.dart';

class EarningsListShimmer extends StatelessWidget {
  const EarningsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.md,
      children: <Widget>[
        ...List<EarningsListItemShimmer>.generate(
          5,
          (_) => const EarningsListItemShimmer(),
        ),
      ],
    );
  }
}
