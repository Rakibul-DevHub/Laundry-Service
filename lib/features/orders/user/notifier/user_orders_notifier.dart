// features/orders/user/notifiers/user_orders_notifier.dart

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/orders/user/models/user_order_model.dart';
import 'package:drop_n_fresh/features/orders/user/state/user_orders_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserOrdersNotifier extends AutoDisposeNotifier<UserOrdersState> {
  late final ApiClient _apiClient;

  @override
  UserOrdersState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchOrders());
    return const UserOrdersState(isLoading: true);
  }

  Future<void> _fetchOrders({int page = 1}) async {
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      isLoadingMore: isLoadingMore,
      error: null,
    );

    try {
      final UserOrdersResponse response = await _apiClient
          .handleRequest<UserOrdersResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.userServiceOrdersList,
            fromJson: UserOrdersResponse.fromJson,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '10',
            },
          );

      if (!response.success) {
        throw Exception(response.message);
      }

      final List<UserOrderModel> newOrders = response.data.orders;

      if (isLoadingMore) {
        state = state.copyWith(
          orders: <UserOrderModel>[...state.orders, ...newOrders],
          currentPage: page,
          totalPages: response.data.pagination.totalPages,
          hasMore: response.data.pagination.hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          orders: newOrders,
          currentPage: page,
          totalPages: response.data.pagination.totalPages,
          hasMore: response.data.pagination.hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isLoadingMore: false,
      );
      AppLogger().e('Failed to fetch orders: $e', error: e, stackTrace: stack);
    }
  }

  Future<void> refresh() async {
    await _fetchOrders(page: 1);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isLoadingMore) {
      return;
    }
    await _fetchOrders(page: state.currentPage + 1);
  }
}
