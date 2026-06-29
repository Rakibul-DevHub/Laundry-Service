// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/orders/provider/models/order_status_type.dart';
import 'package:drop_n_fresh/features/orders/provider/models/orders_model.dart';
import 'package:drop_n_fresh/features/orders/provider/providers/order_providers.dart';
import 'package:drop_n_fresh/features/orders/provider/state/orders_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersNotifier
    extends AutoDisposeFamilyNotifier<OrdersState, OrderStatusType> {
  late final ApiClient _apiClient;

  @override
  OrdersState build(OrderStatusType type) {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchOrders());
    return OrdersState(type: type);
  }

  Future<void> _fetchOrders({int page = 1}) async {
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      error: null,
    );

    try {
      final String? statusFilter = _mapEnumToBackendStatus(state.type);
      if (statusFilter == null) {
        ref.read(appRouterProvider).pop();
        return;
      }

      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.providerOrders,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '15',
              'status': statusFilter,
            },
          );
      final List<dynamic> ordersJson =
          (response['data'] as Map<String, dynamic>)['orders'] as List;
      final Map<String, dynamic> paginationJson =
          (response['data'] as Map<String, dynamic>)['pagination']
              as Map<String, dynamic>;

      final List<OrdersModel> newOrders = ordersJson
          .map(
            (orderJson) =>
                OrdersModel.fromApiResponse(orderJson as Map<String, dynamic>),
          )
          .toList();

      final int totalPages = paginationJson['totalPages'] as int;
      final bool hasMore = (paginationJson['page'] as int) < totalPages;

      if (isLoadingMore) {
        //  Append for pagination
        state = state.copyWith(
          orders: <OrdersModel>[...state.orders, ...newOrders],
          page: page,
          hasMore: hasMore,
          isLoading: false,
        );
      } else {
        //  Replace for fresh load
        state = state.copyWith(
          orders: newOrders,
          page: page,
          hasMore: hasMore,
          isLoading: false,
        );
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
      );
      AppLogger().e('Failed to fetch orders: $e', error: e, stackTrace: stack);
    }
  }

  String? _mapEnumToBackendStatus(OrderStatusType type) {
    switch (type) {
      case OrderStatusType.newBookings:
        return 'PENDING';
      case OrderStatusType.acceptOrders:
        return 'CONFIRMED,AWAITING_PICKUP_RIDER';
      case OrderStatusType.receivedOrders:
        return 'RECEIVED_AT_PROVIDER';
      case OrderStatusType.readyToReceive:
        return 'ARRIVED_AT_PROVIDER';
      case OrderStatusType.processingOrders:
        return 'IN_PROCESSING';
      case OrderStatusType.readyForDelivery:
        return 'AWAITING_DELIVERY_RIDER';
      case OrderStatusType.completedOrders:
        return 'DELIVERED';
      case OrderStatusType.canceledOrders:
        return 'CANCELLED';
    }
  }

  Future<void> refresh() async {
    await _fetchOrders(page: 1);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) {
      return;
    }
    await _fetchOrders(page: state.page + 1);
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      state = state.copyWith(
        acceptLoading: Loading(loading: true, orderId: orderId),
      );
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.patch,
            endpoint: '${ApiEndpoints.providerOrders}/$orderId/status',
            data: <String, String>{'status': 'CONFIRMED'},
          );

      state = state.copyWith(
        orders: state.orders
            .where((OrdersModel order) => order.id != orderId)
            .toList(),
      );
      ref.read(ordersOverviewProvider.notifier).refresh();
      Toast.showSuccess(
        response['message'] as String? ?? 'Order accepted successfully',
      );
    } catch (e, stack) {
      AppLogger().e('Failed to accept order: $e', error: e, stackTrace: stack);
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        acceptLoading: Loading(loading: false, orderId: orderId),
      );
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      state = state.copyWith(
        cancelLoading: Loading(loading: true, orderId: orderId),
      );
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.patch,
            endpoint: '${ApiEndpoints.providerOrders}/$orderId/status',
            data: <String, String>{'status': 'CANCELLED'},
          );

      state = state.copyWith(
        orders: state.orders
            .where((OrdersModel order) => order.id != orderId)
            .toList(),
      );
      ref.read(ordersOverviewProvider.notifier).refresh();
      Toast.showSuccess(
        response['message'] as String? ?? 'Order cancelled successfully',
      );
    } catch (e, stack) {
      AppLogger().e('Failed to cancel order: $e', error: e, stackTrace: stack);
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        cancelLoading: Loading(loading: false, orderId: orderId),
      );
    }
  }

  Future<void> markAsProcessing(String orderId) async {
    try {
      state = state.copyWith(
        markAsProcessingLoading: Loading(loading: true, orderId: orderId),
      );
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.patch,
            endpoint: '${ApiEndpoints.providerOrders}/$orderId/status',
            data: <String, String>{'status': 'IN_PROCESSING'},
          );

      state = state.copyWith(
        orders: state.orders
            .where((OrdersModel order) => order.id != orderId)
            .toList(),
      );
      ref.read(ordersOverviewProvider.notifier).refresh();
      Toast.showSuccess(
        response['message'] as String? ??
            'Order marked as processing successfully',
      );
    } catch (e, stack) {
      AppLogger().e(
        'Failed to mark order as processing: $e',
        error: e,
        stackTrace: stack,
      );
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        markAsProcessingLoading: Loading(loading: false, orderId: orderId),
      );
    }
  }

  Future<void> markAsReadyForDelivery(String orderId) async {
    try {
      state = state.copyWith(
        markAsReadyForDeliveryLoading: Loading(loading: true, orderId: orderId),
      );
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.patch,
            endpoint: '${ApiEndpoints.providerOrders}/$orderId/status',
            data: <String, String>{'status': 'READY_FOR_DELIVERY'},
          );

      state = state.copyWith(
        orders: state.orders
            .where((OrdersModel order) => order.id != orderId)
            .toList(),
      );
      ref.read(ordersOverviewProvider.notifier).refresh();
      Toast.showSuccess(
        response['message'] as String? ??
            'Order marked as ready for delivery successfully',
      );
    } catch (e, stack) {
      AppLogger().e(
        'Failed to mark order as ready for delivery: $e',
        error: e,
        stackTrace: stack,
      );
      Toast.showError(ExceptionHandler.errorMessage(e));
    } finally {
      state = state.copyWith(
        markAsReadyForDeliveryLoading: Loading(
          loading: false,
          orderId: orderId,
        ),
      );
    }
  }

  Future<void> scanPickupBags({
    required String qrCode,
    required String orderId,
  }) async {
    state = state.copyWith(
      readyToReceiveDelivery: Loading(loading: true, orderId: orderId),
    );
    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.post,
            endpoint: '${ApiEndpoints.providerOrders}/$orderId/scan-intake',
            data: <String, Object>{
              'qrCode': qrCode,
            },
          );

      state = state.copyWith(
        orders: state.orders
            .where((OrdersModel order) => order.id != orderId)
            .toList(),
      );
      ref.read(ordersOverviewProvider.notifier).refresh();
      Toast.showSuccess(
        response['message'] as String? ?? 'Order Received',
      );
    } catch (e) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      rethrow;
    }
  }
}
