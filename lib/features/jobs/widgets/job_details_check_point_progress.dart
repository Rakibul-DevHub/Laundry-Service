import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../models/jobs_check_point_type.dart';

class JobDetailsCheckPointProgress extends ConsumerWidget {
  final JobsCheckPointType currentStatus;
  final bool isPickupLeg;

  const JobDetailsCheckPointProgress({
    super.key,
    required this.currentStatus,
    required this.isPickupLeg,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = currentStatus.statusToIndex;

    // Create 5 step indicators
    final List<Widget> steps = List<Container>.generate(isPickupLeg ? 5 : 4, (
      int index,
    ) {
      final bool isActive = index <= currentIndex;
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : AppColors.grey50,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: isActive
            ? const Icon(Icons.check, size: 20, color: AppColors.primary)
            : null,
      );
    });

    // Now interleave with dashed dividers: [step, dash, step, dash, ..., step]
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < steps.length; i++) {
      children.add(steps[i]);
      if (i < steps.length - 1) {
        // Add dashed line between steps
        children.add(
          const Expanded(
            child: DashedDivider(
              dashGap: 1,
              color: AppColors.body,
            ),
          ),
        );
      }
    }

    return Row(
      children: children,
    );
  }
}
