import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/home/rider/providers/home_rider_providers.dart';
import 'package:drop_n_fresh/shared/widgets/app_outline_button.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/extensions/date_time_extensions.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../models/jobs_request_model.dart';

class JobsRqListItem extends ConsumerWidget {
  final JobsRequestModel service;
  final VoidCallback onAcceptCallback;
  final VoidCallback onCancelCallback;

  const JobsRqListItem({
    super.key,
    required this.service,
    required this.onAcceptCallback,
    required this.onCancelCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
                      assetPath: service.customerProfile,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        service.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.customerPhone,
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
                    service.pricing.formattedTotal,
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
                service.serviceType,
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
                      service.pickupLocation,
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
                      service.dropOffLocation,
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
                "${service.totalItems} pcs",
                style: AppTextStyles.paragraph1,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ListView.separated(
            shrinkWrap: true,
            itemCount: service.items.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                  height: AppSizes.sm,
                ),
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    service.items[index].itemName,
                    style: AppTextStyles.paragraph1.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${service.items[index].quantity} pcs",
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
                        assetPath: service.instructions[index].icon,
                        width: 20,
                        height: 20,
                        color: AppColors.title,
                      ),
                      Text(
                        service.instructions[index].label,
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
              itemCount: service.instructions.length,
            ),
          ),

          const SizedBox(height: AppSizes.md),
          Text("Special Instructions", style: AppTextStyles.heading5),
          const SizedBox(height: AppSizes.md),
          Text(service.specialInstructions, style: AppTextStyles.paragraph0),

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
                    service.date.formattedTime,
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
                    service.date.formattedDate,
                    style: AppTextStyles.paragraph0.copyWith(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceBetweenItems),
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
                                    jobsRequestsProvider,
                                  )
                                  .acceptLoading
                                  .loading) &&
                              (ref
                                      .watch(
                                        jobsRequestsProvider,
                                      )
                                      .acceptLoading
                                      .orderId ==
                                  service.id),
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
    );
  }
}
