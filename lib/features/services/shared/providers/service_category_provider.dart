import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../models/service_category_model.dart';

class ServiceCategoryNotifier
    extends AutoDisposeNotifier<AsyncValue<List<ServiceCategory>>> {
  late final ApiClient _apiClient;

  @override
  AsyncValue<List<ServiceCategory>> build() {
    _apiClient = ref.read(apiClientProvider);
    fetchCategories();
    return const AsyncValue<List<ServiceCategory>>.loading();
  }

  Future<void> fetchCategories() async {
    state = const AsyncValue<List<ServiceCategory>>.loading();
    try {
      final ServiceCategoriesResponse response = await _apiClient
          .handleRequest<ServiceCategoriesResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.serviceCategories,
            fromJson: ServiceCategoriesResponse.fromJson,
          );
      state = AsyncValue<List<ServiceCategory>>.data(
        response.data.where((ServiceCategory c) => c.isActive).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue<List<ServiceCategory>>.error(
        ExceptionHandler.errorMessage(e),
        stack,
      );
    }
  }
}

final AutoDisposeNotifierProvider<
  ServiceCategoryNotifier,
  AsyncValue<List<ServiceCategory>>
>
serviceCategoryProvider =
    NotifierProvider.autoDispose<
      ServiceCategoryNotifier,
      AsyncValue<List<ServiceCategory>>
    >(
      ServiceCategoryNotifier.new,
    );
