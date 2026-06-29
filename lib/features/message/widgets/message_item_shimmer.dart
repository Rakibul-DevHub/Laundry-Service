// features/messaging/widgets/message_item_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/colors.dart';

class MessageItemShimmer extends StatelessWidget {
  final bool isMe;

  const MessageItemShimmer({super.key, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary : AppColors.grey100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 150,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
