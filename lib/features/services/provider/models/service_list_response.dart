// ignore_for_file: always_specify_types

import 'service_model.dart';

class ProviderService {
  final String id;
  final String providerId;
  final ServiceCategorySummary serviceCategory;
  final String description;
  final String estimateTime;
  final bool isActive;
  final bool isDeleted;
  final List<ProductCategoryWithItems> productCategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProviderService({
    required this.id,
    required this.providerId,
    required this.serviceCategory,
    required this.description,
    required this.estimateTime,
    required this.isActive,
    required this.isDeleted,
    required this.productCategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) {
    return ProviderService(
      id: json['_id'] as String,
      providerId: json['providerId'] as String,
      serviceCategory: ServiceCategorySummary.fromJson(
        json['serviceCategoryId'] as Map<String, dynamic>,
      ),
      description: json['description'] as String,
      estimateTime: json['estimateTime'] as String,
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      productCategories: json['productCategories'] == null
          ? []
          : (json['productCategories'] as List)
                .map(
                  (pc) => ProductCategoryWithItems.fromJson(
                    pc as Map<String, dynamic>? ?? {},
                  ),
                )
                .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ProviderService copyWith({
    String? id,
    String? providerId,
    ServiceCategorySummary? serviceCategory,
    String? description,
    String? estimateTime,
    bool? isActive,
    bool? isDeleted,
    List<ProductCategoryWithItems>? productCategories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProviderService(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      description: description ?? this.description,
      estimateTime: estimateTime ?? this.estimateTime,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      productCategories: productCategories ?? this.productCategories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper: Total items count
  int get totalItems => productCategories.fold(
    0,
    (int sum, ProductCategoryWithItems pc) => sum + pc.items.length,
  );

  // Helper: Active items count
  int get activeItems => productCategories.fold(
    0,
    (int sum, ProductCategoryWithItems pc) =>
        sum + pc.items.where((ServiceItem i) => i.isActive).length,
  );
}

class ServicesListResponse {
  final int code;
  final bool success;
  final String message;
  final List<ProviderService> data;

  ServicesListResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServicesListResponse.fromJson(Map<String, dynamic> json) {
    return ServicesListResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => ProviderService.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
