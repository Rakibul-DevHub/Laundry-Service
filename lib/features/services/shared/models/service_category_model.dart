// ignore_for_file: always_specify_types

class ServiceCategory {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final bool isActive;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.isActive,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: (json['icon'] as String).trim(),
      isActive: json['isActive'] as bool,
    );
  }
}

class ServiceCategoriesResponse {
  final int code;
  final bool success;
  final String message;
  final List<ServiceCategory> data;

  ServiceCategoriesResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCategoriesResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => ServiceCategory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
