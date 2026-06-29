import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/sizes.dart';

class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: <Widget>[
          // Avatar placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: AppSizes.md),

          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 16,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // Arrow placeholder
          Container(
            width: AppSizes.iconMd,
            height: AppSizes.iconMd,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
