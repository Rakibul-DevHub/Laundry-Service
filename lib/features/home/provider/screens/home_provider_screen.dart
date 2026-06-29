import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/core/extensions/context_extensions.dart';
import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:drop_n_fresh/features/orders/provider/models/orders_model.dart';
import 'package:drop_n_fresh/features/orders/provider/providers/order_providers.dart';
import 'package:drop_n_fresh/features/orders/provider/state/orders_state.dart';
import 'package:drop_n_fresh/features/orders/provider/widgets/order_list_item.dart';
import 'package:drop_n_fresh/features/orders/provider/widgets/shimmer/order_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../../../shared/widgets/provider_home_app_bar.dart';
import '../providers/home_providers.dart';
import '../widgets/shimmer/service_request_shimmer.dart';

class HomeProviderScreen extends ConsumerWidget {
  const HomeProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrdersState state = ref.watch(
      ordersProvider(OrderStatusType.newBookings),
    );

    return Scaffold(
      appBar: const ProviderHomeAppBar(),
      backgroundColor: AppColors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => ref
            .read(ordersProvider(OrderStatusType.newBookings).notifier)
            .refresh(),
        child: state.isLoading
            ? CustomScrollView(
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
                          Container(
                            width: 150,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontal,
                      vertical: AppSizes.screenVertical,
                    ),
                    sliver: SliverList.separated(
                      itemCount: 6,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                            height: AppSizes.spaceBetweenItems,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return const ServiceRequestShimmer();
                      },
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
                          ref.read(serviceRequestsProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontal - 8,
                  vertical: AppSizes.screenVertical,
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (state.orders.isNotEmpty)
                            Text(
                              "New Service Request",
                              style: AppTextStyles.heading3,
                            ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: AppSizes.sm,
                      ),
                    ),
                    if (state.orders.isEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: context.screenHeight * .7,
                          child: Center(
                            child: Text(
                              "No Service Request Available",
                              style: AppTextStyles.paragraph0,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList.separated(
                        itemCount:
                            state.orders.length +
                            (state.isLoading && state.hasMore ? 1 : 0),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                              height: AppSizes.spaceBetweenItems,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          if (index < state.orders.length) {
                            final OrdersModel order = state.orders[index];

                            // Use your existing OrderItemCard widget
                            return OrderListItem(
                              order: order,
                              onTapCallback: () {
                                context.push(
                                  RoutePaths.providerOrdersDetailsByStatus,
                                  extra: order.id,
                                );
                              },
                            );
                          } else if (state.isLoading && state.hasMore) {
                            return const OrderItemShimmer();
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
