import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/config/legal_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/general/privacy_policy_state.dart';

class PrivacyPolicyNotifier extends AutoDisposeNotifier<PrivacyPolicyState> {
  @override
  PrivacyPolicyState build() {
    Future<dynamic>.microtask(() {
      _retrievePrivacyPolicy();
    });
    return const PrivacyPolicyState();
  }

  Future<void> _retrievePrivacyPolicy() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ApiClient apiClient = ref.read(apiClientProvider);
      final Map<String, dynamic> response = await apiClient
          .handleRequest<Map<String, dynamic>>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.privacyPolicy,
          );

      final dynamic data = response['data'];
      final String? remote = data is Map<String, dynamic>
          ? data['content'] as String?
          : null;
      state = state.copyWith(
        htmlContent: LegalContent.looksLikePlaceholder(remote)
            ? LegalContent.privacyPolicy
            : remote!,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        htmlContent: LegalContent.privacyPolicy,
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrievePrivacyPolicy();
  }
}
