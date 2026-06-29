// location_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/toast/toast.dart';
import '../models/location_update_response.dart';

class LocationNotifier extends AutoDisposeNotifier<DateTime?> {
  late final ApiClient _apiClient;

  @override
  DateTime? build() {
    _apiClient = ref.read(apiClientProvider);
    return null;
  }

  Future<void> updateRiderLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      state = DateTime.now(); // Optimistic update

      final LocationUpdateResponse response = await _apiClient
          .handleRequest<LocationUpdateResponse>(
            httpMethod: HttpMethod.patch,
            endpoint: ApiEndpoints.riderLocation,
            fromJson: LocationUpdateResponse.fromJson,
            data: <String, double>{
              'latitude': latitude,
              'longitude': longitude,
            },
          );

      Toast.showSuccess(response.message);

      // Optionally refresh profile
      // ref.read(riderProfileProvider.notifier).refreshProfile();
    } catch (e) {
      state = null;
      Toast.showError(ExceptionHandler.errorMessage(e));
      rethrow;
    }
  }
}
