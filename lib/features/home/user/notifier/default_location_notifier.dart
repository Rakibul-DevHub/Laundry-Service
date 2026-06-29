// features/location/user/notifiers/default_location_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/default_location_model.dart';

class DefaultLocationNotifier
    extends AutoDisposeNotifier<AsyncValue<UserLocation?>> {
  late final ApiClient _apiClient;

  @override
  AsyncValue<UserLocation?> build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => fetchDefaultLocation());
    return const AsyncValue<UserLocation?>.loading();
  }

  Future<void> fetchDefaultLocation() async {
    state = const AsyncValue<UserLocation?>.loading();

    try {
      final DefaultLocationResponse response = await _apiClient
          .handleRequest<DefaultLocationResponse>(
            httpMethod: HttpMethod.get,
            endpoint:
                ApiEndpoints.userLocationsDefault,
            fromJson: DefaultLocationResponse.fromJson,
          );

      if (!response.success) {
        state = const AsyncValue<UserLocation?>.data(null);
        return;
      }

      state = AsyncValue<UserLocation?>.data(response.data);
    } catch (e, stack) {
      AppLogger().e(
        'Failed to fetch default location: $e',
        error: e,
        stackTrace: stack,
      );
      state = const AsyncValue<UserLocation?>.data(null);
    }
  }

  Future<void> refresh() async {
    await fetchDefaultLocation();
  }

  void clear() {
    state = const AsyncValue<UserLocation?>.data(null);
  }
}

final AutoDisposeNotifierProvider<
  DefaultLocationNotifier,
  AsyncValue<UserLocation?>
>
defaultLocationProvider =
    NotifierProvider.autoDispose<
      DefaultLocationNotifier,
      AsyncValue<UserLocation?>
    >(
      DefaultLocationNotifier.new,
    );
