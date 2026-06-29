import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/colors.dart';
import '../../../../../shared/widgets/shimmer/card_border_shimmer.dart';
import '../../../../../shared/widgets/shimmer/card_single_item_shimmer.dart';

class UserOrderShimmer extends StatelessWidget {
  const UserOrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: CardBorderShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                CardSingleItemShimmer(
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardSingleItemShimmer(
                        width: 150,
                        height: 16,
                      ),
                      SizedBox(height: 4),
                      CardSingleItemShimmer(
                        width: 100,
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List<Expanded>.generate(6, (int index) {
                return Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const CardSingleItemShimmer(
                        width: 40,
                        height: 12,
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Row(
              children: <Widget>[
                CardSingleItemShimmer(
                  width: 80,
                  height: 24,
                ),
                SizedBox(width: 8),
                CardSingleItemShimmer(
                  width: 80,
                  height: 24,
                ),
                SizedBox(width: 8),
                CardSingleItemShimmer(
                  width: 80,
                  height: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardSingleItemShimmer(
                  width: 80,
                  height: 16,
                ),
                CardSingleItemShimmer(
                  width: 60,
                  height: 16,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardSingleItemShimmer(
                  width: 80,
                  height: 16,
                ),
                CardSingleItemShimmer(
                  width: 60,
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
