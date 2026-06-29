// ignore_for_file: avoid_dynamic_calls

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/general/support_state.dart';

class SupportNotifier extends AutoDisposeNotifier<SupportState> {
  @override
  SupportState build() {
    Future<dynamic>.microtask(() {
      _retrieveSupport();
    });
    return const SupportState();
  }

  Future<void> _retrieveSupport() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ApiClient apiClient = ref.read(apiClientProvider);
      final Map<String, dynamic> response = await apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.support,
          );

      state = state.copyWith(
        htmlContent: response['data']['content'] as String,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load support content',
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrieveSupport();
  }
}
