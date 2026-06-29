// features/orders/provider/notifiers/order_detail_notifier.dart

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/orders/provider/models/orders_details_model.dart';
import 'package:drop_n_fresh/features/orders/provider/state/orders_details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailNotifier
    extends AutoDisposeFamilyNotifier<OrdersDetailsState, String> {
  late final ApiClient _apiClient;

  @override
  OrdersDetailsState build(String orderId) {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchOrder(orderId));
    return const OrdersDetailsState(isLoading: true);
  }

  Future<void> _fetchOrder(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: '${ApiEndpoints.providerOrders}/$orderId',
          );

      final OrdersDetailsModel order = OrdersDetailsModel.fromApiResponse(
        response['data'] as Map<String, dynamic>,
      );

      state = state.copyWith(order: order, isLoading: false);
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
      );
      AppLogger().e(
        'Failed to fetch order details: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> refresh(String orderId) async {
    await _fetchOrder(orderId);
  }

  void startScanning() => state = state.copyWith(isScanning: true);
  void stopScanning() => state = state.copyWith(isScanning: false);
  void setScannedQrCode(dynamic qrCode) =>
      state = state.copyWith(scannedQrCode: qrCode, isScanning: false);
}
