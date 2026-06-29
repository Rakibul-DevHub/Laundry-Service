import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../models/product_category_model.dart';

class ProductCategoryNotifier
    extends AutoDisposeNotifier<AsyncValue<List<ProductCategory>>> {
  late final ApiClient _apiClient;

  @override
  AsyncValue<List<ProductCategory>> build() {
    _apiClient = ref.read(apiClientProvider);
    fetchCategories();
    return const AsyncValue<List<ProductCategory>>.loading();
  }

  Future<void> fetchCategories() async {
    state = const AsyncValue<List<ProductCategory>>.loading();
    try {
      final ProductCategoriesResponse response = await _apiClient
          .handleRequest<ProductCategoriesResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.productCategories,
            fromJson: ProductCategoriesResponse.fromJson,
          );
      state = AsyncValue<List<ProductCategory>>.data(
        response.data.where((ProductCategory c) => c.isActive).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue<List<ProductCategory>>.error(e, stack);
    }
  }
}

final AutoDisposeNotifierProvider<
  ProductCategoryNotifier,
  AsyncValue<List<ProductCategory>>
>
productCategoryProvider =
    NotifierProvider.autoDispose<
      ProductCategoryNotifier,
      AsyncValue<List<ProductCategory>>
    >(
      ProductCategoryNotifier.new,
    );
