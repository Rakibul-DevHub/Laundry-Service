import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../models/jobs_overview_model.dart';
import '../state/jobs_overview_state.dart';

class JobsOverviewNotifier extends AutoDisposeNotifier<JobsOverviewState> {
  late final ApiClient _apiClient;

  @override
  JobsOverviewState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchOverview());
    return const JobsOverviewState(isLoading: true);
  }

  Future<void> _fetchOverview() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final RiderDashboardStatsResponse response = await _apiClient
          .handleRequest<RiderDashboardStatsResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.riderDashboard,
            fromJson: RiderDashboardStatsResponse.fromJson,
          );
      state = state.copyWith(overview: response.data);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load overview',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    await _fetchOverview();
  }
}
