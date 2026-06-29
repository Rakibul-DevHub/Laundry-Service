// ignore_for_file: always_specify_types

class ProductCategory {
  final String id;
  final String name;
  final String slug;
  final int sortOrder;
  final bool isActive;

  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.sortOrder,
    required this.isActive,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      sortOrder: json['sortOrder'] as int,
      isActive: json['isActive'] as bool,
    );
  }
}

class ProductCategoriesResponse {
  final int code;
  final bool success;
  final String message;
  final List<ProductCategory> data;

  ProductCategoriesResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return ProductCategoriesResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => ProductCategory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
