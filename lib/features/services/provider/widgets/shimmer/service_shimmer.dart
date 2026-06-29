import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/shared/widgets/shimmer/card_single_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/colors.dart';
import '../../../../../shared/widgets/dashed_divider.dart';
import '../../../../../shared/widgets/shimmer/card_border_shimmer.dart';

class ServiceShimmer extends StatelessWidget {
  const ServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: const CardBorderShimmer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSizes.md,
                children: <Widget>[
                  CardSingleItemShimmer(
                    width: 50,
                    height: 50,
                  ),
                  CardSingleItemShimmer(
                    width: 150,
                    height: 16,
                  ),
                  CardSingleItemShimmer(
                    width: 80,
                    height: 20,
                  ),

                  //
                  CardSingleItemShimmer(
                    width: double.infinity,
                    height: 8,
                  ),
                  CardSingleItemShimmer(
                    width: double.infinity,
                    height: 8,
                  ),
                  CardSingleItemShimmer(
                    width: double.infinity,
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Center(
              child: DashedDivider(
                isVertical: true,
                length: 100,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: AppSizes.spaceBetweenItems,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CardSingleItemShimmer(
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 4),
                      CardSingleItemShimmer(
                        width: 50,
                        height: 12,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      CardSingleItemShimmer(
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 4),
                      Column(
                        spacing: 8,

                        children: <Widget>[
                          CardSingleItemShimmer(
                            width: 50,
                            height: 8,
                          ),
                          CardSingleItemShimmer(
                            width: 50,
                            height: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CardSingleItemShimmer(
                    width: double.infinity,
                    height: 20,
                  ),
                  CardSingleItemShimmer(
                    width: double.infinity,
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
