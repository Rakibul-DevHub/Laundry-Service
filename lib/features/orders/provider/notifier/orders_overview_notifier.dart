import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../models/orders_overview_model.dart';
import '../state/orders_overview_state.dart';

class OverviewNotifier extends AutoDisposeNotifier<OrdersOverviewState> {
  late final ApiClient _apiClient;

  @override
  OrdersOverviewState build() {
    _apiClient = ref.read(apiClientProvider);

    Future<dynamic>.microtask(() => _fetchOverview());
    return const OrdersOverviewState(isLoading: true);
  }

  Future<void> _fetchOverview() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final DashboardStatsResponse response = await _apiClient
          .handleRequest<DashboardStatsResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.providerDashboard,
            fromJson: DashboardStatsResponse.fromJson,
          );
      state = state.copyWith(overview: response.data);
    } catch (e) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    await _fetchOverview();
  }
}
