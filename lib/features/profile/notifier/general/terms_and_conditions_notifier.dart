// ignore_for_file: avoid_dynamic_calls

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/general/terms_and_conditions_state.dart';

class TermsAndConditionsNotifier
    extends AutoDisposeNotifier<TermsAndConditionsState> {
  @override
  TermsAndConditionsState build() {
    Future<dynamic>.microtask(() {
      _retrieveTermsAndConditions();
    });
    return const TermsAndConditionsState();
  }

  Future<void> _retrieveTermsAndConditions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ApiClient apiClient = ref.read(apiClientProvider);
      final Map<String, dynamic> response = await apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.termAndConditions,
          );

      state = state.copyWith(
        htmlContent: response['data']['content'] as String,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load Terms and Conditions content',
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrieveTermsAndConditions();
  }
}
