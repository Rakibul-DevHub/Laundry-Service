// features/bags/notifiers/order_bag_notifier.dart

import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/app/router/route_paths.dart';
import 'package:drop_n_fresh/app/toast/toast.dart';
import 'package:drop_n_fresh/features/bags/providers/bags_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../core/utils/app_logger.dart';
import '../models/bag_checkout_response_model.dart';
import '../models/order_bag_model.dart';
import '../state/order_bag_state.dart';

class OrderBagNotifier extends AutoDisposeNotifier<OrderBagState> {
  late final ApiClient _apiClient;

  @override
  OrderBagState build() {
    _apiClient = ref.read(apiClientProvider);
    // Auto-fetch on init
    Future<dynamic>.microtask(() => _fetchOrderBag());
    return const OrderBagState(isLoading: true);
  }

  Future<void> _fetchOrderBag() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final BagDetailsResponse response = await _apiClient
          .handleRequest<BagDetailsResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.bagDetails,
            fromJson: BagDetailsResponse.fromJson,
          );

      state = state.copyWith(
        orderBag: response.data,
        isLoading: false,
      );
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
      );
      AppLogger().e(
        'Failed to fetch bag details: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> orderExtraBag() async {
    state = state.copyWith(isLoading: false, isOrderLoading: true, error: null);

    try {
      final BagCheckoutResponseModel response = await _apiClient
          .handleRequest<BagCheckoutResponseModel>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.bagCheckout,
            fromJson: BagCheckoutResponseModel.fromJson,
          );

      if (response.data.checkoutUrl != null &&
          response.data.checkoutUrl!.isNotEmpty) {
        await ref
            .read(appRouterProvider)
            .push(
              RoutePaths.userBagCheckout,
              extra: response.data.checkoutUrl,
            );
        ref.read(myBagProvider.notifier).refresh();
      } else {
        Toast.showSuccess(response.message);
        ref.read(appRouterProvider).pop();
      }
    } catch (e, stack) {
      Toast.showError(ExceptionHandler.errorMessage(e));
      AppLogger().e(
        'Failed to fetch bag details: $e',
        error: e,
        stackTrace: stack,
      );
    } finally {
      state = state.copyWith(
        isLoading: false,
        isOrderLoading: false,
      );
    }
  }

  Future<void> refresh() async {
    await _fetchOrderBag();
  }
}
