// features/orders/user/screens/user_order_details_screen.dart

import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/icons.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/orders/user/notifier/user_order_details_notifier.dart';
import 'package:drop_n_fresh/features/orders/user/state/user_order_details_state.dart';
import 'package:drop_n_fresh/shared/widgets/asset_loader.dart';
import 'package:drop_n_fresh/shared/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../models/user_order_details_model.dart';
import '../providers/order_user.dart';
import '../widgets/shimmer/order_details_shimmer.dart';

class UserOrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const UserOrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserOrderDetailsState state = ref.watch(
      userOrderDetailsProvider(orderId),
    );
    final UserOrderDetailsNotifier notifier = ref.read(
      userOrderDetailsProvider(orderId).notifier,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Order Details",
        showBackBtn: true,
        titleAlignment: TitleAlignment.left,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: CustomRefreshIndicator(
          onRefresh: () => notifier.refresh(orderId),
          child: state.isLoading
              ? CustomScrollView(
                  slivers: <Widget>[
                    SliverList.separated(
                      itemCount: 4,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSizes.sm),
                      itemBuilder: (_, _) => const OrderDetailsShimmer(),
                    ),
                  ],
                )
              : state.error != null
              ? _buildErrorContent(
                  error: state.error!,
                  onRetry: () => notifier.refresh(orderId),
                )
              : state.orderDetails != null
              ? _buildContent(state.orderDetails!)
              : const SizedBox.shrink(),
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

  Widget _buildContent(UserOrderDetailsModel order) {
    return CustomScrollView(
      slivers: <Widget>[
        // Bags Info
        if (order.bags.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildBagsInfo(order.bags),
          ),
        if (order.bags.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),

        // 13-Step Timeline (scrollable)
        SliverToBoxAdapter(
          child: _buildTimeline(order.orderTimeline),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),

        // Provider Info
        SliverToBoxAdapter(
          child: _buildProviderInfo(order.provider),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),

        // Order Items
        SliverToBoxAdapter(
          child: _buildOrderItems(order.orderItems),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),

        // Pricing Breakdown
        SliverToBoxAdapter(
          child: _buildPricing(order.pricing),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),

        // Delivery Info
        SliverToBoxAdapter(
          child: _buildDeliveryInfo(order),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // 13-Step Timeline Widget
  Widget _buildTimeline(List<OrderTimeline> timeline) {
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
          Text('Order Timeline', style: AppTextStyles.heading3),
          const SizedBox(height: 16),

          ...timeline.asMap().entries.map((MapEntry<int, OrderTimeline> entry) {
            final int index = entry.key;
            final OrderTimeline step = entry.value;
            final bool isLast = index == timeline.length - 1;

            return _VerticalTimelineStep(
              step: step,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _VerticalTimelineStep extends StatelessWidget {
  final OrderTimeline step;
  final bool isLast;

  const _VerticalTimelineStep({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            // Step Circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: step.isCompleted ? AppColors.primary : AppColors.grey50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isCompleted
                      ? AppColors.primary
                      : AppColors.grey300,
                  width: 0,
                ),
              ),
              child: Center(
                child: Text(
                  '${step.step}',
                  style: AppTextStyles.paragraph0.copyWith(
                    color: step.isCompleted ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 32,
                margin: const EdgeInsets.only(top: 4),
                color: step.isCompleted ? AppColors.primary : AppColors.grey200,
              ),
          ],
        ),

        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Step Title
                Text(
                  step.title,
                  style: AppTextStyles.paragraph0.copyWith(
                    color: step.isCompleted
                        ? AppColors.primary
                        : AppColors.body,
                  ),
                ),
                const SizedBox(height: 4),

                // Step Description
                Text(
                  step.description,
                  style: AppTextStyles.paragraph1.copyWith(
                    color: step.isCompleted ? AppColors.title : AppColors.body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Provider Info Widget
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
        Text('Provider', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            // Provider Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AssetLoader(
                assetPath: provider.profilePicture ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    provider.businessName,
                    style: AppTextStyles.paragraph0.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.fullName,
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
    ),
  );
}

// Order Items Widget
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
        Text('Order Items', style: AppTextStyles.heading3),
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
                      style: AppTextStyles.paragraph0.copyWith(
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

// Bags Info Widget
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
        Text('Bags', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        ...bags.map(
          (BagInfo bag) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                const AssetLoader(
                  assetPath: AppIcons.bag,
                  width: 20,
                  height: 20,
                  color: AppColors.title,
                ),
                const SizedBox(width: 8),
                Text(
                  bag.displayCode,
                  style: AppTextStyles.paragraph1,
                ),
                const Spacer(),
                Text(
                  bag.formattedStatus,
                  style: AppTextStyles.paragraph1,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Pricing Widget
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
        Text('Pricing', style: AppTextStyles.heading3),
        const SizedBox(height: 8),
        _priceRow('Items', '\$${pricing.itemsTotalDollars.toStringAsFixed(2)}'),
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
        const SizedBox(
          height: 8,
        ),
        const DashedDivider(dashGap: 2, color: AppColors.body),
        const SizedBox(
          height: 8,
        ),
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
          style: (AppTextStyles.paragraph2).copyWith(
            color: isTotal ? AppColors.title : AppColors.body,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: (AppTextStyles.paragraph2).copyWith(
            color: isTotal ? AppColors.primary : AppColors.title,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

// Delivery Info Widget
Widget _buildDeliveryInfo(UserOrderDetailsModel order) {
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
        Text('Delivery Details', style: AppTextStyles.heading3),
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
            '${DateFormat('MMM d, yyyy').format(DateTime.parse(order.scheduledPickupDate!))} • ${order.scheduledPickupSlot}',
          ),
        if (order.specialInstructions.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            'Special Instructions',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.specialInstructions,
            style: AppTextStyles.paragraph0.copyWith(color: AppColors.body),
          ),
        ],
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
            style: AppTextStyles.paragraph1.copyWith(color: AppColors.body),
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
