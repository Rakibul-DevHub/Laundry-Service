// features/orders/user/notifiers/user_order_details_notifier.dart

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/orders/user/models/user_order_details_model.dart';
import 'package:drop_n_fresh/features/orders/user/state/user_order_details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserOrderDetailsNotifier
    extends AutoDisposeFamilyNotifier<UserOrderDetailsState, String> {
  // arg = orderId

  late final ApiClient _apiClient;

  @override
  UserOrderDetailsState build(String orderId) {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchOrderDetails(orderId));
    return const UserOrderDetailsState(isLoading: true);
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final Map<String, dynamic> response = await _apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: "${ApiEndpoints.userServiceOrders}/$orderId",
          );

      final UserOrderDetailsModel orderDetails =
          UserOrderDetailsModel.fromApiResponse(
            response['data'] as Map<String, dynamic>,
          );

      state = state.copyWith(
        orderDetails: orderDetails,
        isLoading: false,
      );
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
    await _fetchOrderDetails(orderId);
  }
}
