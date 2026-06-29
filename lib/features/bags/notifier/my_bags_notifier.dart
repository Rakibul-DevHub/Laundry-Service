import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../models/bag_model.dart';
import '../state/my_bags_state.dart';

class BagNotifier extends AutoDisposeNotifier<MyBagsState> {
  @override
  MyBagsState build() {
    Future<dynamic>.microtask(() => _fetchBags());
    return const MyBagsState(isLoading: true);
  }

  Future<void> _fetchBags() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final BagListResponse response = await ref
          .read(apiClientProvider)
          .handleRequest<BagListResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.userBags,
            fromJson: BagListResponse.fromJson,
          );

      state = state.copyWith(bags: response.data, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load bags',
        isLoading: false,
      );
    }
  }

  Future<void> refresh() async {
    await _fetchBags();
  }
}
