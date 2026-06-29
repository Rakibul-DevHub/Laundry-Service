// features/messaging/widgets/conversation_item_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/colors.dart';

class ConversationItemShimmer extends StatelessWidget {
  const ConversationItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 16,
                    color: AppColors.grey300,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: AppColors.grey300,
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
