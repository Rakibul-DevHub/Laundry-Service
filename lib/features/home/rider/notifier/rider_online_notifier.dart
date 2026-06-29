import 'package:drop_n_fresh/features/profile/state/rider_profile_state.dart';
import 'package:drop_n_fresh/shared/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/toast/toast.dart';
import '../../../profile/providers/profile_providers.dart';

class OnlineStatusNotifier extends Notifier<bool> {
  late final ApiClient _apiClient;

  @override
  bool build() {
    _apiClient = ref.read(apiClientProvider);

    // Initialize from RiderProfileNotifier
    final RiderProfileState profileState = ref.read(riderProfileProvider);
    return _extractOnlineStatus(profileState);
  }

  // Helper to extract online status from profile state
  bool _extractOnlineStatus(RiderProfileState state) {
    return state.profileValue.when(
      data: (User user) => user.riderVerification?.isActive ?? false,
      loading: () => false, // Default while loading
      error: (_, _) => false, // Default on error
    );
  }

  Future<void> toggle() async {
    final bool newStatus = !state;

    try {
      // Optimistic update
      state = newStatus;

      // API call to update backend
      await _apiClient.handleRequest<dynamic>(
        httpMethod: HttpMethod.patch,
        endpoint: ApiEndpoints.riderAvailability,
        data: <String, bool>{'isOnline': newStatus},
      );

      // Optionally refresh profile to sync with backend
      // ref.read(riderProfileProvider.notifier).refreshProfile();
    } catch (e) {
      // Revert on error
      state = !newStatus;
      // Show error toast if needed
      Toast.showError('Failed to update status');
    }
  }

  // Optional: Direct setter (if needed elsewhere)
  Future<void> setOnline(bool isOnline) async {
    if (isOnline == state) {
      return;
    }
    await toggle();
  }
}
