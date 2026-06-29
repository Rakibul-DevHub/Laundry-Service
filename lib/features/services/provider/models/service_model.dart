// ignore_for_file: always_specify_types

class ServiceCategorySummary {
  final String id;
  final String name;
  final String slug;
  final String icon;

  ServiceCategorySummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  factory ServiceCategorySummary.fromJson(Map<String, dynamic> json) {
    return ServiceCategorySummary(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: (json['icon'] as String).trim(),
    );
  }
}

class ProductCategorySummary {
  final String id;
  final String name;
  final String slug;
  final int sortOrder;

  ProductCategorySummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.sortOrder,
  });

  factory ProductCategorySummary.fromJson(Map<String, dynamic> json) {
    return ProductCategorySummary(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      sortOrder: json['sortOrder'] as int,
    );
  }
}

class ServiceItem {
  final String id;
  final String serviceProductCategoryId;
  final String name;
  final num price;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceItem({
    required this.id,
    required this.serviceProductCategoryId,
    required this.name,
    required this.price,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['_id'] as String,
      serviceProductCategoryId: json['serviceProductCategoryId'] as String,
      name: json['name'] as String,
      price: _parseNum(json['price'], isCent: true),
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static num _parseNum(dynamic value, {bool isCent = false}) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return isCent ? (value / 100) : value;
    }
    if (value is String) {
      return isCent
          ? ((num.tryParse(value) ?? 0) / 100)
          : num.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'serviceProductCategoryId': serviceProductCategoryId,
      'name': name,
      'price': price * 100,
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }

  ServiceItem copyWith({
    String? name,
    num? price,
    bool? isActive,
  }) {
    return ServiceItem(
      id: id,
      serviceProductCategoryId: serviceProductCategoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ProductCategoryWithItems {
  final String id;
  final String providerServiceId;
  final ProductCategorySummary productCategory;
  final bool isEnabled;
  final List<ServiceItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductCategoryWithItems({
    required this.id,
    required this.providerServiceId,
    required this.productCategory,
    required this.isEnabled,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategoryWithItems.fromJson(Map<String, dynamic> json) {
    return ProductCategoryWithItems(
      id: json['_id'] as String,
      providerServiceId: json['providerServiceId'] as String,
      productCategory: ProductCategorySummary.fromJson(
        json['productCategoryId'] as Map<String, dynamic>,
      ),
      isEnabled: json['isEnabled'] as bool,
      items: (json['items'] as List)
          .map((item) => ServiceItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'providerServiceId': providerServiceId,
      'productCategoryId': productCategory.id,
      'isEnabled': isEnabled,
      'items': items.map((ServiceItem item) => item.toJson()).toList(),
    };
  }

  ProductCategoryWithItems copyWith({
    bool? isEnabled,
    List<ServiceItem>? items,
  }) {
    return ProductCategoryWithItems(
      id: id,
      providerServiceId: providerServiceId,
      productCategory: productCategory,
      isEnabled: isEnabled ?? this.isEnabled,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
