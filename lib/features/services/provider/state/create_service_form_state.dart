import '../models/create_service_request.dart';
import '../models/product_category_form.dart';

class CreateServiceFormState {
  final String serviceCategoryId;
  final String description;
  final String estimateTime;
  final List<ProductCategoryForm> productCategories;
  final bool isSubmitting;
  final Map<String, String> errors;

  CreateServiceFormState({
    this.serviceCategoryId = '',
    this.description = '',
    this.estimateTime = '',
    this.productCategories = const <ProductCategoryForm>[],
    this.isSubmitting = false,
    this.errors = const <String, String>{},
  });

  CreateServiceFormState copyWith({
    String? serviceCategoryId,
    String? description,
    String? estimateTime,
    List<ProductCategoryForm>? productCategories,
    bool? isSubmitting,
    Map<String, String>? errors,
  }) {
    return CreateServiceFormState(
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      description: description ?? this.description,
      estimateTime: estimateTime ?? this.estimateTime,
      productCategories: productCategories ?? this.productCategories,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errors: errors ?? this.errors,
    );
  }

  bool get isValid =>
      serviceCategoryId.isNotEmpty &&
      description.trim().length >= 10 &&
      estimateTime.isNotEmpty &&
      productCategories.every((ProductCategoryForm pc) => pc.isValid) &&
      errors.isEmpty;

  CreateServiceRequest toRequest() {
    return CreateServiceRequest(
      serviceCategoryId: serviceCategoryId,
      description: description.trim(),
      estimateTime: estimateTime.trim(),
      productCategories: productCategories
          .map((ProductCategoryForm pc) => pc.toItem())
          .toList(),
    );
  }
}
