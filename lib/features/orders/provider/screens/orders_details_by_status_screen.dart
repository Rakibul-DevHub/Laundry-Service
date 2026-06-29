// features/orders/provider/screens/orders_details_by_status_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/icons.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/core/extensions/date_time_extensions.dart';
import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:drop_n_fresh/features/orders/provider/models/orders_details_model.dart';
import 'package:drop_n_fresh/features/orders/provider/notifier/orders_details_notifier.dart';
import 'package:drop_n_fresh/features/orders/provider/providers/order_providers.dart';
import 'package:drop_n_fresh/features/orders/provider/state/orders_details_state.dart';
import 'package:drop_n_fresh/shared/widgets/app_elevated_button.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:drop_n_fresh/shared/widgets/custom_refresh_indicator.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../shared/widgets/shimmer/card_border_shimmer.dart';
import '../../../../shared/widgets/shimmer/card_header_shimmer.dart';
import '../../../../shared/widgets/shimmer/card_row_shimmer.dart';

class OrdersDetailsByStatusScreen extends ConsumerWidget {
  final String orderId;

  const OrdersDetailsByStatusScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrdersDetailsState state = ref.watch(ordersDetailProvider(orderId));
    final OrderDetailNotifier notifier = ref.read(
      ordersDetailProvider(orderId).notifier,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Order Detail",
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
      ),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => notifier.refresh(orderId),
        child: state.isLoading
            ? _buildShimmerContent()
            : state.error != null
            ? _buildErrorContent(
                error: state.error!,
                onRetry: () => notifier.refresh(orderId),
              )
            : state.order != null
            ? _buildContent(state.order!, ref)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey50,
      highlightColor: AppColors.grey100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CardBorderShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardHeaderShimmer(),
                  SizedBox(height: 16),
                  DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  SizedBox(height: 16),
                  CardRowShimmer(),
                  SizedBox(height: 16),
                  DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  SizedBox(height: 16),
                  CardRowShimmer(),
                  SizedBox(height: 16),
                  DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  SizedBox(height: 16),
                  CardRowShimmer(),
                  SizedBox(height: 16),
                  DashedDivider(
                    dashGap: 1,
                    dashLength: 5.0,
                    color: AppColors.body,
                  ),
                  SizedBox(height: 16),
                  CardRowShimmer(),
                  SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent({
    required String error,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48, color: AppColors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load order details',
            style: AppTextStyles.subTitle1.copyWith(color: AppColors.title),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(OrdersDetailsModel order, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCustomerInfo(order.userInfo),
          const SizedBox(height: AppSizes.md),

          _buildProviderInfo(order.providerInfo),
          const SizedBox(height: AppSizes.md),

          if (order.bags.isNotEmpty) ...<Widget>[
            _buildBagsInfo(order.bags),
            const SizedBox(height: AppSizes.md),
          ],

          _buildOrderItems(order.orderItems),
          const SizedBox(height: AppSizes.md),

          _buildPricing(order.pricing),
          const SizedBox(height: AppSizes.md),

          _buildLocations(order.pickupLocation, order.dropoffLocation),
          const SizedBox(height: AppSizes.md),

          _buildDeliveryInfo(order),
          const SizedBox(height: AppSizes.md),

          if (order.specialInstructions.isNotEmpty) ...<Widget>[
            _buildSpecialInstructions(order.specialInstructions),
            const SizedBox(height: AppSizes.md),
          ],
          _buildActionButtons(order, ref),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrdersDetailsModel order, WidgetRef ref) {
    // Map OrdersDetailsModel.orderStatusType to OrderStatusType
    final OrderStatusType orderStatusType = order.orderStatusType;

    if (orderStatusType == OrderStatusType.newBookings) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return AppElevatedButton(
                  isLoading:
                      (ref
                          .watch(ordersProvider(orderStatusType))
                          .cancelLoading
                          .loading) &&
                      (ref
                              .watch(ordersProvider(orderStatusType))
                              .cancelLoading
                              .orderId ==
                          order.id),
                  onPressed: () async {
                    if (ref
                        .watch(ordersProvider(orderStatusType))
                        .cancelLoading
                        .loading) {
                      return;
                    }
                    await ref
                        .read(ordersProvider(orderStatusType).notifier)
                        .cancelOrder(order.id);
                    ref
                        .read(
                          ordersDetailProvider(orderId).notifier,
                        )
                        .refresh(orderId);
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
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return AppElevatedButton(
                  isLoading:
                      (ref
                          .watch(ordersProvider(orderStatusType))
                          .acceptLoading
                          .loading) &&
                      (ref
                              .watch(ordersProvider(orderStatusType))
                              .acceptLoading
                              .orderId ==
                          order.id),
                  onPressed: () async {
                    if (ref
                        .watch(ordersProvider(orderStatusType))
                        .acceptLoading
                        .loading) {
                      return;
                    }
                    await ref
                        .read(ordersProvider(orderStatusType).notifier)
                        .acceptOrder(order.id);
                    ref
                        .read(
                          ordersDetailProvider(orderId).notifier,
                        )
                        .refresh(orderId);
                  },
                  label: 'Accept',
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                );
              },
            ),
          ),
        ],
      );
    } else if (orderStatusType == OrderStatusType.receivedOrders) {
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return AppElevatedButton(
            isLoading:
                (ref
                    .watch(ordersProvider(orderStatusType))
                    .markAsProcessingLoading
                    .loading) &&
                (ref
                        .watch(ordersProvider(orderStatusType))
                        .markAsProcessingLoading
                        .orderId ==
                    order.id),
            onPressed: () async {
              if (ref
                  .watch(ordersProvider(orderStatusType))
                  .markAsProcessingLoading
                  .loading) {
                return;
              }
              await ref
                  .read(ordersProvider(orderStatusType).notifier)
                  .markAsProcessing(order.id);
              ref
                  .read(
                    ordersDetailProvider(orderId).notifier,
                  )
                  .refresh(orderId);
            },
            label: 'Mark As Processing',
          );
        },
      );
    } else if (orderStatusType == OrderStatusType.readyToReceive) {
      return Consumer(
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
            label: 'Mark As Processing',
          );
        },
      );
    } else if (orderStatusType == OrderStatusType.processingOrders) {
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return AppElevatedButton(
            isLoading:
                (ref
                    .watch(ordersProvider(orderStatusType))
                    .markAsReadyForDeliveryLoading
                    .loading) &&
                (ref
                        .watch(ordersProvider(orderStatusType))
                        .markAsReadyForDeliveryLoading
                        .orderId ==
                    order.id),
            onPressed: () async {
              if (ref
                  .watch(ordersProvider(orderStatusType))
                  .markAsReadyForDeliveryLoading
                  .loading) {
                return;
              }
              await ref
                  .read(ordersProvider(orderStatusType).notifier)
                  .markAsReadyForDelivery(order.id);
              ref
                  .read(
                    ordersDetailProvider(orderId).notifier,
                  )
                  .refresh(orderId);
            },
            label: 'Mark As Ready',
          );
        },
      );
    }

    // No action buttons for other statuses (completed, cancelled, etc.)
    return const SizedBox.shrink();
  }

  Widget _buildCustomerInfo(UserInfo user) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Customer', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: user.profilePicture ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Container(
                    width: 50,
                    height: 50,
                    color: AppColors.paste200,
                    child: const Icon(Icons.person, color: AppColors.body),
                  ),
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Container(
                            width: 50,
                            height: 50,
                            color: AppColors.paste200,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.body,
                            ),
                          ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.fullName,
                      style: AppTextStyles.paragraph1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.phone,
                          size: 14,
                          color: AppColors.body,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.phoneNumber,
                          style: AppTextStyles.paragraph3.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.email,
                          size: 14,
                          color: AppColors.body,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.email,
                            style: AppTextStyles.paragraph3.copyWith(
                              color: AppColors.body,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  Provider Info Card
  Widget _buildProviderInfo(ProviderInfo provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Provider', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: provider.profilePicture ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Container(
                    width: 50,
                    height: 50,
                    color: AppColors.paste200,
                    child: const Icon(Icons.business, color: AppColors.body),
                  ),
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Container(
                            width: 50,
                            height: 50,
                            color: AppColors.paste200,
                            child: const Icon(
                              Icons.business,
                              color: AppColors.body,
                            ),
                          ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      provider.businessName,
                      style: AppTextStyles.paragraph1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.fullName,
                      style: AppTextStyles.paragraph3.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBagsInfo(List<BagInfo> bags) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Bags', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          ...bags.map(
            (BagInfo bag) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const AssetLoader(
                        assetPath: AppIcons.bag,
                        width: 24,
                        height: 24,
                        color: AppColors.body,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            bag.displayCode,
                            style: AppTextStyles.paragraph1.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(List<OrderItemInfo> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Order Items', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          ...items.map(
            (OrderItemInfo item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.itemName,
                          style: AppTextStyles.paragraph0.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${item.productCategoryName} • ${item.serviceName}',
                          style: AppTextStyles.paragraph1.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '× ${item.quantity}',
                        style: AppTextStyles.paragraph2.copyWith(
                          color: AppColors.body,
                        ),
                      ),
                      Text(
                        '\$${item.lineTotalDollars.toStringAsFixed(2)}',
                        style: AppTextStyles.paragraph1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricing(PricingInfo pricing) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Pricing', style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          _priceRow(
            'Items',
            '\$${pricing.itemsTotalDollars.toStringAsFixed(2)}',
          ),
          if (pricing.platformFee > 0)
            _priceRow(
              'Platform Fee',
              '\$${pricing.platformFeeDollars.toStringAsFixed(2)}',
            ),
          if (pricing.pickupFee > 0)
            _priceRow(
              'Pickup Fee',
              '\$${pricing.pickupFeeDollars.toStringAsFixed(2)}',
            ),
          if (pricing.deliveryFee > 0)
            _priceRow(
              'Delivery Fee',
              '\$${pricing.deliveryFeeDollars.toStringAsFixed(2)}',
            ),
          if (pricing.deliveryCharge > 0)
            _priceRow(
              'Delivery Charge',
              '\$${pricing.deliveryChargeDollars.toStringAsFixed(2)}',
            ),
          const SizedBox(height: 8),
          const DashedDivider(dashGap: 2, color: AppColors.body),
          const SizedBox(height: 8),
          _priceRow(
            'Total',
            '\$${pricing.totalDollars.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: (AppTextStyles.paragraph0).copyWith(
              color: isTotal ? AppColors.title : AppColors.body,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: (AppTextStyles.paragraph0).copyWith(
              color: isTotal ? AppColors.primary : AppColors.title,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocations(LocationInfo? pickup, LocationInfo? dropOff) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Locations', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          if (pickup?.address != null) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Pickup',
                        style: AppTextStyles.paragraph2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pickup!.address!,
                        style: AppTextStyles.paragraph1.copyWith(
                          color: AppColors.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (dropOff?.address != null) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.flag, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Drop-off',
                        style: AppTextStyles.paragraph2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dropOff!.address!,
                        style: AppTextStyles.paragraph1.copyWith(
                          color: AppColors.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(OrdersDetailsModel order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Delivery Details', style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          _infoRow(
            'Driver Type',
            order.driverType == 'HIRE_CARRIER' ? 'Hire Carrier' : 'Self Pickup',
          ),
          _infoRow('Delivery Mode', order.deliveryMode),
          _infoRow('Zone', order.deliveryZone),
          _infoRow('Distance', '${order.distanceKm.toStringAsFixed(2)} km'),
          _infoRow(
            'Instruction',
            _formatDeliveryInstruction(order.deliveryInstruction),
          ),
          if (order.scheduledPickupDate != null)
            _infoRow(
              'Scheduled',
              '${DateTime.tryParse(order.scheduledPickupDate!)?.formattedDate} • ${order.scheduledPickupSlot}',
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.paragraph1)),
        ],
      ),
    );
  }

  String _formatDeliveryInstruction(String instruction) {
    switch (instruction.toUpperCase()) {
      case 'TAKE_FROM_DOOR':
        return 'Take from door';
      case 'KNOCK_AT_DOOR':
        return 'Knock at door';
      case 'LEAVE_AT_DOOR':
        return 'Leave at door';
      case 'AVOID_BELL':
        return 'Avoid bell';
      default:
        return instruction;
    }
  }

  Widget _buildSpecialInstructions(String instructions) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.body.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Special Instructions',
                style: AppTextStyles.paragraph2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            instructions,
            style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
          ),
        ],
      ),
    );
  }
}
