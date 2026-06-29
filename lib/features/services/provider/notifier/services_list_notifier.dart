import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../models/service_list_response.dart';

class ServicesListNotifier
    extends AutoDisposeNotifier<AsyncValue<List<ProviderService>>> {
  late final ApiClient _apiClient;

  @override
  AsyncValue<List<ProviderService>> build() {
    _apiClient = ref.read(apiClientProvider);
    fetchServices();
    return const AsyncValue<List<ProviderService>>.loading();
  }

  Future<void> fetchServices() async {
    state = const AsyncValue<List<ProviderService>>.loading();
    try {
      final ServicesListResponse response = await _apiClient
          .handleRequest<ServicesListResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.providerServices,
            fromJson: ServicesListResponse.fromJson,
          );
      state = AsyncValue<List<ProviderService>>.data(
        response.data.where((ProviderService s) => !s.isDeleted).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue<List<ProviderService>>.error(e, stack);
    }
  }

  // In ServicesListNotifier class

  Future<void> removeSingleServiceById(String id) async {
    final List<ProviderService>? currentServices = state.value;
    if (currentServices == null) {
      return;
    }

    final List<ProviderService> updatedServices = currentServices
        .where((ProviderService service) => service.id != id)
        .toList();

    state = AsyncValue<List<ProviderService>>.data(updatedServices);
  }

  // Optimistic update for toggle active
  void toggleServiceActive(String serviceId, bool newActive) {
    final List<ProviderService>? current = state.value;
    if (current == null) {
      return;
    }

    state = AsyncValue<List<ProviderService>>.data(
      current
          .map(
            (ProviderService s) =>
                s.id == serviceId ? s.copyWith(isActive: newActive) : s,
          )
          .toList(),
    );
  }

  void removeService(String serviceId) {
    final List<ProviderService>? current = state.value;
    if (current == null) {
      return;
    }

    state = AsyncValue<List<ProviderService>>.data(
      current.where((ProviderService s) => s.id != serviceId).toList(),
    );
  }
}
