import 'package:drop_n_fresh/app/router/app_router.dart';
import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:drop_n_fresh/features/services/provider/providers/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/toast/toast.dart';
import '../models/service_detail_response.dart';
import '../models/service_list_response.dart';
import '../models/update_service_request.dart';
import '../models/update_service_response.dart';

class ServiceDetailNotifier
    extends AutoDisposeFamilyAsyncNotifier<ProviderService, String> {
  late final ApiClient _apiClient;

  @override
  Future<ProviderService> build(String serviceId) async {
    _apiClient = ref.read(apiClientProvider);
    return _fetchService(serviceId);
  }

  Future<ProviderService> _fetchService(String serviceId) async {
    final ServiceDetailResponse response = await _apiClient
        .handleRequest<ServiceDetailResponse>(
          httpMethod: HttpMethod.get,
          endpoint: '${ApiEndpoints.providerServices}/$serviceId',
          fromJson: ServiceDetailResponse.fromJson,
        );

    return response.data;
  }

  Future<void> refresh(String serviceId) async {
    state = const AsyncValue<ProviderService>.loading();
    state = await AsyncValue.guard(() => _fetchService(serviceId));
  }

  Future<bool> updateService(
    String serviceId,
    UpdateServiceRequest request,
  ) async {
    try {
      final UpdateServiceResponse response = await _apiClient
          .handleRequest<UpdateServiceResponse>(
            httpMethod: HttpMethod.put,
            endpoint: '${ApiEndpoints.providerServices}/$serviceId',
            fromJson: UpdateServiceResponse.fromJson,
            data: request.toJson(),
          );
      state = AsyncValue<ProviderService>.data(response.data);
      ref.read(servicesListProvider.notifier).fetchServices();
      Toast.showSuccess(response.message);
      return true;
    } catch (e) {
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
      Toast.showError(ExceptionHandler.errorMessage(e));
      return false;
    }
  }

  Future<void> deleteService(
    String serviceId,
  ) async {
    try {
      final Map<String, dynamic> response = await _apiClient.handleRequest(
        httpMethod: HttpMethod.delete,
        endpoint: '${ApiEndpoints.providerServices}/$serviceId',
      );
      ref
          .read(servicesListProvider.notifier)
          .removeSingleServiceById(serviceId);
      Toast.showSuccess(response['message'] as String);
      ref.read(appRouterProvider).pop();
    } catch (e) {
      AppLogger().e(ExceptionHandler.errorMessage(e), error: e);
      Toast.showError(ExceptionHandler.errorMessage(e));
    }
  }

  void toggleActiveOptimistic(bool newActive) {
    final ProviderService? current = state.value;

    if (current != null) {
      state = AsyncValue<ProviderService>.data(
        current.copyWith(isActive: newActive),
      );
    }
  }
}
