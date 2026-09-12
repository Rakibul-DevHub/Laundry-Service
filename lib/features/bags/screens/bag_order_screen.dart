// features/bags/screens/bag_order_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/styles/app_text_styles.dart';
import '../../../app/toast/toast.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/config/strings.dart';
import '../../../features/bags/state/order_bag_state.dart';
import '../../../shared/widgets/app_elevated_button.dart';
import '../../../shared/widgets/app_outline_button.dart';
import '../../../shared/widgets/asset_loader.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_refresh_indicator.dart';
import '../../home/user/notifier/default_location_notifier.dart';
import '../../profile/model/user_location_model.dart';
import '../../profile/notifier/user_location_notifier.dart';
import '../../profile/state/user_location_state.dart';
import '../models/order_bag_model.dart';
import '../providers/bags_providers.dart';
import '../widgets/order_bag_address_section.dart';
import '../widgets/order_delivery_timeline.dart';
import '../widgets/order_price_summary.dart';
import '../widgets/shimmer/order_bag_shimmer.dart';

class BagOrderScreen extends ConsumerWidget {
  const BagOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userLocationProvider);
    final OrderBagState state = ref.watch(orderBagProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Order Bag",
        showBackBtn: true,
      ),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await Future.wait(<Future<void>>[
            ref.read(orderBagProvider.notifier).refresh(),
            ref.read(userLocationProvider.notifier).refresh(),
            ref.read(defaultLocationProvider.notifier).refresh(),
          ]);
        },
        child: state.isLoading
            ? const OrderBagShimmer()
            : state.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(state.error!),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(orderBagProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.orderBag == null
            ? const Center(child: Text('No bag data available'))
            : _buildContent(state.orderBag!, state),
      ),
    );
  }

  Widget _buildContent(BagDetails bag, OrderBagState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontal,
        vertical: AppSizes.screenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Track And Review Your Orders',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: AppSizes.md),

          // Bag Image
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.md,
            ),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.paste50,
              border: Border.all(
                color: AppColors.primary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(
                AppSizes.borderRadiusXl,
              ),
            ),
            child: bag.imageUrl.isNotEmpty
                ? AssetLoader(
                    assetPath: bag.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  )
                : const Icon(
                    Icons.local_laundry_service,
                    size: 80,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(height: AppSizes.md),

          // Title & Description
          Text(
            bag.title,
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            bag.description,
            style: AppTextStyles.paragraph0.copyWith(
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Features (STATIC - from model, not API)
          Text(
            'Features:',
            style: AppTextStyles.heading5,
          ),
          const SizedBox(height: AppSizes.spaceBetweenItems),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSizes.xs,
            children: bag.benefits.map((String feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.xs),
                child: Row(
                  children: <Widget>[
                    const Text("•"),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: AppTextStyles.paragraph0.copyWith(
                        color: AppColors.body,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSizes.spaceBetweenItems),

          // Delivery Timeline (DYNAMIC - from API)
          OrderDeliveryTimeline(bag: bag),
          const SizedBox(height: AppSizes.md),

          // Price Summary (DYNAMIC - from API)
          OrderPriceSummary(bag: bag),
          const SizedBox(height: AppSizes.md),
          const OrderBagAddressSection(),
          const SizedBox(height: AppSizes.spaceBetweenSections),

          // Action Buttons
          OrderActions(bag: bag, state: state),
          const SizedBox(height: AppSizes.spaceBetweenSections),
        ],
      ),
    );
  }
}

class OrderActions extends ConsumerWidget {
  final BagDetails bag;
  final OrderBagState state;

  const OrderActions({super.key, required this.bag, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserLocationState locationState = ref.watch(userLocationProvider);
    final String? selectedLocationId = state.selectedLocationId;
    final String? deliveryLocationId =
        selectedLocationId != null &&
            locationState.savedLocations.any(
              (UserLocation location) => location.id == selectedLocationId,
            )
        ? selectedLocationId
        : locationState.savedLocations
                  .where((UserLocation location) => location.isDefault)
                  .firstOrNull
                  ?.id ??
              locationState.savedLocations.firstOrNull?.id;

    return Row(
      children: <Widget>[
        Expanded(
          child: AppOutlineButton(
            onPressed: () => context.pop(),
            label: AppStrings.cancel,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: AppElevatedButton(
            onPressed: () async {
              if (state.isLoading || state.isOrderLoading) {
                return;
              }
              if (deliveryLocationId == null) {
                Toast.showWarning(
                  'Add a delivery address to order a bag.',
                );
                await context.push(RoutePaths.userAddressAdd);
                if (!context.mounted) {
                  return;
                }
                await ref.read(userLocationProvider.notifier).refresh();
                return;
              }
              await ref
                  .read(orderBagProvider.notifier)
                  .orderExtraBag(locationId: deliveryLocationId);
            },
            label: 'Order',
            isLoading: state.isOrderLoading,
          ),
        ),
      ],
    );
  }
}
