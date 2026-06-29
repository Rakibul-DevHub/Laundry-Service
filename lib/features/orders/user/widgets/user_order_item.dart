import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/colors.dart';
import '../models/user_order_model.dart';

class UserOrderItem extends ConsumerWidget {
  final UserOrderModel order;
  final VoidCallback onTap;

  const UserOrderItem({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          border: Border.all(
            color: AppColors.body.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.title.withValues(alpha: 0.05),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header: Provider + Service Info + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Provider Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AssetLoader(
                    assetPath: order.provider.profilePicture ?? '',
                    width: 52,
                    height: 52,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              order.provider.fullName,
                              style: AppTextStyles.paragraph1.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.body,
                          ),
                        ),
                        child: Text(
                          order.formattedBackendStatus,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            const DashedDivider(
              dashGap: 2,
              color: AppColors.body,
            ),
            const SizedBox(height: 8),

            Text(
              order.serviceName,
              style: AppTextStyles.paragraph0.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            if (order.orderItems.isNotEmpty) ...<Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...order.orderItems.map(
                    (OrderItemInfo item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${item.itemName} × ${item.quantity}',
                              style: AppTextStyles.paragraph1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${item.lineTotalDollars.toStringAsFixed(2)}',
                            style: AppTextStyles.paragraph1.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            const DashedDivider(
              dashGap: 2,
              color: AppColors.body,
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${order.totalItems} item${order.totalItems > 1 ? 's' : ''}',
                      style: AppTextStyles.paragraph1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Total",
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                Text(
                  '\$${order.totalCost.toStringAsFixed(2)}',
                  style: AppTextStyles.paragraph1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Ink(
              color: AppColors.primary,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'View',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
