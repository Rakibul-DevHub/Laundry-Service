// features/business/notifiers/provider_business_hours_notifier.dart

import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/features/services/user/models/provider_business_hours_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderBusinessHoursNotifier
    extends
        AutoDisposeFamilyNotifier<
          AsyncValue<ProviderBusinessHoursData>,
          String
        > {
  late final ApiClient _apiClient;

  @override
  AsyncValue<ProviderBusinessHoursData> build(String providerId) {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchBusinessHours(providerId));
    return const AsyncValue<ProviderBusinessHoursData>.loading();
  }

  Future<void> _fetchBusinessHours(String providerId) async {
    state = const AsyncValue<ProviderBusinessHoursData>.loading();

    try {
      final ProviderBusinessHoursResponse response = await _apiClient
          .handleRequest<ProviderBusinessHoursResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.providerBusinessHoursById(providerId),
            fromJson: ProviderBusinessHoursResponse.fromJson,
          );

      state = AsyncValue<ProviderBusinessHoursData>.data(response.data);
      print("asfasdfasa: ${state.toString()}");
    } catch (e, stack) {
      print("asfasdfasa: error: ${e.toString()} ----- ${state.toString()}");
      state = AsyncValue<ProviderBusinessHoursData>.error(
        ExceptionHandler.errorMessage(e),
        stack,
      );
    }
  }

  Future<void> refresh(String providerId) async {
    await _fetchBusinessHours(providerId);
  }
}

final AutoDisposeNotifierProviderFamily<
  ProviderBusinessHoursNotifier,
  AsyncValue<ProviderBusinessHoursData>,
  String
>
providerBusinessHoursProvider = NotifierProvider.autoDispose
    .family<
      ProviderBusinessHoursNotifier,
      AsyncValue<ProviderBusinessHoursData>,
      String
    >(
      ProviderBusinessHoursNotifier.new,
    );
