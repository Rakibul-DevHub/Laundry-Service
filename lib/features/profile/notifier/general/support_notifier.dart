import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/core/config/legal_content.dart';
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

      final dynamic data = response['data'];
      final String? remote = data is Map<String, dynamic>
          ? data['content'] as String?
          : null;
      state = state.copyWith(
        htmlContent: LegalContent.looksLikePlaceholder(remote)
            ? LegalContent.support
            : remote!,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        htmlContent: LegalContent.support,
        isLoading: false,
      );
    }
  }

  Future<void> refreshContent() async {
    _retrieveSupport();
  }
}
