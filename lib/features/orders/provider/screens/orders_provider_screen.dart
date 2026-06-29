import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../../../shared/widgets/provider_home_app_bar.dart';
import '../models/order_status_type.dart';
import '../providers/order_providers.dart';
import '../state/orders_overview_state.dart';
import '../widgets/order_overview_item.dart';
import '../widgets/shimmer/order_overview_shimmer.dart';

class OrdersProviderScreen extends ConsumerWidget {
  const OrdersProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrdersOverviewState state = ref.watch(ordersOverviewProvider);

    return Scaffold(
      appBar: const ProviderHomeAppBar(),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => ref.read(ordersOverviewProvider.notifier).refresh(),
        child: state.isLoading
            ? CustomScrollView(
                slivers: <Widget>[
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: AppSizes.spaceBetweenItems,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontal,
                      vertical: AppSizes.screenVertical,
                    ),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return const OrderOverviewShimmer();
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: AppSizes.spaceBetweenItems,
                    ),
                  ),
                ],
              )
            : state.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(state.error!),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(ordersOverviewProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.overview == null
            ? const SizedBox.shrink()
            : CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.screenHorizontal,
                        vertical: AppSizes.screenVertical,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Manage your services, orders, and earnings from one place.',
                            style: AppTextStyles.paragraph0.copyWith(
                              color: AppColors.body,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Masonry Grid Content
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontal,
                      vertical: AppSizes.screenVertical,
                    ),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        switch (index) {
                          case 0:
                            return OrderOverviewItem(
                              title: OrderStatusType.newBookings.typeToTitle,
                              value: state.overview!.newBookings,
                              iconPath: OrderStatusType.newBookings.typeToIcon,
                              backgroundColor: AppColors.paste50,
                              borderColor: AppColors.primary,
                              textColor: AppColors.title,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.newBookings,
                                );
                              },
                            );
                          case 1:
                            return OrderOverviewItem(
                              title: OrderStatusType.acceptOrders.typeToTitle,
                              value: state.overview!.acceptOrders,
                              iconPath: OrderStatusType.acceptOrders.typeToIcon,
                              backgroundColor: AppColors.green50,
                              borderColor: AppColors.green,
                              textColor: AppColors.title,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.acceptOrders,
                                );
                              },
                            );
                          case 2:
                            return OrderOverviewItem(
                              title: OrderStatusType.readyToReceive.typeToTitle,
                              value: state.overview!.readyToReceive,
                              iconPath:
                                  OrderStatusType.readyToReceive.typeToIcon,
                              backgroundColor: AppColors.white,
                              borderColor: AppColors.primary,
                              textColor: AppColors.primary,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.readyToReceive,
                                );
                              },
                            );
                          case 3:
                            return OrderOverviewItem(
                              title: OrderStatusType.receivedOrders.typeToTitle,
                              value: state.overview!.receivedOrders,
                              iconPath:
                                  OrderStatusType.receivedOrders.typeToIcon,
                              backgroundColor: AppColors.white,
                              borderColor: AppColors.primary,
                              textColor: AppColors.primary,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.receivedOrders,
                                );
                              },
                            );
                          case 4:
                            return OrderOverviewItem(
                              title:
                                  OrderStatusType.processingOrders.typeToTitle,
                              value: state.overview!.processingOrders,
                              iconPath:
                                  OrderStatusType.processingOrders.typeToIcon,
                              backgroundColor: AppColors.grey50,
                              borderColor: AppColors.body,
                              textColor: AppColors.title,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.processingOrders,
                                );
                              },
                            );
                          case 5:
                            return OrderOverviewItem(
                              title:
                                  OrderStatusType.readyForDelivery.typeToTitle,
                              value: state.overview!.readyForDelivery,
                              iconPath:
                                  OrderStatusType.readyForDelivery.typeToIcon,
                              backgroundColor: AppColors.green50,
                              borderColor: AppColors.green,
                              textColor: AppColors.title,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.readyForDelivery,
                                );
                              },
                            );
                          case 6:
                            return OrderOverviewItem(
                              title:
                                  OrderStatusType.completedOrders.typeToTitle,
                              value: state.overview!.completedOrders,
                              iconPath:
                                  OrderStatusType.completedOrders.typeToIcon,
                              backgroundColor: AppColors.green100,
                              borderColor: AppColors.green,
                              textColor: AppColors.title,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.completedOrders,
                                );
                              },
                            );
                          case 7:
                            return OrderOverviewItem(
                              title: OrderStatusType.canceledOrders.typeToTitle,
                              value: state.overview!.canceledOrders,
                              iconPath:
                                  OrderStatusType.canceledOrders.typeToIcon,
                              backgroundColor: AppColors.red50,
                              borderColor: AppColors.red200,
                              textColor: AppColors.title,
                              onTapCallBack: () {
                                context.push(
                                  RoutePaths.providerOrdersByStatus,
                                  extra: OrderStatusType.canceledOrders,
                                );
                              },
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
