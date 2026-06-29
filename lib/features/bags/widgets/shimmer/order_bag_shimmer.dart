import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';

class OrderBagShimmer extends StatelessWidget {
  const OrderBagShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: AppColors.grey50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Bag Image
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Description
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Features
            Container(
              width: 100,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            ...List<Container>.generate(
              5,
              (_) => Container(
                width: double.infinity,
                height: 20,
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Delivery Timeline
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey100, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ...List<Padding>.generate(
                    3,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 80,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Price Summary
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Action Buttons
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
