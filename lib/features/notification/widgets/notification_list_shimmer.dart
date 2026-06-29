import 'package:flutter/material.dart';

import '../../../core/config/sizes.dart';
import 'notification_item_shimmer.dart';

class NotificationListShimmer extends StatelessWidget {
  const NotificationListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: AppSizes.sm,
      ),
      itemBuilder: (BuildContext context, int index) {
        return const NotificationShimmer();
      },
    );
  }
}
