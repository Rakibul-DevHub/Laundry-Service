import 'package:flutter/material.dart';

import 'card_single_item_shimmer.dart';

class CardRowShimmer extends StatelessWidget {
  const CardRowShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CardSingleItemShimmer(
          width: 120,
          height: 12,
        ),
        SizedBox(width: 12),
        CardSingleItemShimmer(
          width: 100,
          height: 12,
        ),
      ],
    );
  }
}
