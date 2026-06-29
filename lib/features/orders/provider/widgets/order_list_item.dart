import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:drop_n_fresh/features/orders/provider/providers/order_providers.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/extensions/date_time_extensions.dart';
import '../../../../shared/widgets/asset_loader.dart';
import '../models/orders_model.dart';

class OrderListItem extends ConsumerWidget {
  final OrdersModel order;
  final VoidCallback onTapCallback;

  const OrderListItem({
    super.key,
    required this.order,
    required this.onTapCallback,
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
          border: Border.all(width: .5, color: statusColor),
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
                        assetPath: order.customerProfile,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.customerPhone,
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
                      '\$${order.amount}',
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
                  order.serviceType,
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
                        order.pickUpAddress,
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
                        order.dropOffAddress,
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
                  "${order.totalItems} pcs",
                  style: AppTextStyles.paragraph1,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            ListView.separated(
              shrinkWrap: true,
              itemCount: order.items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                    height: AppSizes.sm,
                  ),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      order.items[index].itemName,
                      style: AppTextStyles.paragraph1.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${order.items[index].quantity} pcs",
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
                      order.date.formattedTime,
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
                      order.date.formattedDate,
                      style: AppTextStyles.paragraph0.copyWith(),
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
            if (order.orderStatusType == OrderStatusType.newBookings)
              Row(
                children: <Widget>[
                  Expanded(
                    child: Consumer(
                      builder:
                          (
                            BuildContext context,
                            WidgetRef ref,
                            Widget? child,
                          ) {
                            return AppElevatedButton(
                              isLoading:
                                  (ref
                                      .watch(
                                        ordersProvider(order.orderStatusType),
                                      )
                                      .cancelLoading
                                      .loading) &&
                                  (ref
                                          .watch(
                                            ordersProvider(
                                              order.orderStatusType,
                                            ),
                                          )
                                          .cancelLoading
                                          .orderId ==
                                      order.id),
                              onPressed: () {
                                if (ref
                                    .watch(
                                      ordersProvider(order.orderStatusType),
                                    )
                                    .cancelLoading
                                    .loading) {
                                  return;
                                }
                                ref
                                    .read(
                                      ordersProvider(
                                        order.orderStatusType,
                                      ).notifier,
                                    )
                                    .cancelOrder(
                                      order.id,
                                    );
                              },
                              label: 'Cancel',
                              backgroundColor: AppColors.white,
                              textColor: AppColors.red,
                              borderColor: AppColors.red,
                            );
                          },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                            return AppElevatedButton(
                              isLoading:
                                  (ref
                                      .watch(
                                        ordersProvider(order.orderStatusType),
                                      )
                                      .acceptLoading
                                      .loading) &&
                                  (ref
                                          .watch(
                                            ordersProvider(
                                              order.orderStatusType,
                                            ),
                                          )
                                          .acceptLoading
                                          .orderId ==
                                      order.id),
                              onPressed: () {
                                if (ref
                                    .watch(
                                      ordersProvider(order.orderStatusType),
                                    )
                                    .acceptLoading
                                    .loading) {
                                  return;
                                }
                                ref
                                    .read(
                                      ordersProvider(
                                        order.orderStatusType,
                                      ).notifier,
                                    )
                                    .acceptOrder(
                                      order.id,
                                    );
                              },
                              label: 'Accept',
                              backgroundColor: AppColors.primary,
                              textColor: AppColors.white,
                            );
                          },
                    ),
                  ),
                ],
              )
            else if (order.orderStatusType == OrderStatusType.receivedOrders)
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return AppElevatedButton(
                    isLoading:
                        (ref
                            .watch(
                              ordersProvider(order.orderStatusType),
                            )
                            .markAsProcessingLoading
                            .loading) &&
                        (ref
                                .watch(
                                  ordersProvider(
                                    order.orderStatusType,
                                  ),
                                )
                                .markAsProcessingLoading
                                .orderId ==
                            order.id),
                    onPressed: () {
                      if (ref
                          .watch(
                            ordersProvider(order.orderStatusType),
                          )
                          .markAsProcessingLoading
                          .loading) {
                        return;
                      }
                      ref
                          .read(
                            ordersProvider(
                              order.orderStatusType,
                            ).notifier,
                          )
                          .markAsProcessing(
                            order.id,
                          );
                    },
                    label: 'Mark As Processing',
                  );
                },
              )
            else if (order.orderStatusType == OrderStatusType.processingOrders)
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return AppElevatedButton(
                    isLoading:
                        (ref
                            .watch(
                              ordersProvider(order.orderStatusType),
                            )
                            .markAsReadyForDeliveryLoading
                            .loading) &&
                        (ref
                                .watch(
                                  ordersProvider(
                                    order.orderStatusType,
                                  ),
                                )
                                .markAsReadyForDeliveryLoading
                                .orderId ==
                            order.id),
                    onPressed: () {
                      if (ref
                          .watch(
                            ordersProvider(order.orderStatusType),
                          )
                          .markAsReadyForDeliveryLoading
                          .loading) {
                        return;
                      }
                      ref
                          .read(
                            ordersProvider(
                              order.orderStatusType,
                            ).notifier,
                          )
                          .markAsReadyForDelivery(
                            order.id,
                          );
                    },
                    label: 'Mark As Ready',
                  );
                },
              )
            else if (order.orderStatusType == OrderStatusType.readyToReceive)
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return AppElevatedButton(
                    onPressed: () {
                      context.push(
                        RoutePaths.orderScanQrScreen,
                        extra: <String, dynamic>{
                          "orderId": order.id,
                          "status": order.orderStatusType,
                        },
                      );
                    },
                    label: 'Scan Bag',
                  );
                },
              ),
            const SizedBox(height: AppSizes.spaceBetweenItems),
          ],
        ),
      ),
    );
  }

  Color get statusColor {
    switch (order.orderStatusType) {
      case OrderStatusType.newBookings:
        return AppColors.body;
      case OrderStatusType.acceptOrders:
        return AppColors.body;
      case OrderStatusType.completedOrders:
        return AppColors.green;
      case OrderStatusType.canceledOrders:
        return AppColors.red;
      default:
        return AppColors.body;
    }
  }
}
