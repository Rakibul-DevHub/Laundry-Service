import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/theme/styles/app_text_styles.dart';
import 'package:drop_n_fresh/features/orders/provider/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_refresh_indicator.dart';
import '../models/order_status_type.dart';
import '../providers/order_providers.dart';
import '../state/orders_state.dart';
import '../widgets/order_list_item.dart';
import '../widgets/shimmer/order_item_shimmer.dart';

class OrdersListScreenByStatus extends ConsumerWidget {
  final OrderStatusType type;

  const OrdersListScreenByStatus({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OrdersState state = ref.watch(ordersProvider(type));

    return Scaffold(
      appBar: CustomAppBar(
        title: type.typeToTitle,
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
          onRefresh: () => ref.read(ordersProvider(type).notifier).refresh(),
          child: state.isLoading
              ? CustomScrollView(
                  slivers: <Widget>[
                    SliverList.separated(
                      itemCount: 6,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                            height: AppSizes.spaceBetweenItems,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return const OrderItemShimmer();
                      },
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
                            ref.read(ordersProvider(type).notifier).refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : state.orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Orders in ${type.typeToTitle.toLowerCase()}",
                        style: AppTextStyles.paragraph0,
                      ),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: <Widget>[
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
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSizes.xl),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
