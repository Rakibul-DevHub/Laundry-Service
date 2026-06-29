import 'package:drop_n_fresh/features/services/provider/providers/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/api/api_client.dart';
import '../../../../app/providers/app_providers.dart';
import '../../../../app/toast/toast.dart';
import '../models/create_service_request.dart';
import '../models/create_service_response.dart';
import '../models/product_category_form.dart';
import '../state/create_service_form_state.dart';

class CreateServiceNotifier
    extends AutoDisposeNotifier<CreateServiceFormState> {
  late final ApiClient _apiClient;

  @override
  CreateServiceFormState build() {
    _apiClient = ref.read(apiClientProvider);
    return CreateServiceFormState();
  }

  // Service Category
  void setServiceCategory(String id) {
    state = state.copyWith(
      serviceCategoryId: id,
      errors: <String, String>{...state.errors}..remove('serviceCategoryId'),
    );
  }

  // Description
  void setDescription(String value) {
    state = state.copyWith(
      description: value,
      errors: <String, String>{...state.errors}..remove('description'),
    );
  }

  void validateDescription() {
    if (state.description.trim().length < 10) {
      state = state.copyWith(
        errors: <String, String>{
          ...state.errors,
          'description': 'Description must be at least 10 characters',
        },
      );
    }
  }

  // Estimate Time
  void setEstimateTime(String value) {
    state = state.copyWith(
      estimateTime: value,
      errors: <String, String>{...state.errors}..remove('estimateTime'),
    );
  }

  // Product Categories
  void addProductCategory() {
    final ProductCategoryForm newCategory = ProductCategoryForm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    state = state.copyWith(
      productCategories: <ProductCategoryForm>[
        ...state.productCategories,
        newCategory,
      ],
    );
  }

  void updateProductCategory(String id, String productCategoryId) {
    final List<ProductCategoryForm> updated = state.productCategories.map((
      ProductCategoryForm pc,
    ) {
      if (pc.id == id) {
        return pc.copyWith(productCategoryId: productCategoryId, error: null);
      }
      return pc;
    }).toList();
    state = state.copyWith(productCategories: updated);
  }

  void removeProductCategory(String id) {
    state = state.copyWith(
      productCategories: state.productCategories
          .where((ProductCategoryForm pc) => pc.id != id)
          .toList(),
    );
  }

  // Items within a Product Category
  void addItem(String productCategoryFormId) {
    final List<ProductCategoryForm> updated = state.productCategories.map((
      ProductCategoryForm pc,
    ) {
      if (pc.id == productCategoryFormId) {
        return pc.copyWith(
          items: <ServiceItem>[
            ...pc.items,
            ServiceItem(name: '', price: 0),
          ],
        );
      }
      return pc;
    }).toList();
    state = state.copyWith(productCategories: updated);
  }

  void updateItem(
    String productCategoryFormId,
    int itemIndex,
    ServiceItem updatedItem,
  ) {
    final List<ProductCategoryForm> updated = state.productCategories.map((
      ProductCategoryForm pc,
    ) {
      if (pc.id == productCategoryFormId) {
        final List<ServiceItem> newItems = List<ServiceItem>.from(pc.items);
        newItems[itemIndex] = updatedItem;
        return pc.copyWith(items: newItems);
      }
      return pc;
    }).toList();
    state = state.copyWith(productCategories: updated);
  }

  void removeItem(String productCategoryFormId, int itemIndex) {
    final List<ProductCategoryForm> updated = state.productCategories.map((
      ProductCategoryForm pc,
    ) {
      if (pc.id == productCategoryFormId) {
        final List<ServiceItem> newItems = List<ServiceItem>.from(pc.items)
          ..removeAt(itemIndex);
        return pc.copyWith(items: newItems);
      }
      return pc;
    }).toList();
    state = state.copyWith(productCategories: updated);
  }

  // Validation
  bool validateForm() {
    final Map<String, String> errors = <String, String>{};

    if (state.serviceCategoryId.isEmpty) {
      errors['serviceCategoryId'] = 'Please select a service category';
    }
    if (state.description.trim().length < 10) {
      errors['description'] = 'Description must be at least 10 characters';
    }
    if (state.estimateTime.isEmpty) {
      errors['estimateTime'] = 'Please enter estimate time';
    }
    if (state.productCategories.isEmpty) {
      errors['productCategories'] = 'Add at least one product category';
    } else {
      for (final ProductCategoryForm pc in state.productCategories) {
        if (pc.productCategoryId.isEmpty) {
          errors['productCategory_${pc.id}'] = 'Select a product category';
        }
        if (pc.items.isEmpty) {
          errors['items_${pc.id}'] = 'Add at least one item';
        } else {
          for (int i = 0; i < pc.items.length; i++) {
            final ServiceItem item = pc.items[i];
            if (item.name.trim().isEmpty) {
              errors['item_name_${pc.id}_$i'] = 'Item name is required';
            }
            if (item.price <= 0) {
              errors['item_price_${pc.id}_$i'] = 'Price must be greater than 0';
            }
          }
        }
      }
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  // Submit
  Future<bool> submitService() async {
    validateForm();
    if (!state.isValid) {
      return false;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      final CreateServiceRequest request = state.toRequest();
      final CreateServiceResponse response = await _apiClient
          .handleRequest<CreateServiceResponse>(
            httpMethod: HttpMethod.post,
            endpoint: ApiEndpoints.providerServices,
            fromJson: CreateServiceResponse.fromJson,
            data: request.toJson(),
          );
      ref.read(servicesListProvider.notifier).fetchServices();
      if (response.success) {
        Toast.showSuccess(response.message);
        return true;
      } else {
        Toast.showError(response.message);
        return false;
      }
    } catch (e) {
      Toast.showError('Failed to create service: ${e.toString()}');
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  // Reset form
  void resetForm() {
    state = CreateServiceFormState();
  }
}
