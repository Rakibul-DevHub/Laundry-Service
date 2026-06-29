// features/earnings/widgets/earnings_list_item.dart

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/colors.dart';
import '../models/earnings_model.dart';

class EarningsListItem extends ConsumerWidget {
  final EarningsModel earning;

  const EarningsListItem({
    super.key,
    required this.earning,
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
          // Header: Customer Info + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AssetLoader(
                      assetPath: earning.counterpartyPicture,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        earning.counterpartyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        earning.counterpartyPhone,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '\$${earning.amount.toStringAsFixed(2)}',
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

          // Locations: Pickup & Drop-off
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
                      earning.pickupLocation,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      earning.dropoffLocation,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

          // Items Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Items", style: AppTextStyles.paragraph1),
              Text(
                "${earning.totalItems} pcs",
                style: AppTextStyles.paragraph1,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          //  Items List - FIXED: Use Column instead of ListView
          Column(
            children: earning.items
                .map(
                  (EarningsItem item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.itemName,
                          style: AppTextStyles.paragraph1.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                        Text(
                          "${item.quantity} pcs",
                          style: AppTextStyles.paragraph1.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSizes.md),
          const DashedDivider(
            dashGap: 1,
            dashLength: 5.0,
            color: AppColors.body,
          ),
          const SizedBox(height: AppSizes.md),

          // Footer: Time + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.access_time_rounded,
                    size: 20,
                    color: AppColors.title,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    earning.formattedDate,
                    style: AppTextStyles.paragraph0,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
