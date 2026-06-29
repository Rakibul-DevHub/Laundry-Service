import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/jobs/models/jobs_status_type.dart';
import 'package:drop_n_fresh/features/jobs/providers/jobs_providers.dart';
import 'package:drop_n_fresh/shared/widgets/app_outline_button.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/extensions/date_time_extensions.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../models/jobs_model.dart';

class JobsListItem extends ConsumerWidget {
  final JobsModel jobs;
  final JobStatusType type;

  final VoidCallback onTapCallback;
  final VoidCallback onAcceptCallback;
  final VoidCallback onCancelCallback;

  const JobsListItem({
    super.key,
    required this.jobs,
    required this.type,
    required this.onTapCallback,
    required this.onCancelCallback,
    required this.onAcceptCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTapCallback,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),

      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          border: Border.all(width: .5, color: AppColors.body),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.title.withValues(alpha: 0.1),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AssetLoader(
                        assetPath: jobs.customerProfile,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          jobs.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          jobs.customerPhone,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '\$${jobs.pricing.total}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Service Type",
                  style: AppTextStyles.paragraph1,
                ),
                const SizedBox(height: 4),
                Text(
                  jobs.serviceType,
                  style: AppTextStyles.paragraph1.copyWith(
                    color: AppColors.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),

            const SizedBox(height: AppSizes.md),

            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Pickup',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobs.pickupLocation,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Drop Off',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobs.dropOffLocation,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            const SizedBox(height: AppSizes.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Items",
                  style: AppTextStyles.paragraph1,
                ),
                const SizedBox(height: 4),
                Text(
                  "${jobs.totalItems} pcs",
                  style: AppTextStyles.paragraph1,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            ListView.separated(
              shrinkWrap: true,
              itemCount: jobs.items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      jobs.items[index].itemName,
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${jobs.items[index].quantity} pcs",
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSizes.md),
            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            const SizedBox(height: AppSizes.md),

            Text("Instructions", style: AppTextStyles.heading5),
            const SizedBox(height: AppSizes.md),

            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.body, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AssetLoader(
                          assetPath: jobs.instructions[index].icon,
                          width: 20,
                          height: 20,
                          color: AppColors.title,
                        ),
                        Text(
                          jobs.instructions[index].label,
                          style: AppTextStyles.paragraph3,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      width: AppSizes.sm,
                    ),
                itemCount: jobs.instructions.length,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text("Special Instructions", style: AppTextStyles.heading5),
            const SizedBox(height: AppSizes.md),
            Text(jobs.specialInstructions, style: AppTextStyles.paragraph0),

            const SizedBox(height: AppSizes.md),
            const DashedDivider(
              dashGap: 1,
              dashLength: 5.0,
              color: AppColors.body,
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  spacing: AppSizes.xs,
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: AppColors.title,
                    ),
                    Text(
                      jobs.date.formattedTime,
                      style: AppTextStyles.paragraph0.copyWith(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  spacing: AppSizes.xs,

                  children: <Widget>[
                    const Icon(
                      Icons.date_range,
                      size: 20,
                      color: AppColors.title,
                    ),

                    Text(
                      jobs.date.formattedDate,
                      style: AppTextStyles.paragraph0.copyWith(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBetweenItems),
            if (type == JobStatusType.newOrders)
              Row(
                spacing: AppSizes.sm,
                children: <Widget>[
                  Expanded(
                    child: Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                            return AppOutlineButton(
                              isLoading:
                                  (ref
                                      .watch(
                                        jobsProvider(type),
                                      )
                                      .acceptLoading
                                      .loading) &&
                                  (ref
                                          .watch(
                                            jobsProvider(type),
                                          )
                                          .acceptLoading
                                          .orderId ==
                                      jobs.id),
                              label: "Accept",
                              backgroundColor: AppColors.green50,
                              outlineColor: AppColors.green,
                              onPressed: onAcceptCallback,
                            );
                          },
                    ),
                  ),
                  Expanded(
                    child: AppOutlineButton(
                      label: "Remove",
                      backgroundColor: AppColors.red50,
                      outlineColor: AppColors.red,
                      onPressed: onCancelCallback,
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
