import 'package:flutter/material.dart';

import 'card_single_item_shimmer.dart';

class CardHeaderShimmer extends StatelessWidget {
  final bool isLastItem;
  const CardHeaderShimmer({super.key, this.isLastItem = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const CardSingleItemShimmer(
          width: 50,
          height: 50,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardSingleItemShimmer(
                width: 100,
                height: 16,
              ),
              SizedBox(height: 4),
              CardSingleItemShimmer(
                width: 80,
                height: 12,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (isLastItem)
          const CardSingleItemShimmer(
            width: 50,
            height: 16,
          ),
      ],
    );
  }
}
