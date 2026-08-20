import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/config/legal_content.dart';
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

      final dynamic data = response['data'];
      final String? remote = data is Map<String, dynamic>
          ? data['content'] as String?
          : null;
      state = state.copyWith(
        htmlContent: LegalContent.looksLikePlaceholder(remote)
            ? LegalContent.termsAndConditions
            : remote!,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        htmlContent: LegalContent.termsAndConditions,
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrieveTermsAndConditions();
  }
}
