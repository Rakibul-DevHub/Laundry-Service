import 'dart:async';

import 'package:drop_n_fresh/core/config/colors.dart';
import 'package:drop_n_fresh/core/config/sizes.dart';
import 'package:drop_n_fresh/features/orders/user/models/user_order_model.dart';
import 'package:drop_n_fresh/features/orders/user/notifier/user_orders_notifier.dart';
import 'package:drop_n_fresh/shared/widgets/custom_app_bar.dart';
import 'package:drop_n_fresh/shared/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/styles/app_text_styles.dart';
import '../providers/order_user.dart';
import '../state/user_orders_state.dart';
import '../widgets/shimmer/user_order_shimmer.dart';
import '../widgets/user_order_item.dart';

class OrdersUserScreen extends ConsumerStatefulWidget {
  const OrdersUserScreen({super.key});

  @override
  ConsumerState<OrdersUserScreen> createState() => _OrdersUserScreenState();
}

class _OrdersUserScreenState extends ConsumerState<OrdersUserScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _loadMoreTimer;
  bool _isRequestingMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _loadMoreTimer?.cancel();
    super.dispose();
  }

  void _onScroll(UserOrdersState state) {
    // Don't load if already loading, no more pages, or already requesting
    if (state.isLoading || !state.hasMore || _isRequestingMore) {
      return;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    // Trigger when within 200px of bottom
    if (currentScroll >= maxScroll - 200) {
      // Debounce to avoid multiple rapid calls
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted &&
            !state.isLoading &&
            state.hasMore &&
            !_isRequestingMore) {
          _isRequestingMore = true;
          ref
              .read(userOrdersProvider.notifier)
              .loadMore()
              .then((_) {
                if (mounted) {
                  _isRequestingMore = false;
                }
              })
              .catchError((_) {
                if (mounted) {
                  _isRequestingMore = false;
                }
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserOrdersState state = ref.watch(userOrdersProvider);
    final UserOrdersNotifier notifier = ref.read(userOrdersProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "My Orders",
        showBackBtn: false,
        titleAlignment: TitleAlignment.left,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontal,
          vertical: AppSizes.screenVertical,
        ),
        child: CustomRefreshIndicator(
          onRefresh: () => notifier.refresh(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                _onScroll(state);
              }
              return false;
            },
            child: _buildBody(state, notifier),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(UserOrdersState state, UserOrdersNotifier notifier) {
    // Loading state (initial)
    if (state.isLoading && state.orders.isEmpty) {
      return _buildShimmerContent();
    }

    // Error state
    if (state.error != null) {
      return _buildErrorContent(
        error: state.error!,
        onRetry: () => notifier.refresh(),
      );
    }

    // Empty state
    if (state.orders.isEmpty) {
      return _buildEmptyContent();
    }

    // Success state with data
    return _buildContent(state, notifier);
  }

  Widget _buildShimmerContent() {
    return CustomScrollView(
      controller: _scrollController, //  Attach for pagination
      slivers: <Widget>[
        SliverList.separated(
          itemCount: 6,
          separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (_, _) => const UserOrderShimmer(),
        ),
      ],
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
            'Failed to load orders',
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

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.shopping_bag, size: 64, color: AppColors.body),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: AppTextStyles.subTitle1.copyWith(color: AppColors.title),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by placing your first order',
            style: AppTextStyles.paragraph2.copyWith(color: AppColors.body),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(UserOrdersState state, UserOrdersNotifier notifier) {
    return CustomScrollView(
      controller: _scrollController, //  Attach for pagination
      slivers: <Widget>[
        // Header
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Track and review your orders',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: AppSizes.spaceBetweenItems),
            ],
          ),
        ),

        if (state.orders.isNotEmpty) ...<Widget>[
          SliverList.separated(
            //  Add 1 more item for loading indicator if hasMore
            itemCount: state.orders.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (BuildContext context, int index) {
              //  Show loading indicator at end when loading more
              if (index == state.orders.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final UserOrderModel order = state.orders[index];
              return UserOrderItem(
                order: order,
                onTap: () => context.push(
                  RoutePaths.userOrdersDetails,
                  extra: order.id,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spaceBetweenSections),
          ),
        ],
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }
}
