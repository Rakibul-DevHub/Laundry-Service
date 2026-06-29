import 'package:drop_n_fresh/app/api/api_client.dart';
import 'package:drop_n_fresh/app/providers/app_providers.dart';
import 'package:drop_n_fresh/features/services/user/models/service_products_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceProductsNotifier
    extends
        AutoDisposeFamilyNotifier<
          AsyncValue<List<ServiceProductData>>,
          ServiceProductsArgs
        > {
  // arg = serviceId

  late final ApiClient _apiClient;

  @override
  AsyncValue<List<ServiceProductData>> build(ServiceProductsArgs args) {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchProducts(args));
    return const AsyncValue<List<ServiceProductData>>.loading();
  }

  Future<void> _fetchProducts(ServiceProductsArgs args) async {
    state = const AsyncValue<List<ServiceProductData>>.loading();

    try {
      final ServiceProductsResponse response = await _apiClient
          .handleRequest<ServiceProductsResponse>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.providerServicesProducts(args.providerId),
            fromJson: ServiceProductsResponse.fromJson,
            data: <String, List<String>>{
              'serviceIds': <String>[args.serviceId],
            },
          );

      if (!response.success) {
        throw Exception(response.message);
      }

      state = AsyncValue<List<ServiceProductData>>.data(response.data);
    } catch (e, stack) {
      state = AsyncValue<List<ServiceProductData>>.error(
        ExceptionHandler.errorMessage(e),
        stack,
      );
    }
  }

  Future<void> refresh(ServiceProductsArgs args) async {
    await _fetchProducts(args);
  }
}

final AutoDisposeNotifierProviderFamily<
  ServiceProductsNotifier,
  AsyncValue<List<ServiceProductData>>,
  ServiceProductsArgs
>
serviceProductsProvider = NotifierProvider.autoDispose
    .family<
      ServiceProductsNotifier,
      AsyncValue<List<ServiceProductData>>,
      ServiceProductsArgs
    >(
      ServiceProductsNotifier.new,
    );

@immutable
class ServiceProductsArgs {
  final String serviceId;
  final String providerId;

  const ServiceProductsArgs({
    required this.serviceId,
    required this.providerId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceProductsArgs &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId &&
          providerId == other.providerId;

  @override
  int get hashCode => serviceId.hashCode ^ providerId.hashCode;

  @override
  String toString() =>
      'ServiceProductsArgs(serviceId: $serviceId, providerId: $providerId)';
}
